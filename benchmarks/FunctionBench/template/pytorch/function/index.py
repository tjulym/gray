import handler

def hello():
    return "hello Iam from  index.py function"

if __name__ == "__main__":
    hello = hello()
    ret = handler.handle(hello)
    if ret is not None:
        print(ret)
