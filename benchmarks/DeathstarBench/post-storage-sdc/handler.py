import pymongo
import json
from time import time

mongo_url = "mongodb://post-storage-mongodb.sdc-socialnetwork-db.svc.cluster.local:27017/"


def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    start = time()

    post = json.loads(req)
    
    myclient = pymongo.MongoClient(mongo_url)
    mydb = myclient['post']
    mycol = mydb["post"]
    
    mycol.insert_one(post)    
    
    """
    time_update = {"$set": {"end_time": str(time())}}
    mycol.update_one(post, time_update)
    """

    return str(time() - start)
