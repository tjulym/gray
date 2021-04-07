import redis
import json
import time

compose_post_redis = "compose-post-redis.sdc-socialnetwork-db.svc.cluster.local"

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    start = time.time()

    event = json.loads(req)
    
    req_id = str(event["req_id"])
    media_ids = (event["media_ids"]).split(",")
    media_types = (event["media_types"]).split(",")
    media_num = len(media_ids)

    media_str = ''
    for i in range(media_num):
        media_str += '{"media_id": ' + str(media_ids[i]) + ', "media_type": "' + str(media_types[i]) + '"};'
    media_str = media_str[:-1]
    
    r = redis.Redis(host=compose_post_redis, port=6379, decode_responses=True)
    r.hset(req_id, "media", media_str)
    #hlen_reply = r.hincrby(req_id, "num_components", 1)
    r.expire(req_id, 30)
 
    return str(time.time() - start)
