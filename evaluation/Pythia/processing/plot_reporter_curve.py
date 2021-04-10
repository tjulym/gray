#!/usr/bin/python

import matplotlib
matplotlib.use('agg')
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

def read_data(filename):
    data = {'bubble_size': [], 'ipc': []}
    with open(filename, 'r') as f:
        for line in f:
            bubble_size, ipc = line.strip().split()
            data['bubble_size'].append(int(float(bubble_size) / 1024))
            data['ipc'].append(float(ipc))
    return pd.DataFrame(data)

if __name__ == '__main__':
   
    font = {'family' : 'normal',
        'weight' : 'bold',
        'size'   : 18}
    matplotlib.rc('font', **font)
 
    data = read_data('data/redis_curve.bubble_size.ipc')
    data.sort_index()
    sns.pointplot(data=data, x='bubble_size', y='ipc')
    plt.xlabel('Contention metric (bubble size [KB])', fontsize=18)
    plt.ylabel('Instructions per cycle', fontsize=18)
    plt.xticks(rotation=45)
    plt.tight_layout()
    fig = plt.gcf()
    fig.set_size_inches(15, 10)
    plt.savefig('reporter_curve.png', bbox_inches='tight')
