import pymongo
import redis
import json
from time import time

user_timeline_mongodb = "mongodb://user-timeline-mongodb.sdc-socialnetwork-db.svc.cluster.local:27017/"
user_timeline_redis = "user-timeline-redis.sdc-socialnetwork-db.svc.cluster.local"
read_post_url = "http://read-post-sdc.sdc-socialnetwork-func.svc.cluster.local:8080"


def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    event = json.loads(req)

    user_id = event["user_id"]
    start = event["start"]
    stop = event["stop"]

    if start < stop:
        return ""

    myclient = pymongo.MongoClient(user_timeline_mongodb)
    mydb = myclient['user-timeline']
    mycol = mydb["user-timeline"]

    r = redis.Redis(host=user_timeline_redis, port=6379, decode_responses=True)
    post_ids = r.hgetall(user_id).key()[start:stop]


    res = []
    myquery = { "user_id": user_id }
    mydoc = mycol.find(myquery)

    if mydoc.count() > 0:
        posts_j = json.loads(mydoc.next()["posts"])
        for i in post_ids:
            if i in posts_j:
                res.append(requests.post(read_post_url, i).text)
                r.hset(user_id, i, time()*(10**6))

    #r.hset("end_time", event["req_id"], str(time()))

    return ",".join(res)
