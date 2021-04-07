import numpy as np
from keras.optimizers import Adam, SGD
import tensorflow as tf
import keras as K
import pandas as pd
from keras import Sequential, Model
from keras.layers import Dense, Activation, BatchNormalization, Dropout, Input, Reshape, LeakyReLU, PReLU
from sklearn import preprocessing, ensemble
from sklearn.linear_model import LogisticRegression
from sklearn.svm import SVR
from sklearn.model_selection import GridSearchCV
from sklearn.neighbors import KNeighborsRegressor
from sklearn.externals import joblib
import datetime

class CGAN():
    def __init__(self):
        # self.latent_dim = 64  # function
        # self.latent_dim = 32  # all
        self.latent_dim = 128  # all
        optimizer = SGD(lr=0.1, decay=1.0000)  # KNN、LR、RFR、SVR
        # optimizer = SGD(lr=0.15, decay=1.0000) # NN
        # Build and compile the discriminator
        self.model = self.build_model()
        self.model.compile(loss=['mse'], optimizer=optimizer, metrics=['accuracy'])

    def loaddata(self):
        data_resource_label = pd.read_csv('data/total-result.csv', header=None)
        data_resource_label = data_resource_label.sample(frac=1.0)
        data_resource = data_resource_label.values

        min_max_scalar = preprocessing.MinMaxScaler()
      
        for i in range(0, 128):  # i:0-127
            data_resource[:, i:(i+1)] = min_max_scalar.fit_transform(data_resource[:, i:(i+1)])
        
        print('std is:', np.mean(np.abs(data_resource[:, 128:129] - np.mean(data_resource[:, 128:129]))))


        # 12000:9600,2400
        total_num = len(data_resource)
        train_num = int(0.8 * total_num)
        print("train_num:", train_num)
        data_train_resource = data_resource[0:train_num, 0:128].astype(float)
        data_train_label = data_resource[0:train_num, 128:129].astype(float)
        data_test_resource = data_resource[train_num:total_num - 1, 0:128].astype(float)
        data_test_label = data_resource[train_num:total_num, 128:129].astype(float)

        # -----------------RFR--------------------------#
        regr = ensemble.RandomForestRegressor()
        regr.fit(data_train_resource, data_train_label.ravel())

        startTime = datetime.datetime.now()
        label_pre_train = regr.predict(data_train_resource)
        label_pre_test = regr.predict(data_test_resource)
        endTime = datetime.datetime.now()

        with open("RFR_loss_IPC.csv", "w") as f:
            pass
        for i in range(len(label_pre_test)):
            #print('RFR Testing Loss', np.abs((label_pre_test[i] - data_test_label[i])) / data_test_label[i])
            print(np.abs((label_pre_test[i] - data_test_label[i])) / data_test_label[i], file=open("RFR_loss_IPC.csv", "a"))

        print("#Radom Forest Regression Training Score:%f"%np.mean(np.abs(label_pre_train - data_train_label)))
        print("#Radom Forest Regression Test Score:%f"%np.mean(np.abs(label_pre_test - data_test_label)))

        diffs_train = []
        diffs_test = []
        for i in range(len(label_pre_train)):
            diffs_train.append(np.abs(label_pre_train[i] - data_train_label[i]) / data_train_label[i])
        for i in range(len(label_pre_test)):
            diffs_test.append(np.abs(label_pre_test[i] - data_test_label[i]) / data_test_label[i])
        print("#Ave Training Diff:%f"%np.mean(diffs_train))
        print("#Ave Test Diff:%f"%np.mean(diffs_test))
        print("PredictionTime:", (endTime - startTime))

        # Extract feature importances
        imports = regr.feature_importances_
        print(imports)
        imports_ave = [0] * 16

        for i in range(len(imports_ave)):
            imports_ave[i] = imports[i] + imports[i+64]
        imports_ave = [i/2 for i in imports_ave]
        print(imports_ave)

        tree = regr.estimators_[8]
        from sklearn.tree import export_graphviz
        # 导出为dot 文件
        feature_names = []
        for i in range(16):
            feature_names.append("lc0"+"1"+str(i).zfill(2))
            feature_names.append("be1"+"1"+str(i).zfill(2))
            feature_names.append("be2"+"1"+str(i).zfill(2))
            feature_names.append("be3"+"1"+str(i).zfill(2))
        for i in range(16):
            feature_names.append("lc0"+"2"+str(i).zfill(2))
            feature_names.append("be1"+"2"+str(i).zfill(2))
            feature_names.append("be2"+"2"+str(i).zfill(2))
            feature_names.append("be3"+"2"+str(i).zfill(2))

        export_graphviz(tree, out_file='tree.dot',
                feature_names = feature_names,
                rounded = True, proportion = False, 
                precision = 2, filled = True)

        # 用系统命令转为PNG文件(需要 Graphviz)
        import subprocess 
        command = "dot -Tpng tree.dot -o tree.png -Gdpi=600"
        res = subprocess.check_output(command, shell=True).decode()

        exit(0)


        return data_train_resource, data_train_label, data_test_resource, data_test_label
    def build_model(self):

        Input_data = Input(shape=(self.latent_dim,))
        # MLP
        y = Dense(64)(Input_data)
        y = Dense(128)(y)
        y = Dense(64)(y)
        y = Dense(32)(y)
        y = Dense(8)(y)
        y = Dense(2)(y)
        y = Dense(1)(Input_data)
        
        # y = Dense(32)(Input_data)
        # y = Dense(64)(y)
        # y = Dense(32)(y)
        # y = Dense(8)(y)
        # y = Dense(2)(y)
        # y = Dense(1)(Input_data)

        return Model(Input_data, y)

    def train(self, epochs, batch_size=1024*1, save_interval=50):

        # Load the dataset
        data_train_res, data_train_label, data_test_res, data_test_label = self.loaddata()
        for epoch in range(epochs):

            # ---------------------
            #  Train Discriminator
            # ---------------------

            idx = np.random.randint(0, data_train_res.shape[0], batch_size)
            resource, labels = data_train_res[idx], data_train_label[idx]
            d_loss = self.model.train_on_batch(resource, labels)

            # If at save interval => save generated image samples
            if epoch % save_interval == 0:

                #print('...................Training Loss......................')
                #print("%d [Training loss: %f" % (epoch,  d_loss))
                print('...................Testing Loss......................')
                #testing_error = self.model.evaluate(data_test_res,data_test_label)
                startTime = datetime.datetime.now()
                data_pre = self.model.predict(resource)
                test_label = self.model.predict(data_test_res)
                endTime = datetime.datetime.now()

                for i in range(len(test_label)):
                    print('Testing Loss', np.abs((test_label[i] - data_test_label[i]))/data_test_label[i])
                    print(np.abs((test_label[i] - data_test_label[i]))/data_test_label[i], file=open("MLP_loss_9010.txt", "a"))
                print("**********", file=open("MLP_loss_9010.txt", "a"))

                # print('labels&prediction')
                # print(labels[0:3])
                # print(data_pre[0:3])
                print('Training Loss', np.mean(np.abs((data_pre - labels))))
                print('Testing Loss', np.mean(np.abs((test_label - data_test_label))))
                print("PredictionTime:", (endTime - startTime))

if __name__ == '__main__':
    cgan = CGAN()
    cgan.train(epochs=1000000000, batch_size=1024*1, save_interval=1000)