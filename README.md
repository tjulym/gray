# Source Code for Partial Interference
---
## Benchmark Installation
1. Deployment guide of OpenFaaS for Kubernetes is available here: https://docs.openfaas.com/deployment/kubernetes/.
2. Run benchmarks /install.sh to build & deploy all functions.

Notice: this operation takes some time.
We can also build & deploy functions according to the description below: https://docs.openfaas.com/cli/build/.

## Workload Generator Installation
Guidance is available here: https://github.com/tjulym/gray/tree/main/loadGen/README.md.

Notice: Be sure that OpenFaaS functions and workload generator work well before running thefollowing script. The project LoadGenSimClient cannot work if the LoadGen has not yet been deployed.

## Metrics Collector
Compile gray/gsightCollector/ to generate a runnable jar package. Then, run
```bash
java -jar collector.jar LC.pod_name interval result_dir_name 192.168.1.1 2222 1 48833
```
to collect metrics of corresponding functions under their solo-run. 
Notice: make sure Intel RDT is enabled and an allocation setting is applied to the pod or container (e.g., cpuset-cpus).
Run 
```bash
./models/collector/start.sh
```
and it will create a csv file that stores the metrics under a co-locating example. You can edit start.sh to set the QPS of LS workloads, edit models/collector/get_ml_data.py to set the amount of data to be collected, and edit models/collector/runBEPara.py to configure tasks that co-locate with the LS of social network.

## Model Training
The initial training dataset is in models/algorithm/data/. Run
```bash
pip install models/algorithm/requirements.txt
```
to install dependencies. Run 
```bash
python models/algorithm/RFR_model_training.py
```
to create a file named "RFR" to store the RM model, and csv file to store importance of the metrics.
Run 
```bash
python models/algorithm/plots_imports.py
```
to review the impurity based importance of the 16 metrics, and run 
```bash
python models/algorithm/plots_imports_all.py
```
to show the importance of 16 metrics under all combinations of workload and server.

## Scheduler
It's quite hard to show the whole system, so we provide an example of binary-search scheduling algorithm instead. The example uses randomly generated states of servers and workloads. And it invokes the actual RFR model trained above for checking SLA violation. Run
```bash
cd scheduler/src
javac util/test/GsightScheduler.java
java util.test.GsightScheduler
```
and it will show the scheduling result.
