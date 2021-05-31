# GNN Interference Prediction for Gsight
This repo provides an implementation of the Gemini network for interference prediction of Gsight, which is inspired from [this paper](https://arxiv.org/abs/1708.06525).

## GNN Architecture
![Image text](https://raw.githubusercontent.com/tjulym/gray/main/models/GNN-Structure2vec-GSight-master/architecture.png)


## Prepration and Data
Unzip the data by running:
```bash
unzip data.zip
```

The network is written using Tensorflow 1.4 in Python 2.7. You can install the dependencies by running:
```bash
pip install -r requirements.txt
```

## Model Implementation
The model is implemented in `graphnnSiamese.py`.

Run the following code to train the model for LS+SC/BG:
```bash
python train_lcbe.py 
```

Run the following code to train the model for SC+SC/BG:
```bash
python train_bebe.py 
```

Run the following code to train the model for LS+LS:
```bash
python train_lclc.py 
```

## Model Result
![Image text](https://raw.githubusercontent.com/tjulym/gray/main/models/GNN-Structure2vec-GSight-master/result.png)