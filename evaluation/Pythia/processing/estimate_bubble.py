#!/bin/env python

import sys
from scipy import optimize
import fit_curve
import utils
import numpy as np

from sklearn.preprocessing import PolynomialFeatures
from sklearn.pipeline import Pipeline
from sklearn.isotonic import IsotonicRegression
from sklearn.linear_model import LinearRegression

#
# Purpose: From the tuned reporter curve and the measured reporter IPC estimate the
#           effective bubble size of the application(s) co-running with the reporter
#
# Parameters:
#   reporter_file - Path to file with bubble_size normalized_ipc value pairs
#   ipc - Value indicating observed reporter IPC value
#

def estimate_bubble(filename, ipc):
    (sizes, ipcs) = utils.read_bubble_size(filename)

    #Jason's old code
    curve = fit_curve.fit_curve(sizes, ipcs)
    target_function = lambda x: curve.predict([x])[0] - ipc
    #print ipc, min(sizes), "target :", (target_function(min(sizes)) + ipc), max(sizes), " target :", (target_function(max(sizes)) + ipc)

    #The following is to make sure that bisection method does find a root
    if(ipc > (ipc + target_function(min(sizes)))):
	return min(sizes)
    elif(ipc < (ipc + target_function(max(sizes)))):
	return max(sizes)

    try:
    	bubble_size = optimize.bisect(target_function, min(sizes), max(sizes))
        #print "Isotonic ",  bubble_size
	return bubble_size
    except:
   	    print "Isotonic could not find"

    '''
    #Subrata: I want to try a polynomial regression
    #Subrata we will treat ipcs as "x" and "sizes" or bubble_sizes as Y. So as we increase ipc the bubble size will drop

    #x = np.array(ipcs)
    #y = np.array(sizes)
    x = np.transpose(np.array([sizes]))
    y = np.transpose(np.array([ipcs]))
	
    #print x.shape,  y.shape

    #polyReg = Pipeline([('poly', PolynomialFeatures(degree=3)),('linear', IsotonicRegression(increasing=True))])
    polyReg = Pipeline([('poly', PolynomialFeatures(degree=3)),('linear', LinearRegression())])
    #polyReg.fit(x, y)
    polyReg.fit(x, y)
    print "R2 score: ", polyReg.score(x, y) 
    #bubble_size = polyReg.predict(ipc)
    #print "Polynomial: " , bubble_size
    #return bubble_size[0][0]

    print polyReg.predict(256)
    target_function = lambda x: polyReg.predict(x)[0] 
    print min(sizes), "target :", target_function(min(sizes)), max(sizes), " target :", target_function(max(sizes))
    try:
        bubble_size = optimize.bisect(target_function, min(sizes), max(sizes))
        print "Polyregression ",  bubble_size
        return bubble_size
    except: 
   	    print "Polyregression could not find"
    '''

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print("Error: Invalid parameters")
        print("Usage: estimate_bubble.py reporter_curve ipc")
        sys.exit(1)
    print(estimate_bubble(sys.argv[1], float(sys.argv[2])))
