import os
import pickle
import numpy as np
import torch
import rnn
import json

from time import time

parameter_path = "rnn_params.pkl"

with open(parameter_path, 'rb') as pkl:
    params = pickle.load(pkl)

all_categories = params['all_categories']
n_categories = params['n_categories']
all_letters = params['all_letters']
n_letters = params['n_letters']

model_path = "rnn_model.pth"

rnn_model = rnn.RNN(n_letters, 128, n_letters, all_categories, n_categories, all_letters, n_letters)
rnn_model.load_state_dict(torch.load(model_path))
rnn_model.eval()


def handle(req):
    #event = json.loads(req)
    language = "English" #event['language']
    start_letters = "ABC" #event['start_letters']


    # Load pre-processing parameters
    # Check if model parameters are available

    """
    parameter_path = "rnn_params.pkl"

    with open(parameter_path, 'rb') as pkl:
        params = pickle.load(pkl)

    all_categories = params['all_categories']
    n_categories = params['n_categories']
    all_letters = params['all_letters']
    n_letters = params['n_letters']

    model_path = "rnn_model.pth"

    rnn_model = rnn.RNN(n_letters, 128, n_letters, all_categories, n_categories, all_letters, n_letters)
    rnn_model.load_state_dict(torch.load(model_path))
    rnn_model.eval()
    """
    start = time()
    output_names = list(rnn_model.samples(language, start_letters))
    latency = time() - start

    return {'latency': latency, 'predict': output_names}
