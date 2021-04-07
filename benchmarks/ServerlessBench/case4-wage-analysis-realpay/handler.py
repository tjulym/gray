import json

TAX = 0.0387
ROLES = ['staff', 'teamleader', 'manager']

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    params = json.loads(req)

    realpay = {'staff': 0, 'teamleader': 0, 'manager': 0}

    for role in ROLES:
        num = params['total']['statistics'][role+'-number']
        if num != 0:
            base = params['base']['statistics'][role]
            merit = params['merit']['statistics'][role]
            
            realpay[role] = (1-TAX) * (base + merit) / num


    params['statistics']['average-realpay'] = realpay
    return json.dumps(params)
