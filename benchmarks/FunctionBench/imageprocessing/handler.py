import uuid
from time import time
from PIL import Image
import json
#import wget
import os

from . import ops

def image_processing(file_name, image_path):
    path_list = []
    start = time()
    with Image.open(image_path) as image:
        tmp = image
        #path_list += ops.flip(image, file_name)
        #path_list += ops.rotate(image, file_name)
        #path_list += ops.filter(image, file_name)
        path_list += ops.gray_scale(image, file_name)
        #path_list += ops.resize(image, file_name)

    latency = time() - start
    return latency, path_list

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    #event = json.loads(req)
    #input_path = event["input_path"]
    #object_key = event['object_key']

    object_key = '{}.jpg'.format(uuid.uuid4())
    download_path = "/home/app/function/test.jpg"
    #download_path = '/tmp/{}{}'.format(uuid.uuid4(), object_key)

    #wget.download(input_path,  download_path)

    latency, path_list = image_processing(object_key, download_path)
   
    #os.remove(download_path)
    for file_path in path_list:
        os.remove(file_path)
    
    return latency
