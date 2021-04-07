import requests
import sys


if __name__ == "__main__":
    case = int(sys.argv[1])
    QPS = 0
    if case == 0:
        QPS = sys.argv[2]
        print("Start QPS", QPS)
        url = "http://192.168.1.129:8080/LoadGen/startOnlineQuery.do?intensity="+QPS+"&serviceId=12&concurrency=0"
        try:
            requests.get(url, timeout=5)
        except Exception as e:
            pass
    elif case == 1:
        url = "http://192.168.1.129:8080/LoadGen/stopOnlineQuery.do?serviceId=12"
        try:
            requests.get(url, timeout=5)
        except Exception as e:
            pass
