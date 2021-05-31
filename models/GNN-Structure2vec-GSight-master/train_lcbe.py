import tensorflow as tf
#import matplotlib.pyplot as plt
import numpy as np
from datetime import datetime
from graphnnSiamese import graphnn
from utils import *
import os
import argparse
import json

parser = argparse.ArgumentParser()
parser.add_argument('--device', type=str, default='-1',
        help='visible gpu device')
parser.add_argument('--fea_dim', type=int, default=16,
        help='feature dimension')
parser.add_argument('--embed_dim', type=int, default=64,
        help='embedding dimension')
parser.add_argument('--embed_depth', type=int, default=2,
        help='embedding network depth')
parser.add_argument('--output_dim', type=int, default=64,
        help='output layer dimension')
parser.add_argument('--iter_level', type=int, default=5,
        help='iteration times')
parser.add_argument('--lr', type=float, default=1e-4,
        help='learning rate')
parser.add_argument('--epoch', type=int, default=1,
        help='epoch number')
parser.add_argument('--batch_size', type=int, default=1,
        help='batch size')
parser.add_argument('--load_path', type=str, default=None,
        help='path for model loading, "#LATEST#" for the latest checkpoint')
parser.add_argument('--save_path', type=str,
        default='./saved_model/graphnn-model', help='path for model saving')
parser.add_argument('--log_path', type=str, default=None,
        help='path for training log')




if __name__ == '__main__':
    args = parser.parse_args()
    args.dtype = tf.float32
    print("=================================")
    print(args)
    print("=================================")

    os.environ["CUDA_VISIBLE_DEVICES"]=args.device
    Dtype = args.dtype
    NODE_FEATURE_DIM = args.fea_dim
    EMBED_DIM = args.embed_dim
    EMBED_DEPTH = args.embed_depth
    OUTPUT_DIM = args.output_dim
    ITERATION_LEVEL = args.iter_level
    LEARNING_RATE = args.lr
    MAX_EPOCH = args.epoch
    BATCH_SIZE = args.batch_size
    LOAD_PATH = args.load_path
    SAVE_PATH = args.save_path
    LOG_PATH = args.log_path

    SHOW_FREQ = 1
    TEST_FREQ = 1
    SAVE_FREQ = 5
    # DATA_FILE_NAME = './data/acfgSSL_{}/'.format(NODE_FEATURE_DIM)
    # SOFTWARE=('openssl-1.0.1f-')
    # OPTIMIZATION=('-O0')
    # COMPILER=('armeb-linux')
    # VERSION=('v54',)
    #
    # FUNC_NAME_DICT = {}
    #
    # # Process the input graphs
    # F_NAME = get_f_name(DATA_FILE_NAME, SOFTWARE, COMPILER,
    #         OPTIMIZATION, VERSION)
    #
    # FUNC_NAME_DICT = get_f_dict(F_NAME)
    #
    #
    # Gs, classes = read_graph(F_NAME, FUNC_NAME_DICT, NODE_FEATURE_DIM)
    # print("{} graphs, {} functions".format(len(Gs), len(classes)))
    #
    #
    # if os.path.isfile('data/class_perm.npy'):
    #     perm = np.load('data/class_perm.npy')
    # else:
    #     perm = np.random.permutation(len(classes))
    #     np.save('data/class_perm.npy', perm)
    # if len(perm) < len(classes):
    #     perm = np.random.permutation(len(classes))
    #     np.save('data/class_perm.npy', perm)
    #
    # Gs_train, classes_train, Gs_dev, classes_dev, Gs_test, classes_test =\
    #         partition_data(Gs,classes,[0.8,0.1,0.1],perm)

    #print(classes_train)

    # print("Train: {} graphs, {} functions".format(
    #         len(Gs_train), len(classes_train)))
    # print("Dev: {} graphs, {} functions".format(
    #         len(Gs_dev), len(classes_dev)))
    # print("Test: {} graphs, {} functions".format(
    #         len(Gs_test), len(classes_test)))
    #
    # # Fix the pairs for validation
    # if os.path.isfile('data/valid.json'):
    #     with open('data/valid.json') as inf:
    #         valid_ids = json.load(inf)
    #     valid_epoch = generate_epoch_pair(
    #             Gs_dev, classes_dev, BATCH_SIZE, load_id=valid_ids)
    # else:
    #     valid_epoch, valid_ids = generate_epoch_pair(
    #             Gs_dev, classes_dev, BATCH_SIZE, output_id=True)
    #     with open('data/valid.json', 'w') as outf:
    #         json.dump(valid_ids, outf)

    # Model
    gnn = graphnn(
            N_x = NODE_FEATURE_DIM,
            Dtype = Dtype,
            N_embed = EMBED_DIM,
            depth_embed = EMBED_DEPTH,
            N_o = OUTPUT_DIM,
            ITER_LEVEL = ITERATION_LEVEL,
            lr = LEARNING_RATE
        )
    gnn.init(LOAD_PATH, LOG_PATH)


    # Train
    # auc, fpr, tpr, thres = get_auc_epoch(gnn, Gs_train, classes_train,
    #         BATCH_SIZE, load_data=valid_epoch)
    # gnn.say("Initial training auc = {0} @ {1}".format(auc, datetime.now()))
    # auc0, fpr, tpr, thres = get_auc_epoch(gnn, Gs_dev, classes_dev,
    #         BATCH_SIZE, load_data=valid_epoch)
    # gnn.say("Initial validation auc = {0} @ {1}".format(auc0, datetime.now()))
    s_train_list = []
    s_feature_list = []
    s_label_list = []
    with open("total-result-lc-be-100app-1000-1.csv", "r") as f:
        input_data = f.readlines()

        app_features = []

        for line in input_data:
            features = line.split(",")

            num_app = int((len(features) - 1) / (2 * 16))

            LC_flag = 0
            if "0" == features[0]:
                LC_flag = 1
            elif "0" == features[num_app * 16]:
                LC_flag = 0
            else:
                LC_flag = 2

            co_str = str(LC_flag)

            # print(len(features), len(co_str_all), num_app)

            temp_feature = []
            for i in range(num_app):
                start_index = i * 16
                temp_feature_i = []
                if features[start_index] == '0':
                    start_index += (num_app * 16)
                    if i > 0:
                        co_str = co_str + "1"
                elif i > 0:
                    co_str = co_str + "0"
                if len(app_features) == 0:
                    for j in range(16):
                        temp_feature_i.append(float(features[start_index + j]))
                    temp_feature.append(temp_feature_i)
            if len(app_features) == 0:
                app_features = temp_feature[:]
                s_feature_list.append(app_features)
            else:
                s_feature_list.append(app_features)

            temp_train = []
            for i in range(num_app):
                temp_train_i = []
                for j in range(num_app):
                    if co_str[i] == co_str[j]:
                        temp_train_i.append(1)
                    elif co_str[i] == "2" or co_str[j] == "2":
                        temp_train_i.append(1)
                    else:
                        temp_train_i.append(0)
                temp_train.append(temp_train_i)
            s_train_list.append(temp_train)

            s_label_list.append(float(features[-1]))

    # construct data
    #s_train_list = [[[0,0,1,0],[0,1,0,1],[1,0,1,0],[0,1,0,1]],[[0,0,1,0],[0,1,0,1],[1,0,1,0],[0,1,0,1]]]
    #s_feature_list = [[[0.1,0.5,0.3],[0.1,0.5,0.3],[0.1,0.5,0.3],[0.1,0.5,0.3]],[[0.121,0.51,0.4],[0.1,0.5,0.3],[0.1,0.5,0.3],[0.1,0.5,0.3]]]
    #s_label_list = [1.5,1.3]
    perc = 300
    sub_train_list = s_train_list[:perc]
    sub_feature_list = s_feature_list[:perc]
    sub_label_list = s_label_list[:perc]

    sub_train_test_list = s_train_list[perc:]
    sub_feature_test_list = s_feature_list[perc:]
    sub_label_test_list = s_label_list[perc:]
    best_auc = 0
    MAX_EPOCH = 10
    for i in range(1, MAX_EPOCH+1):
        l = train_epoch(gnn, sub_feature_list, sub_train_list, sub_label_list)
        gnn.say("EPOCH {3}/{0}, loss = {1} @ {2}".format(
            MAX_EPOCH, l, datetime.now(), i))

        if (1):
            auc = get_auc_epoch(gnn, sub_feature_test_list, sub_train_test_list, sub_label_test_list)
            gnn.say("Testing model: test auc = {0} @ {1}".format(
                auc, datetime.now()))
        #     # auc, fpr, tpr, thres = get_auc_epoch(gnn, Gs_dev, classes_dev,
        #     #         BATCH_SIZE, load_data=valid_epoch)
        #     # gnn.say("Testing model: validation auc = {0} @ {1}".format(
        #     #     auc, datetime.now()))
        #
        #     if auc > best_auc:
        #         path = gnn.save(SAVE_PATH+'_best')
        #         best_auc = auc
        #         gnn.say("Model saved in {}".format(path))
        #
        # if (i % SAVE_FREQ == 0):
        #     path = gnn.save(SAVE_PATH, i)
        #     gnn.say("Model saved in {}".format(path))
