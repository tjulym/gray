import pymongo
import redis
import sys
import re
import subprocess

urls = {}

def get_db_urls():
    commend = 'kubectl get endpoints -n sdc-socialnetwork-db | tail -n +2'
    res = subprocess.check_output(commend, shell=True).decode()
    res = [i.strip() for i in res.split("\n") if i != '']
    for line in res:
        s = re.split(r"[ ]+", line)
        urls[s[0]] = s[1]
        #print(line.split("\t"))

get_db_urls()

post_mongodb_url = "mongodb://" + urls["post-storage-mongodb"] + "/"
user_timeline_mongodb = "mongodb://" + urls["user-timeline-mongodb"] + "/"
user_timeline_redis = urls["user-timeline-redis"].split(":")[0]
home_timeline_redis = urls["home-timeline-redis"].split(":")[0]
compose_post_redis = urls["compose-post-redis"].split(":")[0]


if __name__ == '__main__':
    """
    mclient = pymongo.MongoClient(media_mongodb_url)
    mdb = mclient['media']
    mcol = mdb["media"]
    mcol.remove({})
    """

    pclient = pymongo.MongoClient(post_mongodb_url)
    pdb = pclient['post']
    pcol = pdb["post"]
    pcol.remove({})

    utclient = pymongo.MongoClient(user_timeline_mongodb)
    utdb = utclient['user-timeline']
    utcol = utdb["user-timeline"]
    utcol.remove({})

    utr = redis.Redis(host=user_timeline_redis, port=6379, decode_responses=True)
    for k in utr.keys():
        utr.delete(k)

    htr = redis.Redis(host=home_timeline_redis, port=6379, decode_responses=True)    
    for k in htr.keys():
        htr.delete(k)

    cpr = redis.Redis(host=compose_post_redis, port=6379, decode_responses=True)
    for k in cpr.keys():
        cpr.delete(k)
