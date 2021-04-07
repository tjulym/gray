from time import time
from sklearn.feature_extraction.text import TfidfVectorizer

import json
import uuid
import os

tmp = "/tmp/"

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    event = json.loads(req)
    
    input_path = event['input_path']

    result = []
    latency = 0

    with open(input_path) as f:
        body = f.read()
        start = time()
        word = body.replace("'", '').split(',')
        result.extend(word)
        latency += time() - start

    print(len(result))

    tfidf_vect = TfidfVectorizer().fit(result)
    feature = str(tfidf_vect.get_feature_names())
    feature = feature.lstrip('[').rstrip(']').replace(' ' , '')

    feature_key = input_path.split('.')[0]+'-feature.txt'

    with open(feature_key, 'w') as f:
        f.write(feature)
    
    os.remove(input_path)
    os.remove(feature_key)

    return latency
