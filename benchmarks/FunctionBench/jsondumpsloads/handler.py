import json
#from urllib.request import urlopen
from time import time

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    #event = json.loads(req)
    #link = event['link']

    start = time()
    #f = urlopen(link)
    with open("/home/app/function/prize.json", "r") as f:
        #data = f.read().decode("utf-8")
        data = f.readline()
    network = time() - start

    start = time()
    json_data = json.loads(data)
    str_json = json.dumps(json_data, indent=4)
    latency = time() - start

    #print(str_json)
    return {"IO": network, "serialization": latency}
