import pandas as pd
from time import time
import re
import json
import os

tmp = "/tmp/"
cleanup_re = re.compile('[^a-z]+')


def cleanup(sentence):
    sentence = sentence.lower()
    sentence = cleanup_re.sub(' ', sentence).strip()
    return sentence


def handle(req):
    input_path = "/home/app/function/reviews10mb.csv"

    #df = pd.read_csv(input_path)

    start = time()
    #df['Text'] = df['Text'].apply(cleanup)
    text = [cleanup("hello")]
    #text = df['Text'].tolist()
    result = set()
    for item in text:
        result.update(item.split())
    print("Number of Feature : " + str(len(result)))

    feature = str(list(result))
    feature = feature.lstrip('[').rstrip(']').replace(' ', '')
    latency = time() - start
    print(latency)

    #write_key = input_path.split('.')[0] + ".txt"

    #with open(write_key,'w') as f:
        #f.write(feature)

    #j = {"input_path": write_key}
    j = {"feature": feature}
    #os.remove(write_key)
    return json.dumps(j)

