import pymongo
import redis
import json
from time import time

user_timeline_mongodb = "mongodb://user-timeline-mongodb.sdc-socialnetwork-db.svc.cluster.local:27017/"
user_timeline_redis = "user-timeline-redis.sdc-socialnetwork-db.svc.cluster.local"


def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    start = time()
    event = json.loads(req)

    user_id = event["user_id"]
    post_id = event["post_id"]
    timestamp = event["timestamp"]

    myclient = pymongo.MongoClient(user_timeline_mongodb)
    mydb = myclient['user-timeline']
    mycol = mydb["user-timeline"]

    myquery = { "user_id": user_id }
    mydoc = mycol.find(myquery)

    if mydoc.count() == 0:
        posts_j = {}
        posts_j[str(post_id)] = timestamp
        mydict = {"user_id": user_id, "posts": json.dumps(posts_j)}
        mycol.insert_one(mydict)
    else:
        posts_j = json.loads(mydoc.next()["posts"])
        posts_j[str(post_id)] = timestamp
        posts_update = {"$set": {"posts": json.dumps(posts_j)}}
        mycol.update_one(myquery, posts_update)

    r = redis.Redis(host=user_timeline_redis, port=6379, decode_responses=True)
    r.hset(user_id, post_id, timestamp)

    #r.hset("end_time", event["req_id"], str(time()))

    return str(time() - start)
