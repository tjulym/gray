import json
import time

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    event = json.loads(req)

    payload_size = event['payload_size']
    payload = "%s" %(payload_size * '0')
    return json.dumps({
        'payload_size': payload_size,
        'retTime': GetTime(),
        'payload': payload
    })

def GetTime():
    return int(round(time.time() * 1000))
