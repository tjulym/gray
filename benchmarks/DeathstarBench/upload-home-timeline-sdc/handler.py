import json
import redis
import requests
from time import time

home_timeline_redis = "home-timeline-redis.sdc-socialnetwork-db.svc.cluster.local"
get_followers_url = "http://get-followers-sdc.sdc-socialnetwork-func.svc.cluster.local:8080"


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
    #user_mentions_id = event["user_mentions"]

    followers = set()

    t2 = ""

    gft_p = time()
    res = (requests.post(get_followers_url, str(user_id))).text
    gft = time() - gft_p

    if res != "\n":
        ress = res.split(":")
        fs = ress[0]
        t2 = ress[1].replace("\n", "")
        for i in fs.split(","):
            followers.add(str(int(i)))
    #for i in user_mentions_id.split(","):
    #    followers.add(i)

    r = redis.Redis(host=home_timeline_redis, port=6379, decode_responses=True)
    for i in followers:
        r.hset(i, post_id, timestamp)

    #r.hset("end_time", event["req_id"], str(time()))

    return str(time() - start - gft + float(t2)) + "," + t2
