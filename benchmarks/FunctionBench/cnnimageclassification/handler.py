from tensorflow.python.keras.preprocessing import image
from tensorflow.python.keras.applications.resnet50 import preprocess_input
import numpy as np
import uuid
from time import time

from . import squeezenet
import json, os, wget

tmp = "/tmp/"


def decode_predictions(preds, top=5):
    CLASS_INDEX = None
    with open("/home/app/function/imagenet_class_index.json") as f:
        CLASS_INDEX = json.load(f)

    results = []
    for pred in preds:
        top_indices = pred.argsort()[-top:][::-1]
        result = [tuple(CLASS_INDEX[str(i)]) + (pred[i],) for i in top_indices]
        result.sort(key=lambda x: x[2], reverse=True)
        results.append(result)
    return results


def predict(img_local_path):
    start = time()
    model = squeezenet.SqueezeNet(weights='imagenet')
    img = image.load_img(img_local_path, target_size=(227, 227))
    x = image.img_to_array(img)
    x = np.expand_dims(x, axis=0)
    x = preprocess_input(x)
    preds = model.predict(x)
    res = decode_predictions(preds)
    latency = time() - start
    return latency, res


def handle(req):
    #event = json.loads(req)
    #input_path = event['input_path']
    #object_key = event['object_key']

    download_path = "/home/app/function/test.jpg"
    #download_path = tmp + '{}{}'.format(uuid.uuid4(), object_key)
    #wget.download(input_path, download_path)
        
    latency, result = predict(download_path)
    print(result)
        
    _tmp_dic = {x[1]: {'N': str(x[2])} for x in result[0]}

    #os.remove(download_path)

    return latency

