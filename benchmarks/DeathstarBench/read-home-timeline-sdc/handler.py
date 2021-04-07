import json
import redis
import requests
from time import time

home_timeline_redis = "home-timeline-redis.sdc-socialnetwork-db.svc.cluster.local"
read_post_url = "http://read-post-sdc.sdc-socialnetwork-func.svc.cluster.local:8080"


def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    event = json.loads(req)

    req_id = event["req_id"]
    user_id = event["user_id"]
    start = event["start"]
    stop = event["stop"]
    
    if start < stop:
        return ""

    r = redis.Redis(host=home_timeline_redis, port=6379, decode_responses=True)
    post_ids = r.hgetall(user_id).key()[start:stop]

    res = []
    for i in post_ids:
        res.append(requests.post(read_post_url, i).text)

    return res
