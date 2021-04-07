import redis
import requests
import json
import time

compose_post_redis = "compose-post-redis.sdc-socialnetwork-db.svc.cluster.local"
get_user_id_url = "http://get-user-id-sdc.sdc-socialnetwork-func.svc.cluster.local:8080"

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    start = time.time()

    event = json.loads(req)

    req_id = str(event["req_id"])
    username = event["username"]
    user_id = str(event["user_id"])

    user_id_query = int(requests.post(get_user_id_url, username).text)

    if user_id_query < 0 or user_id != str(user_id_query):
        return "Unmatched username and user-id"

    creator_str = '{"user_id": ' + user_id + ', "username": "' + username + '"}'

    r = redis.Redis(host=compose_post_redis, port=6379, decode_responses=True)
    r.hset(req_id, "creator", creator_str)
    #hlen_reply = r.hincrby(req_id, "num_components", 1)
    r.expire(req_id, 30)

    return str(time.time() - start)

