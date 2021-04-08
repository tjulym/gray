from concurrent.futures import ThreadPoolExecutor
import requests
import time

threadPool = ThreadPoolExecutor()


def start_workload(name, delay):
    time.sleep(delay)
    url = "http://192.168.1.129:8080/LoadGen/startOnlineQuery.do?intensity=20&serviceName="+name+"&concurrency=0"
    try:
        requests.get(url, timeout=5)
    except Exception as e:
        pass

def stop_workload(name, delay):
    time.sleep(delay)
    url = "http://192.168.1.129:8080/LoadGen/stopOnlineQuery.do?serviceName="+name
    try:
        requests.get(url, timeout=5)
    except Exception as e:
        pass

if __name__ == "__main__":
    traces = []
    tasks = []

    with open("trace.csv", "r") as f:
        traces = f.readlines()

    for line in traces:
        s = line.split(",")
        start_delay = int(s[0])
        stop_delay = int(s[1])
        service_name = s[2]
        
        start_t = threadPool.submit(start_workload, service_name, start_delay)
        stop_t = threadPool.submit(stop_workload, service_name, stop_delay)

        tasks.append(start_t)
        tasks.append(stop_t)

    for t in tasks:
        t.result()

    print("Done")
