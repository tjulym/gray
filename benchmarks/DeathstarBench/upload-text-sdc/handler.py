import json
import time
import re


def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    start = time.time()

    event = json.loads(req)
    
    req_id = str(event["req_id"])
    text = event["text"]
    
    users_pattern = re.compile(r'@[a-zA-Z0-9-_]+')
    users_match = users_pattern.findall(text)
    users = ''
    for m in users_match:
        users += m[1:] + ","
    users = users[:-1] 
    
    urls_pattern = re.compile(r"(http://|https://)([a-zA-Z0-9_!~*'().&=+$%/-]+)")
    urls_match = urls_pattern.findall(text)
    urls = ''
    for m in urls_match:
        urls += m[0] + m[1] + ","
    urls = urls[:-1]

    res = {}
    res["req_id"] = req_id
    res["user_mentions"] = users

    # add line for sn2
    res["user_id"] = str(event["user_id"])
    res["urls"] = urls  
    res["text"] = text
    res["time"] = time.time() - start 
 
    return json.dumps(res)
