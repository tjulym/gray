import json
import math
from time import time

def float_operation(N):
    start = time()
    for i in range(0, N):
        sin_i = math.sin(i)
        cos_i = math.cos(i)
        sqrt_i = math.sqrt(i)
    latency = time() - start
    return latency

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    json_req = json.loads(req)
    n = int(json_req['n'])

    latency = float_operation(n)
    return "latency : " + str(latency)
