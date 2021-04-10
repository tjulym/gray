#!/bin/env python

from scipy import interpolate
import matplotlib.pyplot as plt
import numpy as np
import sys
import utils

from sklearn.isotonic import IsotonicRegression

#
# Fit a curve to the bubble_size-ipc curve
# fit_curve.py
#

def fit_curve(x, y):
    curve = IsotonicRegression(increasing=False)
    curve.fit(x, y)
    return curve
    #return interpolate.interp1d(x, y, kind=1)    

def predict(curve, x):
    return curve.predict([x])[0]

def plot_fit(curve, x, y):
    max_x = max(x)
    min_x = min(x)
    xnew = np.arange(min_x, max_x)
    ynew = curve.predict(xnew)
    plt.plot(x, y, 'o', xnew, ynew, '-')
    plt.show()
            
if __name__ == '__main__':
    if len(sys.argv) < 2:
        print('Need to give the filename')
        sys.exit(1)
    
    (sizes, ipcs) = utils.read_bubble_size(sys.argv[1])
    curve = fit_curve(sizes, ipcs)
    plot_fit(curve, sizes, ipcs)

