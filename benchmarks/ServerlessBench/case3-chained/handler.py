import json
import time

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    event = json.loads(req)

    startTime = GetTime()
    startTimes = []
    retTimes = []
    startTimes.append(startTime)

    if "startTimes" in event:
        startTimes.extend(event["startTimes"])

    if "retTimes" in event:
        retTimes.append(GetTime())
        return json.dumps({
            "n": event["n"] + 1,
            "startTimes": startTimes,
            "retTimes": retTimes + event["retTimes"]
        })
    else:
        retTimes.append(GetTime())
        return json.dumps({
            "n": event["n"] + 1,
            "startTimes": startTimes,
            "retTimes": retTimes
        })

def GetTime():
    return int(round(time.time() * 1000))

