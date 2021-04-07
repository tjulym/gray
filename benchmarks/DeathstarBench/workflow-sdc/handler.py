import threading
import requests
from time import time
import json
from concurrent.futures import ThreadPoolExecutor, wait
import subprocess
import sys
import re
import random

func_urls = {}

func_names = ["compose-post-sdc", "upload-media-sdc",  "upload-text-sdc", "upload-urls-sdc", "upload-user-mentions-sdc",
 "get-user-id-sdc", "upload-creator-sdc", "upload-unique-id-sdc", "compose-and-upload-sdc", "post-storage-sdc", "upload-home-timeline-sdc",
 "get-followers-sdc", "upload-user-timeline-sdc"]

for func_name in func_names:
    func_urls[func_name] = "http://" + func_name + ".sdc-socialnetwork-func.svc.cluster.local:8080"

timeout = None
threadPool = ThreadPoolExecutor(max_workers=9)


def send_post(func_name, req, l):
    temp_start = time()
    url = func_urls[func_name]
    r = requests.post(url, req).text
    temp_lat = time() - temp_start
    if func_name == "upload-home-timeline-sdc":
        ts = r.split(",")
        l["get-followers-sdc"] = float(ts[0])
    l[func_name] = temp_lat

def upload_text_send_post(req, l):
    temp_start = time()
    upload_text_res = (requests.post(func_urls["upload-text-sdc"], req)).text
    temp_lat = time() - temp_start
    l["upload-text-sdc"] = temp_lat
    #upload_text_res_j = json.loads(upload_text_res)
    #l.append(float(upload_text_res_j["time"]))


    temp_start = time()
    upload_urls_res = (requests.post(func_urls["upload-urls-sdc"], upload_text_res)).text
    temp_lat = time() - temp_start
    l["upload-urls-sdc"] = temp_lat

def sn_flow(req):
    latency = {}
    start = time()

    req = (requests.post(func_urls["compose-post-sdc"], req)).text
    temp_lat = time() - start
    req_j = json.loads(req)
    req_id = str(req_j["req_id"])
    latency["compose-post-sdc"] = temp_lat

    compose_futures = []
    upload_text_future = threadPool.submit(upload_text_send_post, req, latency)
    compose_futures.append(upload_text_future)
    for func_name in ["upload-unique-id-sdc", "upload-media-sdc"]:
        future = threadPool.submit(send_post, func_name, req, latency)
        compose_futures.append(future)
    wait(compose_futures)

    temp_start = time()
    upload_res = (requests.post(func_urls["compose-and-upload-sdc"], req_id)).text
    temp_lat = time() - temp_start
    latency["compose-and-upload-sdc"] = temp_lat

    upload_threads = []

    func_names = ["post-storage-sdc", "upload-home-timeline-sdc"]

    e_futures = []
    for func_name in func_names:
        future = threadPool.submit(send_post, func_name, upload_res, latency)
        e_futures.append(future)

    wait(e_futures)
    #print("end since compose:{}".format(time()-start))
    latency["workflow-sdc"] = time() - start
    return json.dumps(latency)

def handle(req_id):
    """handle a request to the function
    Args:
        req (str): request body
    """
    u1 = random.randint(1, 1000)
    u2 = (u1+1) % 1000
    req = '{"req_id": '+str(req_id)+', "media_ids":"dog777.png,dog7777.png", "media_types":"png,png","media_urls":"http://192.168.1.109/file/dog.jpg,http://192.168.1.109/file/dog.jpg", "user_id": '+str(u1)+', "username":"username_'+str(u1)+'","text":"hello @username_'+str(u2)+', we like http://baidu.com and http://google.com http://baidu.com/s/search http://baidu.com/s/search&dog.jpg baidu.com/s/search&dog.jpg", "post_type": 0}'

    return sn_flow(req)
