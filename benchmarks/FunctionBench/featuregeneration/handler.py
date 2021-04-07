import json
from function.feature_extract import handler as extract_handler
from function.feature_reduce import handler as reduce_handler

import os
import sys

BASE_DIR = os.path.dirname(os.path.abspath(__file__))
sys.path.append(BASE_DIR) 

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    #j = extract_handler.handle(req)
    return extract_handler.handle(req)
    #return reduce_handler.handle(j)

