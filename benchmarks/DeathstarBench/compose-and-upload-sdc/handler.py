import redis
#import requests
import json
import time
import random
import string
#import threading


compose_post_redis = "compose-post-redis.sdc-socialnetwork-db.svc.cluster.local"

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    start = time.time()

    req_id = req

    r = redis.Redis(host=compose_post_redis, port=6379, decode_responses=True)
   
    hd = r.hgetall(req_id)
    d = json.loads(hd["urls"])
    text = d["text"]
    urls = d["urls"]
    #creator = hd["creator"]
    media = hd["media"]
    #post_id = d["post_id"]
    #post_id = "".join(random.sample(string.digits, 10))
    post_id = hd["post_id"]
    #post_type = d["post_type"]
    #user_mentions = hd["user_mentions"]
    timestamp = (time.time())*(10**6)

    post = {}
    post["req_id"] = req_id
    post["text"] = text
    post["urls"] = urls
    #post["creator"] = creator
    post["media"] = media
    post["post_id"] = post_id
    #post["post_type"] = post_type
    #post["user_mentions"] = user_mentions
    post["timestamp"] = timestamp

    #user_id = (json.loads(creator))["user_id"]
    user_id = d["user_id"]
    post["user_id"] = user_id

    #post["user_mentions_id"] = user_mentions

    post["time"] = time.time() - start 

    return json.dumps(post)
