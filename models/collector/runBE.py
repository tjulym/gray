from concurrent.futures import ThreadPoolExecutor
import requests

threadPool = ThreadPoolExecutor(max_workers=3)

flag = True

def post(url, data):
    global flag
    while flag:
        r = requests.post(url, data).text

tasks = []
def run():
    t1 = threadPool.submit(post, 'http://192.168.1.106:30351', '{"loopTime": 300000000}')
    t2 = threadPool.submit(post, 'http://192.168.1.106:30352', '{"file_size": 1000, "byte_size": 1024}')
    t3 = threadPool.submit(post, 'http://192.168.1.106:30353', '{"n": 9000}')
    return

def stop():
    global flag
    flag = False
    return
