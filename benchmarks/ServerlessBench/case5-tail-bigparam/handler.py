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

    startTime = GetTime()
    payload_size = event['payload_size']
    text = download_file(payload_size)
    downloadTime = GetTime()
    print(text)

    retTime = event['retTime']
    uploadTime = event['uploadTime']
    print("startTime:" + str(startTime))
    print("downloadTime:" + str(downloadTime))
    wholeCommTime = downloadTime - uploadTime
    commTime = startTime - retTime

    # upload_file(payload_size)
    return json.dumps({
        'wholeCommTime': wholeCommTime,
        'commTime': commTime
    })

def download_file(payload_size):
    path = "payload_%d.json" %payload_size
    filepath = "/tmp/%s" %path
    minioClient.fget_object(bucketName, object_name=path, file_path=filepath)
    with open(filepath, 'wb+') as f:
        f.seek(0)
        text = f.read()
        return text

def GetTime():
    return int(round(time.time() * 1000))   
