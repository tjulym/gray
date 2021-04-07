from time import time
import pymongo
import json
import hashlib

user_mongo_url = "mongodb://user-mongodb.sdc-socialnetwork-db.svc.cluster.local:27017/"

myclient = pymongo.MongoClient(user_mongo_url)
mydb = myclient['user']
mycol = mydb["user"]

def handle(req):
    mongo_data = json.loads(req)

    myquery = { "username": mongo_data["username"] }
    mydoc = mycol.find(myquery)

    if mydoc.count() == 0:
        return "User " + mongo_data["username"] + " doesn't exist"

    find_res = mydoc.next()
    salt = find_res["salt"]
    hash = hashlib.sha256()
    hash.update((mongo_data["password"]+salt).encode("utf-8"))
    password_hashed = hash.hexdigest()

    if password_hashed == find_res["password"]:
        return "Login Done"
    else:
        return "Password Error"
