from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
#from sklearn.externals import joblib
import joblib

import pandas as pd
from time import time
import re
import io,os
import json
import uuid
import wget

cleanup_re = re.compile('[^a-z]+')
tmp = '/tmp/'

def cleanup(sentence):
    sentence = sentence.lower()
    sentence = cleanup_re.sub(' ', sentence).strip()
    return sentence


def handle(req):
    event = json.loads(req)
    input_path = event['input_path']
    object_key = event['object_key']
    #model_path = event['model_path']
    model_object_key = event['model_object_key']  # example : lr_model.pk
    
    download_path = tmp+'{}{}'.format(uuid.uuid4(), object_key)
    wget.download(input_path, download_path)
    df = pd.read_csv(download_path)

    start = time()
    df['train'] = df['Text'].apply(cleanup)

    tfidf_vector = TfidfVectorizer(min_df=100).fit(df['train'])
    
    train = tfidf_vector.transform(df['train'])
 
    model = LogisticRegression()
    model.fit(train, df['Score'])
    latency = time() - start
    model_file_path = tmp+'{}{}'.format(uuid.uuid4(), model_object_key)
    joblib.dump(model, model_file_path)
    os.remove(download_path)
    os.remove(model_file_path)
    return latency
