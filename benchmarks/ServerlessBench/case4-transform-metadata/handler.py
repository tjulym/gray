import json
import time

def handle(req):
    """handle a request to the function
    Args:
        req (str): request body
    """
    currentTime = GetTime()
    event = json.loads(req)

    startTimes = event["startTimes"]
    startTimes.append(currentTime)

    response = {}

    ret = {}

    ret["minio_url"] = event["minio_url"]
    ret["access_key"] = event["access_key"]
    ret["secret_key"] = event["secret_key"]
    ret["bucket_name"] = event["bucket_name"]
    ret["img_name"] = event["img_name"]
    ret["startTimes"] = startTimes
    
    commTimes = event["commTimes"]
    commTimes.append(0)
    ret["commTimes"] = commTimes

    args = event["extracted-metadata"]
    if type(args) != dict:
        args = json.loads(args)

    if "EXIF DateTimeOriginal" in args:
        response["creationTime"] = args["EXIF DateTimeOriginal"]

    if ("GPS GPSLatitude" in args) and ("GPS GPSLatitudeRef" in args) and ("GPS GPSLongitude" in args) and ("GPS GPSLongitudeRef" in args):
        latitude  = parseCoordinate(args["GPS GPSLatitude"], args["GPS GPSLatitudeRef"])
        longitude = parseCoordinate(args["GPS GPSLongitude"], args["GPS GPSLongitudeRef"])

        geo = {}
        geo["latitude"] = latitude
        geo["longitude"] = longitude
        response["geo"] = geo

    if "Image Make" in args:
        response["exifMake"] = args["Image Make"]

    if "Image Model" in args:
        response["exifModel"] = args["Image Model"]

    dimensions = {}
    dimensions["width"] = int(args["Image ImageWidth"])
    dimensions["height"] = int(args["Image ImageLength"])
    response["dimensions"] = dimensions

    response["fileSize"] = args["Filesize"]
    response["format"] = args["Mime type"]

    ret["extracted-metadata"] = response

    return json.dumps(ret)

def parseCoordinate(coordinate, coordinateDircetion):
    degreeArray = coordinate[1:-1].split(",")[0].strip().split("/")   
    minuteArray = coordinate[1:-1].split(",")[1].strip().split("/")   
    secondArray = coordinate[1:-1].split(",")[2].strip().split("/")

    if len(degreeArray) == 1:
        degreeArray.append(1)
    if len(minuteArray) == 1:
        minuteArray.append(1)

    ret = {}
    ret["D"] = int(degreeArray[0]) / int(degreeArray[1])
    ret["M"] = int(minuteArray[0]) / int(minuteArray[1])
    ret["S"] = int(secondArray[0]) / int(secondArray[1])
    ret["Direction"] = coordinateDircetion
    return ret 


def GetTime():
    return int(round(time.time() * 1000))
