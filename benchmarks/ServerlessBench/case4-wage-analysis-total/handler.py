import json

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    event = json.loads(req)

    stats = {'total': event['total']['statistics']['total'] }

    event['statistics'] = stats

    return json.dumps(event)
