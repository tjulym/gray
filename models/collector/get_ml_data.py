# get matrix data for ML model

import random
import sys
import subprocess
import numpy as np

from getIPC import run as get_IPC
from runBEPara import run as start_BE
from runBEPara import stop as stop_BE


BEs = [0] * 3

def get_containers(commend):
    res = subprocess.check_output(commend, shell=True).decode()
    cons = res.split("\n")

    cons = [i for i in cons if i != '']
    return cons

def bind_cores(con, socket):
    cores = '0-19,40-59'
    if socket == 1:
        cores = '20-39,60-79'
    com = 'docker update ' + con + ' --cpuset-cpus=' + cores  + ' --memory=64g'
    temp_res = subprocess.check_output(com, shell=True).decode()


def clear_result():
    res = subprocess.check_output('curl -d 2 http://127.0.0.1:30400', shell=True).decode()
    return

LC_cons = get_containers('docker ps | grep -E \'sdc-socialnetwork-func|sdc-socialnetwork-db\' | grep -v POD | grep -v db-op | awk \'{print $NF}\'')
BE_cons = get_containers('docker ps | grep sdc-be-func | grep fwatchdog | awk \'{print $NF}\'')

def bind_be_cores(be_index, socket):
    be_name = ''
    if be_index == 0:
        be_name = 'matmul'
    elif be_index == 1:
        be_name = 'sequential-disk-io'
    else:
        be_name = 'alu'
    for con in BE_cons:
        if be_name in con:
            bind_cores(con, socket)

BEs = [
    [5915,75,56,55,3,1,9,0.0378,1.5463,39.9053,0.302,10985.36,26.5,0.3,0.0,0.01],
    [6449,65,47,64,4,1,9,0.0232,1.9005,8.1887,0.0305,910.32,25.91,0.57,225.28,0.01],
    [9368,40,47,34,3,0,5,0.0131,1.9711,34.7152,0.0424,544.98,25.61,0.52,0.0,0.01]
]


LCs = []

for con_name in LC_cons:
    LCs.append({})
    file_path = "mats/" + con_name.split("_")[1]
    lines = []
    with open(file_path, "r") as f:
        lines = f.readlines()
    #print(con_name, len(lines))
    for i in range(len(lines)):
        nums = lines[i].split(",")
        nums = [float(j) for j in nums]
        LCs[-1][(i+1)*10] = nums



num_LCs = 26
num_BEs = 3
num_stat = 16

print(len(LCs[14]), LCs[14])

def get_ave_mat(qps, indexs):
    res = [0] * num_stat
    for i in indexs:
        for j in range(num_stat):
            res[j] += LCs[i][qps][j]
    res = [i/len(indexs) for i in res]
    return res
        


results = []

if __name__ == "__main__":
    global LC_cons, BE_cons
    QPS = int(sys.argv[1])
    print("Start QPS ", QPS)
    #stat = LCs[QPS]

    start_BE()
    plans = set()
    while len(plans) < 10:
        print("Exp", len(plans)+1)

        plan_l = np.random.randint(0, 2, num_LCs + num_BEs)
        plan = "".join([str(i) for i in plan_l])
        while plan in plans:
            plan_l = np.random.randint(0, 2, num_LCs + num_BEs)
            plan = "".join([str(i) for i in plan_l]) 

        LC_mat = [[0] * num_stat, [0] * num_stat]
        BE_mat = []
        
        socket0 = []
        socket1 = []

        for i in range(num_BEs):
            BE_mat.append(LC_mat.copy())

        for i in range(num_LCs):
            index = plan_l[i]
            try:
                bind_cores(LC_cons[i], index)
            except subprocess.CalledProcessError as e:
                print(e)
                LC_cons = get_containers('docker ps | grep -E \'sdc-socialnetwork-func|sdc-socialnetwork-db\' | grep -v POD | grep -v db-op | awk \'{print $NF}\'')
                BE_cons = get_containers('docker ps | grep sdc-be-func | grep fwatchdog | awk \'{print $NF}\'')
                continue
            if index == 0:
                socket0.append(i)
            if index == 1:
                socket1.append(i)
            #LC_mat[index] = stat
        LC_mat[0] = get_ave_mat(QPS, socket0)    
        LC_mat[1] = get_ave_mat(QPS, socket1)    
        
        for i in range(num_BEs):
            index = plan_l[num_LCs + i]
            #bind_cores(BE_cons[i], index)
            try:
                bind_be_cores(i, index)
            except subprocess.CalledProcessError as e:
                print(e)
                LC_cons = get_containers('docker ps | grep -E \'sdc-socialnetwork-func|sdc-socialnetwork-db\' | grep -v POD | grep -v db-op | awk \'{print $NF}\'')
                BE_cons = get_containers('docker ps | grep sdc-be-func | grep fwatchdog | awk \'{print $NF}\'')
                continue
            BE_mat[i][index] = BEs[i]

        try:
            label = get_IPC()
        except subprocess.CalledProcessError as e:
            print(e)
            clear_result()
            continue
 
        plans.add(plan)

        result = []
        for i in range(len(LC_mat)):
            result.extend(LC_mat[i])
            for j in range(len(BE_mat)):
                result.extend(BE_mat[j][i])
        result.append(label)
        #print(len(result), ",".join([str(i) for i in result]))
        with open("result-" + str(QPS) + ".csv", "a") as f:
            f.write(",".join([str(i) for i in result]) + "\n")
        results.append(",".join([str(i) for i in result]))
        

    stop_BE()
    print(len(results))
