import time
import os
import random
from multiprocessing import Process, Pipe
import json
import uuid

from minio import Minio

minioClient=Minio('192.168.1.109:32153',access_key='4a6212940934127601251f0c1092ae519128a348',secret_key='af070373e248ff40f607e2b81becc260fb8f88e1',secure=False)

bucketName = "serverlessbench"
defaultKey = "loopTime.txt"
defaultLoopTime = 10000000
defaultParallelIndex = 100

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    event = json.loads(req)
    startTime = GetTime()
    if 'key' in event:
        key = event['key']
    else:
        key = defaultKey

    filepath = "/tmp/{}-{}".format(uuid.uuid4(), "loopTime.txt")
    download_file(key, filepath)
    loopTime = extractLoopTime(filepath)

    retTime = GetTime()
    return json.dumps({
        "startTime": startTime,
        "retTime": retTime,
        "execTime": retTime - startTime,
        "loopTime": loopTime,
        "key": key
    })

def download_file(key, filepath):
    minioClient.fget_object(bucketName, object_name=key, file_path=filepath)

def extractLoopTime(filepath):
    txtfile = open(filepath, 'rb')
    loopTime = int(txtfile.readline())
    print("loopTime: " + str(loopTime))
    txtfile.close()
    os.remove(filepath)
    return loopTime

def GetTime():
    return int(round(time.time() * 1000))
