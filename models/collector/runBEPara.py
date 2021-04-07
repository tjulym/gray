from concurrent.futures import ThreadPoolExecutor
import requests

threadPool = ThreadPoolExecutor(max_workers=30)

flag = True

def post(url, data):
    global flag
    while flag:
        r = requests.post(url, data).text

tasks = []
def run():
    for i in range(10):
        t1 = threadPool.submit(post, 'http://192.168.1.106:30351', '{"loopTime": 300000000}')
        t2 = threadPool.submit(post, 'http://192.168.1.106:30352', '{"file_size": 300, "byte_size": 1024}')
        t3 = threadPool.submit(post, 'http://192.168.1.106:30353', '{"n": 10000}')
        tasks.append(t1)
        tasks.append(t2)
        tasks.append(t3)
    return

def stop():
    global flag
    flag = False
    for t in tasks:
        t.result()
    return
