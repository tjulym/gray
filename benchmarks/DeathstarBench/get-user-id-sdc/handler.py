from time import time
import pymongo
import memcache

mongo_url = "mongodb://user-mongodb.sdc-socialnetwork-db.svc.cluster.local:27017/"
memcache_url = "user-memcached.sdc-socialnetwork-db.svc.cluster.local:11211"

mc = memcache.Client([memcache_url])
myclient = pymongo.MongoClient(mongo_url)
mydb = myclient['user']
mycol = mydb["user"]

def handle(username):
    user_id = -1

    start = time()

    #mc = memcache.Client([memcache_url])
    mmc_user_id = mc.get(username+":user_id")
    if mmc_user_id != None:
        user_id = mmc_user_id
    else:
        """
        myclient = pymongo.MongoClient(mongo_url)
        mydb = myclient['user']
        mycol = mydb["user"]
        """

        myquery = { "username": username }
        mydoc = mycol.find(myquery)
        if mydoc.count() > 0:
            it = mydoc.next()
            if "user_id" in it.keys():
                user_id = it["user_id"]
                mc.set(username+":user_id", user_id)

    latency = time() - start
    #print(latency)
    return str(user_id)

