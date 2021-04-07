import json
import requests
import time

url = "http://192.168.1.109:31112/function/case3-nested"

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    event = json.loads(req)

    startTime = GetTime()
    startTimes = []
    invokeTimes = []
    retTimes = []

    if event["n"] == 1:
        startTimes.append(startTime)
        retTimes.append(GetTime())
        return json.dumps({ "result": 1, "startTime":startTimes, "retTime":retTimes})

    d = json.dumps({"n": event["n"]-1})
    res = json.loads(requests.post(url, d).text)

    startTimes.append(startTime)
    if "invokeTime" in res:
        retTimes.append(GetTime())
        return json.dumps({ 
            "result": 1 + res["result"], 
            "startTime": startTimes + res["startTime"], 
            "retTime": retTimes + res["retTime"], 
            "invokeTime": invokeTimes + res["invokeTime"]})
    else:
        retTimes.append(GetTime())
        return json.dumps({ 
            "result": 1 + res["result"],
            "startTime": startTimes + res["startTime"],
            "retTime": retTimes + res["retTime"], 
            "invokeTime": invokeTimes})


def GetTime():
    return int(round(time.time() * 1000))
