import uuid
from time import time
import cv2

import os
import json
#import wget

tmp = "/tmp/"
FILE_NAME_INDEX = 0

def handle(req):
    #event = json.loads(req)
    #input_path = event['input_path']
    #object_key = event['object_key']

    download_path = '/home/app/function/test.mp4'
    object_key = '{}.mp4'.format(uuid.uuid4())

    #wget.download(input_path, download_path)

    result_path = download_path.split(".")[FILE_NAME_INDEX] + "-output.avi"
    
    start = time()
    video_cap = cv2.VideoCapture(download_path)
    video_writer = cv2.VideoWriter(result_path, cv2.VideoWriter_fourcc(*'XVID'), 20, (int(video_cap.get(3)), int(video_cap.get(4)))) 

    success, frame = video_cap.read()
    while success:
        video_writer.write(frame)
        success, frame = video_cap.read()
    
    #os.remove(download_path)
    os.remove(result_path)
    
    latency = time() - start
    return latency

