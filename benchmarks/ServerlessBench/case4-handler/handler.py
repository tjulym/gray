import json
import time
import io

from minio import Minio
from PIL import Image

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    currentTime = GetTime()
    event = json.loads(req)

    startTimes = event["startTimes"]
    startTimes.append(currentTime)

    response = event.copy()

    minio_url = event["minio_url"]
    access_key = event["access_key"]
    secret_key = event["secret_key"]
    bucket_name = event["bucket_name"]
    img_name = event["img_name"]

    response["startTimes"] = startTimes

    logid = str(time.time_ns())
   
    db_begin = GetTime() 
    minioClient = Minio(minio_url,access_key=access_key,secret_key=secret_key,secure=False)
    filepath = "/tmp/{}-{}".format(logid, img_name)
    filepath2 = "/tmp/{}-{}-{}".format(logid, "handle", img_name)
    minioClient.fget_object(bucket_name, object_name=img_name, file_path=filepath)

    db_finish = GetTime()
    db_elapse_ms = db_finish - db_begin

    commTimes = event["commTimes"]
    commTimes.append(db_elapse_ms)
    response["commTimes"] = commTimes

    with Image.open(filepath) as image:
        img = image.convert('L')
        img.save(filepath2)

    minioClient.fput_object(bucket_name, object_name=logid+"-"+img_name, file_path=filepath2)
    minioClient.remove_object(bucket_name, object_name=logid+"-"+img_name)

    log = json.dumps({
        "_id": logid,
        "img": img_name
    })

    log_as_bytes = log.encode('utf-8')
    log_as_a_stream = io.BytesIO(log_as_bytes)

    minioClient=Minio(minio_url,access_key=access_key,secret_key=secret_key,secure=False)
    minioClient.put_object(bucket_name, logid, log_as_a_stream, len(log_as_bytes))

    response["log"] = logid

    return json.dumps(response)

def GetTime():
    return int(round(time.time() * 1000))

