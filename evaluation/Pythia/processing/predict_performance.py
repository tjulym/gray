#!/bin/env python

import fit_curve
import sys

#
# Purpose:
#

#
# Parameters:
#   sensitivity_curve_file - Path to file containing the sensitivity curve for the given application
#   bubble_size - Bubble size of the other applications
#

def predict_performance(filename, bubble_size):
    (sizes, ipcs) = utils.read_bubble_size(filename)
    curve = fit_curve.fit_curve(sizes, ipcs)
    return curve(bubble_size)

if __name__ == '__main__':
    if len(sys.argv) < 3:
        print("Error: Invalid parameters - predict_performance.py sensitivity_curve_file bubble_size")
        sys.exit(1)
    performance = predict_performance(sys.argv[1], float(sys.argv[2]))
    print("%f" % (performance))
    


