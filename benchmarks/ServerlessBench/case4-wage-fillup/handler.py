import redis
import json

wage_redis = "10.102.67.246"

wr = redis.Redis(host=wage_redis, port=6379, decode_responses=True)

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    event = json.loads(req)

    total = {
        'statistics': 
        {
            'total': 0,
            'staff-number': 0,
            'teamleader-number': 0,
            'manager-number': 0
        }
    }

    base = {
        'statistics':           
        {
            'staff': 0,
            'teamleader': 0,
            'manager': 0
        }
    }

    merit = {
        'statistics': 
        {
            'staff': 0,
            'teamleader': 0,
            'manager': 0
        }
    }

    records = wr.hgetall("wage-person")

    for id, v in records.items():
        doc = json.loads(v)
        total['statistics']['total'] += doc['total']
        total['statistics'][doc['role']+'-number'] += 1
        base['statistics'][doc['role']] += doc['base']
        merit['statistics'][doc['role']] += doc['merit']

    operator = 0
    if "operator" in event:
        operator = event["operator"]

    return json.dumps({
        'total': total, 
        'base': base, 
        'merit': merit, 
        'operator': operator
    })
