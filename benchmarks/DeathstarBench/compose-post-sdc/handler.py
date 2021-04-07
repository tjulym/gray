import json
import time

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    start = time.time()

    event = json.loads(req)
    
    try:
        req_id = event["req_id"]

        media_ids = (event["media_ids"]).split(",")
        media_types = (event["media_types"]).split(",")
        media_urls = (event["media_urls"]).split(",")
        if not (len(media_ids) == len(media_types) == len(media_urls)):
            return "Unmatched medias"
        
        user_id = event["user_id"]
        username = event["username"]
        text = event["text"]
        post_type = event["post_type"]
    except Exception as e:
        return "Incomplete arguments"

    event["time"] = time.time() - start    
    return json.dumps(event)
