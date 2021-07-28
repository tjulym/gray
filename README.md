# Source Code for Gray Interference - Open Research Objects Version
---
## Benchmark Installation
1. Deployment guide of OpenFaaS for Kubernetes is available here: https://docs.openfaas.com/deployment/kubernetes/.
2. Run benchmarks /install.sh to build & deploy all functions.

Notice: this operation takes some time.
We can also build & deploy functions according to the description below: https://docs.openfaas.com/cli/build/.

## Workload Generator Installation
Guidance is available here: https://github.com/tjulym/gray/blob/SC21ORO/loadGen/README.md.

Notice: Be sure that OpenFaaS functions and workload generator work well before running thefollowing script. The project LoadGenSimClient cannot work if the LoadGen has not yet been deployed.

## Metrics Collector
Compile gray/gsightCollector/ to generate a runnable jar package. Then, run
```bash
java -jar collector.jar func_name interval result_dir_name 
```
to collect metrics of corresponding functions under their solo-run. Run 
```bash
./models/collector/start.sh
```
and it will create a csv file that stores the metrics under co-locating. You can edit start.sh to set the QPS of LS workloads, edit models/collector/get_ml_data.py to set the amount of data to be collected, and edit models/collector/runBEPara.py to configure tasks that co-locate with the LS of social network.

## Model Training
The initial training dataset is in models/algorithm/data/. Run 
```python
python models/algorithm/RFR_model_training.py
```
and it will create a file named "RFR" to store the RM model, and csv file to store importance of the metrics.
Run 
```python
python models/algorithm/plots_imports.py
```
to review the impurity based importance of the 16 metrics, and run 
```python
python models/algorithm/plots_imports_all.py
```
to show the importance of 16 metrics under all combinations of workload and server.

## Scheduler
