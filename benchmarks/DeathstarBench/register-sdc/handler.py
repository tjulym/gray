from time import time
import pymongo
import json
import string
import random
import hashlib

user_mongo_url = "mongodb://user-mongodb.sdc-socialnetwork-db.svc.cluster.local:27017/"

myclient = pymongo.MongoClient(user_mongo_url)
mydb = myclient['user']
mycol = mydb["user"]

sgclient = pymongo.MongoClient("mongodb://social-graph-mongodb.sdc-socialnetwork-db.svc.cluster.local:27017/")
sgdb = sgclient['social-graph']
sgcol = sgdb["social-graph"]

def gen_random_string(i):
    return "".join(random.sample(string.ascii_letters + string.digits, i))

def handle(req):
    mongo_data = json.loads(req)

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

    return "Register Done"
