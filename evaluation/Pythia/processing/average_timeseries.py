#!/usr/bin/env python

import numpy as np
import sys

def read_timeseries(filename):
        #print "Reading timeseries data from file: ", filename
  
	timeseries = dict()
        '''
        f = open(filename, 'r')
        allLines = f.readlines()
        '''
	with open(filename, 'r') as f:
		for line in f:
			values = line.strip().split()
                        #print line
                            
			timeseries[float(values[0])] = float(values[1])
			#timeseries[1.0] = 0.0
	return timeseries

def average_timeseries(timeseries, stype):
    if stype == 'median':
        return np.median(list(timeseries.values()))
    elif stype == 'mean':
        return np.mean(list(timeseries.values()))
    elif stype == '99th':
        return np.percentile(list(timeseries.values()), 1)
    elif stype == '95th':
        return np.percentile(list(timeseries.values()), 5)

    return 'N/A'

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Error: Incorrect argument count")
        print("average_timeseries.py timeseries_file")
        sys.exit(1)
    if len(sys.argv) >= 3:
        stype = sys.argv[2].strip().lower()
    else:
        stype = 'mean'
    
    val = average_timeseries(read_timeseries(sys.argv[1]), stype)
    print val
