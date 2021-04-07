import pandas as pd
from time import time
import re
import json
import wget
import uuid
import os

tmp = "/tmp/"
cleanup_re = re.compile('[^a-z]+')


def cleanup(sentence):
    sentence = sentence.lower()
    sentence = cleanup_re.sub(' ', sentence).strip()
    return sentence


def handle(req):
    event = json.loads(req)

    input_path = event["input_path"]
    key = event["object_key"]

    download_path = tmp+'{}{}'.format(uuid.uuid4(), key)
    wget.download(input_path, download_path)

    df = pd.read_csv(download_path)

    start = time()
    df['Text'] = df['Text'].apply(cleanup)
    text = df['Text'].tolist()
    result = set()
    for item in text:
        result.update(item.split())
    print("Number of Feature : " + str(len(result)))

    feature = str(list(result))
    feature = feature.lstrip('[').rstrip(']').replace(' ', '')
    latency = time() - start
    print(latency)

    write_key = download_path.split('.')[0] + ".txt"

    with open(write_key,'w') as f:
        f.write(feature)
    
    os.remove(download_path)
    os.remove(write_key)

    return latency

