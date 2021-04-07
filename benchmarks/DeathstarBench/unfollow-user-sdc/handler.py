from time import time
import pymongo
import json

sgclient = pymongo.MongoClient("mongodb://social-graph-mongodb.sdc-socialnetwork-db.svc.cluster.local:27017/")
sgdb = sgclient['social-graph']
sgcol = sgdb["social-graph"]


def handle(req):
    event = json.loads(req)
    user_id = event["user_id"]
    followee_id = event["followee_id"]

    user_query = { "user_id": user_id }
    followee_query = { "user_id": followee_id }
    user_doc = sgcol.find(user_query)
    followee_doc = sgcol.find(followee_query)

    if user_doc.count() > 0 and followee_doc.count() > 0:
        user_j = json.loads(user_doc.next()["followees"])
        user_j.pop(str(followee_id))
        user_update = {"$set": {"followees": json.dumps(user_j)}}
        sgcol.update_one(user_query, user_update)

        followee_j = json.loads(followee_doc.next()["followers"])
        followee_j.pop(str(user_id))
        followee_update = {"$set": {"followers": json.dumps(followee_j)}}
        sgcol.update_one(followee_query, followee_update)
        return "Unfollow Done"
    else:
        return "Invalid user or followee"
