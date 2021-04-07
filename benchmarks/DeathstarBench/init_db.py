import string
import random
import pymongo
import hashlib
from time import time
import json
import subprocess
import sys
import re

urls = {}

def get_db_urls():
    commend = 'kubectl get endpoints -n sdc-socialnetwork-db | tail -n +2'
    res = subprocess.check_output(commend, shell=True).decode()
    res = [i.strip() for i in res.split("\n") if i != '']
    for line in res:
        s = re.split(r"[ ]+", line)
        urls[s[0]] = s[1]
        #print(line.split("\t"))

get_db_urls()

user_mongo_url = "mongodb://" + urls["user-mongodb"] + "/"

myclient = pymongo.MongoClient(user_mongo_url)
mydb = myclient['user']
mycol = mydb["user"]

sgclient = pymongo.MongoClient("mongodb://" + urls["social-graph-mongodb"]  + "/")
sgdb = sgclient['social-graph']
sgcol = sgdb["social-graph"]

def gen_random_string(i):
    return "".join(random.sample(string.ascii_letters + string.digits, i))


def register(idx):
    mongo_data = {"first_name": "first_name_"+idx, "last_name": "last_name_"+idx, "username": "username_"+idx, "password": "password_"+idx, "user_id": int(idx)}


    myquery = { "username": mongo_data["username"] }
    mydoc = mycol.find(myquery)

    if mydoc.count() > 0:
        return "User " + mongo_data["username"] + " already exists"

    salt = gen_random_string(32)
    hash = hashlib.sha256()
    hash.update((mongo_data["password"]+salt).encode("utf-8"))
    password_hashed = hash.hexdigest()

    mongo_data["salt"] = salt
    mongo_data["password"] = password_hashed

    mycol.insert_one(mongo_data)

    sg_data = {"user_id": mongo_data["user_id"], "followees": "{}", "followers": "{}"}
    sgcol.insert_one(sg_data)


def follow(user_id, followee_id):
    user_query = { "user_id": user_id }
    followee_query = { "user_id": followee_id }
    user_doc = sgcol.find(user_query)
    followee_doc = sgcol.find(followee_query)

    if user_doc.count() > 0 and followee_doc.count() > 0:
        timestamp = time()*(10**6)

        user_j = json.loads(user_doc.next()["followees"])
        user_j[str(followee_id)] = timestamp
        user_update = {"$set": {"followees": json.dumps(user_j)}}
        sgcol.update_one(user_query, user_update)

        followee_j = json.loads(followee_doc.next()["followers"])
        followee_j[str(user_id)] = timestamp
        followee_update = {"$set": {"followers": json.dumps(followee_j)}}
        sgcol.update_one(followee_query, followee_update)
    else:
        return "Invalid user or followee"


if __name__ == '__main__':
    user_num = 1000
   
    for i in range(1, user_num+1):
        register(str(i))
    for i in range(1, user_num+1):
        follow(i, (i+1)%user_num)
