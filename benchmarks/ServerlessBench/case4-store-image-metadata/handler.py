import json
import time
import io

from minio import Minio

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    currentTime = GetTime()
    event = json.loads(req)

    startTimes = event["startTimes"]
    startTimes.append(currentTime)

    minio_url = event["minio_url"]
    access_key = event["access_key"]
    secret_key = event["secret_key"]
    bucket_name = event["bucket_name"]
    img_name = event["img_name"]

    extractedMetadata = event["extracted-metadata"]

    db_begin = GetTime()
    minioClient=Minio(minio_url,access_key=access_key,secret_key=secret_key,secure=False)
    log_id = event["log"]
    object_name = log_id + "-extractedMetadata"
    
    em_as_bytes = json.dumps(extractedMetadata).encode('utf-8')
    em_as_a_stream = io.BytesIO(em_as_bytes)

    minioClient.put_object(bucket_name, object_name, em_as_a_stream, len(em_as_bytes))

    db_finish = GetTime()
    db_elapse_ms = db_finish - db_begin

    minioClient.remove_object(bucket_name, object_name)

    originalObj = extractedMetadata.copy()
    originalObj["startTimes"] = startTimes
    commTimes = event["commTimes"]
    commTimes.append(db_elapse_ms)
    originalObj["commTimes"] = commTimes

    originalObj["uploadTime"] = GetTime()    
    originalObj["userID"] = access_key
    originalObj["albumID"] = bucket_name
    originalObj["thumbnail"] = event["thumbnail"]
    originalObj["execution-time"] = event["execution-time"]

    return json.dumps(originalObj)

def GetTime():
    return int(round(time.time() * 1000))
