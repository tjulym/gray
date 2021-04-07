import pymongo
import random
import string
import hashlib
from time import time
import json
import redis

"""
user_mongo_url = "mongodb://user-mongodb.sdc-socialnetwork-db.svc.cluster.local:27017/"

myclient = pymongo.MongoClient(user_mongo_url)
mydb = myclient['user']
mycol = mydb["user"]
"""

sgclient = pymongo.MongoClient("mongodb://social-graph-mongodb.sdc-socialnetwork-db.svc.cluster.local:27017/")
sgdb = sgclient['social-graph']
sgcol = sgdb["social-graph"]

post_mongodb_url = "mongodb://post-storage-mongodb.sdc-socialnetwork-db.svc.cluster.local:27017/"
#user_timeline_mongodb = "mongodb://user-timeline-mongodb.sdc-socialnetwork-db.svc.cluster.local:27017/"
#user_timeline_redis = "user-timeline-redis.sdc-socialnetwork-db.svc.cluster.local"
home_timeline_redis = "home-timeline-redis.sdc-socialnetwork-db.svc.cluster.local"
compose_post_redis = "compose-post-redis.sdc-socialnetwork-db.svc.cluster.local"

def gen_random_string(i):
    return "".join(random.sample(string.ascii_letters + string.digits, i))

def register(idx):
    mongo_data = {"first_name": "first_name_"+idx, "last_name": "last_name_"+idx, "username": "username_"+idx, "password": "password_"+idx, "user_id": int(idx)}

    """
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
    """
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

def clear():
    pclient = pymongo.MongoClient(post_mongodb_url)
    pdb = pclient['post']
    pcol = pdb["post"]
    pcol.remove({})

    """
    utclient = pymongo.MongoClient(user_timeline_mongodb)
    utdb = utclient['user-timeline']
    utcol = utdb["user-timeline"]
    utcol.remove({})

    utr = redis.Redis(host=user_timeline_redis, port=6379, decode_responses=True)
    for k in utr.keys():
        utr.delete(k)
    """
    htr = redis.Redis(host=home_timeline_redis, port=6379, decode_responses=True)
    for k in htr.keys():
        htr.delete(k)

    cpr = redis.Redis(host=compose_post_redis, port=6379, decode_responses=True)
    for k in cpr.keys():
        cpr.delete(k)

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    if req == "1":
        user_num = 1000

        for i in range(1, user_num+1):
            register(str(i))
        for i in range(1, user_num+1):
            follow(i, (i+1)%user_num)
        return "Init Database Complete"
    else:
        clear()
        return "Clear Result Complete"
