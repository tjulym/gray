import redis
import requests
import json
import time
#import threading

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
    user_mentions = (event["user_mentions"]).split(",")

    user_mentions_str = ''
    for username in user_mentions:
        user_id = int(requests.post(get_user_id_url, username).text)
        if user_id > 0:
            #user_mentions_str += '{"user_id": ' + str(user_id) + ', "username": "' + username + '"};'
            user_mentions_str += str(user_id) + ','
    user_mentions_str = user_mentions_str[:-1]

    r = redis.Redis(host=compose_post_redis, port=6379, decode_responses=True)
    r.hset(req_id, "user_mentions", user_mentions_str)
    #hlen_reply = r.hincrby(req_id, "num_components", 1)
    r.expire(req_id, 30)

    """
    if hlen_reply == 5:
        t = threading.Thread(target=send_post, args=(compose_and_upload_url, req_id))
        t.start()
    """
    return str(time.time() - start)

