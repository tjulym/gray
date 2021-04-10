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

def estimate_ipc(filename, bubble):
    (sizes, ipcs) = utils.read_bubble_size(filename)
    #sizes = np.array(sizes)
    #ipcs = np.array(ipcs)
    #print sizes.shape, ipcs.shape
    #Jason's old code
    if(bubble >= np.max(sizes)):
	    return np.min(ipcs)
    if(bubble <= np.min(sizes)):
	    return np.max(ipcs)

    curve = fit_curve.fit_curve(sizes, ipcs)
    predicted_ipc = curve.predict([bubble])
    #print "Predicted IPC: " , predicted_ipc
    #polyReg = Pipeline([('poly', PolynomialFeatures(degree=3)),('linear', IsotonicRegression(increasing=True))])
    #polyReg = Pipeline([('poly', PolynomialFeatures(degree=3)),('linear', LinearRegression())])
    #polyReg.fit(x, y)
    #polyReg.fit(sizes, ipcs)
    #print "R2 score: ", polyReg.score(sizes, ipcs) 
    #predicted_ipc = polyReg.predict(bubble)
    #print "Polynomial: " , bubble_size
    #return bubble_size[0][0]
    return predicted_ipc



if __name__ == '__main__':
    if len(sys.argv) < 3:
        print("Error: Invalid parameters")
        print("Usage: estimate_ipc.py reporter_curve bubble")
        sys.exit(1)
    print(estimate_ipc(sys.argv[1], float(sys.argv[2])))
