import json
import redis

wage_redis = "10.102.67.246"

wr = redis.Redis(host=wage_redis, port=6379, decode_responses=True)

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """

    try:
        wr.hset("statistics", "statistics", req)
    except:
        return "fail to insert"

    return "insert success"
