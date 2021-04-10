#!/bin/env python

# Given two programs run at different times, perform alignment between the time series

# TODO, the min and max stuff is wrong, fyi...

import sys

def read_series(filename):
    series = dict()
    with open(filename, 'r') as f:
        for line in f:
            values = line.strip().lower().split()
            if values[0] == '#':
                continue
            series[float(values[0])] = float(values[1])
    return series

def align(series_a, series_b):
    times_a = series_a.keys()
    times_b = series_b.keys()
    
    new_series_a = dict()
    new_series_b = dict()
    
    start_a = min(times_a)
    start_b = min(times_b)
    
    for time in times_a:
        new_series_a[time - start_a] = series_a[time]
    for time in times_b:
        new_series_b[time - start_b] = series_b[time]

    return (new_series_a, new_series_b)

def write_series(filename, series):
    with open(filename, 'w') as f:
        times = series.keys()
        times.sort()
        for time in times:
            f.write('%f %f\n' % (time, series[time]))

if __name__ == '__main__':

    if len(sys.argv) < 3:
        print("Error: Invalid arguments - align_timeseries.py first_timeseries second_timeseries")
        sys.exit(1)

    (series_a, series_b) = align(read_series(sys.argv[1]), read_series(sys.argv[2]))
    write_series(sys.argv[1] + '.aligned', series_a)
    write_series(sys.argv[2] + '.aligned', series_b)
