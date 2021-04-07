import subprocess
import json

tmp = '/tmp/'

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    event = json.loads(req)
    bs = 'bs='+str(event['bs'])
    count = 'count='+str(event['count'])

    out_fd = open(tmp + 'io_write_logs', 'w')
    dd = subprocess.Popen(['dd', 'if=/dev/zero', 'of=/tmp/out', bs, count], stderr=out_fd)
    dd.communicate()
    
    subprocess.check_output(['ls', '-alh', tmp])

    with open(tmp + 'io_write_logs') as logs:
        result = str(logs.readlines()[2]).replace('\n', '')
        return result
    #return req
