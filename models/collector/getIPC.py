import sys
import subprocess
from concurrent.futures import ThreadPoolExecutor, wait
import re

def get_containers(commend):
    res = subprocess.check_output(commend, shell=True).decode()
    cons = res.split("\n")

    cons = [i for i in cons if i != '']
    return cons

def get_con_pids(con_name):
    com = 'docker inspect --format=\'{{.State.Pid}}\' ' + con_name
    res = subprocess.check_output(com, shell=True).decode()
    return res.strip()


def get_IPC(con_ids, file_path):
    cons_str = ",".join(con_ids)
    com = 'perf stat -p ' + cons_str + ' -einstructions -ecycles sleep 10 2> ' + file_path 
    res = subprocess.check_output(com, shell=True).decode()
    return res

threadPool = ThreadPoolExecutor(max_workers=3)

LC_cons = get_containers('docker ps | grep sdc-socialnetwork-func | grep -v POD | grep -v db-op |  grep -v workflow |awk \'{print $NF}\'')
WF_cons = get_containers('docker ps | grep sdc-socialnetwork-func | grep fwatchdog | grep workflow | awk \'{print $NF}\'')
DB_cons = get_containers('docker ps | grep sdc-socialnetwork-db | grep -v POD | awk \'{print $NF}\'')
#BE_cons = get_containers('docker ps | grep sdc-be-func | grep fwatchdog | awk \'{print $NF}\'')

LC_con_ids = [get_con_pids(i) for i in LC_cons]
WF_con_ids = [get_con_pids(i) for i in WF_cons]
DB_con_ids = [get_con_pids(i) for i in DB_cons]
#BE_con_ids = [get_con_pids(i) for i in BE_cons]


def run():
    #print("=== Start IPC ===")
    
    tasks = []
    
    ids_list = [LC_con_ids, WF_con_ids, DB_con_ids]
    
    for ids in ids_list:
        t = threadPool.submit(get_IPC, ids, "IPC-"+str(len(tasks)))
        tasks.append(t)
    
    for t in tasks:
        t.result()
    
    IPCs = []
    for i in range(len(tasks)):
        file_path = "IPC-" + str(i)
        res = []
        with open(file_path, "r") as f:
            res = f.readlines()
        for line in res:
            if "insn per cycle" in line:
                split_line = re.split(r" +", line.strip())
                #print(split_line[-4], len(ids_list[i]))
                IPCs.append(float(split_line[-4]) * len(ids_list[i]))
    
    ave_IPC = sum(IPCs) / sum([len(i) for i in ids_list])
    
    return ave_IPC
