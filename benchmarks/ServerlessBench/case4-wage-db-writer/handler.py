import redis
import json

wage_redis = "10.102.67.246"

wr = redis.Redis(host=wage_redis, port=6379, decode_responses=True)

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    try:
        event = json.loads(req)
    except json.decoder.JSONDecodeError:
        return "Fail to insert. JSONDecodeError"

    id = event["id"]
    try:
        wr.hset("wage-person", id, req)
        #wr.hset("changes", id, req)
    except redis.exceptions.DataError:
        return "Fail to insert. DataError"

    return "Insert success"
