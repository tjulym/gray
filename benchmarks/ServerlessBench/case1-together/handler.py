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
    result1 = {
        "startTime": startTime,
        "retTime": retTime,
        "execTime": retTime - startTime,
        "loopTime": loopTime,
        "key": key
    }
    return alu_handler(result1,"")

def download_file(key, filepath):
    minioClient.fget_object(bucketName, object_name=key, file_path=filepath)

def extractLoopTime(filepath):
    txtfile = open(filepath, 'rb')
    loopTime = int(txtfile.readline())
    print("loopTime: " + str(loopTime))
    txtfile.close()
    os.remove(filepath)
    return loopTime

def alu_handler(event, context):
    startTime = GetTime()
    if 'execTime' in event:
        execTime_prev = event['execTime']
    else:
        execTime_prev = 0
    if 'loopTime' in event:
        loopTime = event['loopTime']
    else:
        loopTime = defaultLoopTime
    parallelIndex = defaultParallelIndex
    temp = alu(loopTime, parallelIndex)
    retTime = GetTime()
    return json.dumps({
        "startTime": startTime,
        "retTime": retTime,
        "execTime": retTime - startTime,
        "result": temp,
        'execTime_prev': execTime_prev
    })

def doAlu(times, childConn, clientId):
    a = random.randint(10, 100)
    b = random.randint(10, 100)
    temp = 0
    for i in range(times):
        if i % 4 == 0:
            temp = a + b
        elif i % 4 == 1:
            temp = a - b
        elif i % 4 == 2:
            temp = a * b
        else:
            temp = a / b
    print(times)
    childConn.send(temp)
    childConn.close()
    return temp

def alu(times, parallelIndex):
    per_times = int(times / parallelIndex)
    threads = []
    childConns = []
    parentConns = []
    for i in range(parallelIndex):
        parentConn, childConn = Pipe()
        parentConns.append(parentConn)
        childConns.append(childConn)
        t = Process(target=doAlu, args=(per_times, childConn, i))
        threads.append(t)
    for i in range(parallelIndex):
        threads[i].start()
    for i in range(parallelIndex):
        threads[i].join()
    
    results = []
    for i in range(parallelIndex):
        results.append(parentConns[i].recv())
    return str(results)

def GetTime():
    return int(round(time.time() * 1000))
