import json
import time

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    event = json.loads(req)

    startTime = GetTime()
    payload = event['payload']
    print(payload)
    commTime = startTime - event['retTime']
    return json.dumps({
        'commTime': commTime
    })

def GetTime():
    return int(round(time.time() * 1000))
