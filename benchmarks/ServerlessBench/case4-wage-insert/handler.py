import json
import requests
import time
import random
import string

wage_format_url = "http://192.168.1.109:31112/function/case4-wage-format"

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    event = json.loads(req)

    id = time.time_ns()
    event["id"] = id

    if ("name" not in event) or (type(event["name"] != str)):
        event["name"] = "".join(random.sample(string.digits+string.ascii_lowercase+string.ascii_uppercase, 8))

    roles=["staff", "manager", "teamleader"]
    if ("role" not in event) or (event["role"] not in roles):
        event["role"] = roles[random.randint(0, len(roles)-1)]

    bases = [5000, 8000, 8000]
    if ("base" not in event) or (type(event["base"]) != int) or (event["base"] < 10) or (event["base"] > 100000000):
        event["base"] = bases[random.randint(0, len(bases)-1)]


    merit_max=[5000, 10000, 50000]
    if ("merit" not in event) or (type(event["merit"]) != int) or (event["merit"] < 10) or (event["merit"] > 100000000): 
        event["merit"] = id % merit_max[random.randint(0, len(merit_max)-1)]

    if "operator" not in event:
        event["operator"] = 0

    return requests.post(wage_format_url, json.dumps(event)).text 
