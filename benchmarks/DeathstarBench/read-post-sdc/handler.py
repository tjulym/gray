import pymongo
import json

mongo_url = "mongodb://post-storage-mongodb.sdc-socialnetwork-db.svc.cluster.local:27017/"


def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    post_id = req
    
    myclient = pymongo.MongoClient(mongo_url)
    mydb = myclient['post']
    mycol = mydb["post"]

    post_query = {"post_id": post_id}
    
    post_doc = mycol.find(post_query)

    if post_query.count() == 0:
        return ""  
    
    return post_doc.next()
