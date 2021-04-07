import json
import time

from minio import Minio

minioClient=Minio('192.168.1.109:32153',access_key='4a6212940934127601251f0c1092ae519128a348',secret_key='af070373e248ff40f607e2b81becc260fb8f88e1',secure=False)
bucketName = "serverlessbench"

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    event = json.loads(req)

    payload_size = event['payload_size']
    uploadTime = GetTime()
    upload_file(payload_size)
    return json.dumps({
        'payload_size': payload_size,
        'uploadTime': uploadTime,
        'retTime': GetTime()
    })

def upload_file(payload_size):
    path = "payload_%d.json" %payload_size
    filepath = "/tmp/%s" %path
    param = "{\n\t\"payload\":"
    f = open(filepath, 'w')
    f.write(param + "\"%s\"\n}" %(payload_size * '0'))
    f.close()
    minioClient.fput_object(bucketName, object_name=path, file_path=filepath)

def GetTime():
    return int(round(time.time() * 1000))   
