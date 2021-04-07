import json
import pymongo
from time import time

sgclient = pymongo.MongoClient("mongodb://social-graph-mongodb.sdc-socialnetwork-db.svc.cluster.local:27017/")
sgdb = sgclient['social-graph']
sgcol = sgdb["social-graph"]

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    start = time()
     
    user_id = int(req)

    """
    sgclient = pymongo.MongoClient("mongodb://10.97.92.163:27017/")
    sgdb = sgclient['social-graph']
    sgcol = sgdb["social-graph"]
    """

    user_query = { "user_id": user_id }
    user_doc = sgcol.find(user_query)

    followers = ''

    if user_doc.count() == 0:
        return followers

    followers_j = json.loads(user_doc.next()["followers"])
    if len(followers_j) > 0:
        followers = ",".join(followers_j.keys())

    followers = followers + ":" + str(time() - start)

    return followers
