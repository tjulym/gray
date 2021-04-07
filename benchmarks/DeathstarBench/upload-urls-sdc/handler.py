import redis
#import requests
import json
import time
import string
import random
#import threading

HOSTNAME = "http://short-url/"

compose_post_redis = "compose-post-redis.sdc-socialnetwork-db.svc.cluster.local"

def gen_random_string(i):
    return "".join(random.sample(string.ascii_letters + string.digits, i))


def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    start = time.time()

    event = json.loads(req)
    
    req_id = str(event["req_id"])
    urls = (event["urls"]).split(",")
    text = event["text"]
    user_id = str(event["user_id"])

    urls_str = ''
    for url in urls:
        shortened_url = HOSTNAME + gen_random_string(10)
        urls_str += '{"shortened_url": ' + shortened_url + ', "expanded_url": "' + url + '"};'
        text = text.replace(url, shortened_url)
    urls_str = urls_str[:-1]
    
    r = redis.Redis(host=compose_post_redis, port=6379, decode_responses=True)
    
    j = {}
    j["urls"] = urls_str
    j["text"] = text
    j["user_id"] = user_id
    #j["user_mentions"] = str(event["user_mentions"])
    r.hset(req_id, "urls", json.dumps(j))
    """
    r.hset(req_id, "urls", urls_str)
    r.hset(req_id, "text", text)
    r.hset(req_id, "user_id", user_id)
    
    r.hset(req_id, "user_mentions", str(event["user_mentions"]))
    """
    #hlen_reply = r.hincrby(req_id, "num_components", 1) 
    r.expire(req_id, 30)    

    """
    if hlen_reply == 5:
        t = threading.Thread(target=send_post, args=(compose_and_upload_url, req_id))
        t.start()
    """

    return str(time.time() - start)
