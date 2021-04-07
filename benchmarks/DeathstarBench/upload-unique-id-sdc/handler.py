import redis
#import requests
import json
import time
import string
import random
#import threading

compose_post_redis = "compose-post-redis.sdc-socialnetwork-db.svc.cluster.local"

def gen_random_digits(i):
    return "".join(random.sample(string.digits, i))


def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    start = time.time()

    event = json.loads(req)
    
    req_id = str(event["req_id"])
    #post_id = str(event["post_id"])
    post_type = str(event["post_type"])
    
    machine_id = gen_random_digits(2)
    timestamp = str(int(time.time()*1000) - 1514764800000)[-11:]
    index_id = gen_random_digits(3)
    post_id = machine_id + timestamp + index_id
    
    r = redis.Redis(host=compose_post_redis, port=6379, decode_responses=True)
    r.hset(req_id, "post_id", post_id)
    #r.hset(req_id, "post_type", post_type)
    
    #hlen_reply = r.hincrby(req_id, "num_components", 1)
    r.expire(req_id, 30)    

    """
    if hlen_reply == 5:
        t = threading.Thread(target=send_post, args=(compose_and_upload_url, req_id))
        t.start()
    """
    return str(time.time() - start)
