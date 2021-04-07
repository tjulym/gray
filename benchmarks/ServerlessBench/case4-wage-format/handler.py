import json
import requests

TAX = 0.0387
INSURANCE = 1500

wage_db_writer_url = "http://192.168.1.109:31112/function/case4-wage-db-writer"

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    event = json.loads(req)

    event['INSURANCE'] = INSURANCE
    total = INSURANCE + event["base"] + event["merit"]
    event["total"] = total
    realpay = (1-TAX) * (event["base"] + event["merit"])
    event['realpay'] = realpay

    return requests.post(wage_db_writer_url, json.dumps(event)).text
