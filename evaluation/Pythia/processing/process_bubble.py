#!/usr/bin/python

import sys

#
# Given a file containing the time series bubble size output of the bubble application
# and another file containing the time series performance counter data from the application
# create files containing parsed time series for bubble size, performance counter data 
# and additionally a file containing mappings from bubble size to application performance
# counter data
#
# Note that the timestamps reported by perf are only a relative offset from the starting
# time of the perf application, which we need absolute times to perform registration between
# the bubble output (which uses an absolute system clock)
#

#
# Execute as process_bubble.py experiment_name bubble_output performance_output margin(s)
#

def median(d):
    d.sort()
    l = len(d)
    if l % 2 == 0:
        return (d[int(l/2)] + d[int(l/2) + 1])/2.0
    else:
        return d[int(l/2)]

def process_perf(f):
    # Grab the starting time from the first line of the file
    start_time = float(f.readline().strip())
    cycles = dict()
    instructions = dict()
    ipc = dict()
    ips = dict()
    for line in f:
        values = line.strip().split()
        if values[2].lower() == 'instructions':
            time = float(values[0])
            instructions[time] = int(values[1].replace(',',''))
        elif values[2].lower() == 'cycles':
            time = float(values[0])
            cycles[time] = int(values[1].replace(',',''))
        
    if set(cycles.keys()) != set(instructions.keys()):
        raise Exception('Some time steps missing either cycles or instructions')
    times = sorted(cycles.keys())
    timestep = times[1] - times[0]
    perf_ranges = dict()
    prev_time = times[0] - timestep
    
    for time in times:
        time_range = (prev_time + start_time, time + start_time)
        ips[time_range] = float(instructions[time]) / timestep
        ipc[time_range] = float(instructions[time]) / float(cycles[time])
        prev_time = time
    return (ips, ipc)

def process_bubble(f):
    sizes = dict()
    for line in f:
        values = line.strip().split()
        time = float(values[2])
        bubble_size = int(values[1])
        sizes[time] = bubble_size
    final_sizes = dict()
    times = sorted(sizes.keys())
    
    # Convert into time ranges with the bubble value
    prev_time = times[0]
    prev_size = sizes[prev_time]
    del times[0]
    for time in times:
        final_sizes[(prev_time, time)] = prev_size
        prev_time = time
        prev_size = sizes[prev_time]
    return final_sizes

def max_value(vals):
    max_val = None
    for val in vals:
        if isinstance(val, list):
            if max_val is not None:
                max_val = max(max_val, max_value(val))
            else:
                max_val = max_value(val)
        else:
            if max_val is not None:
                max_val = max(max_val, val)
            else:
                max_val = val
    return max_val

def print_metrics(prefix, x_axis, y_axis, values, normalize=True, medians=False):
    filename = prefix + "." + x_axis + "." + y_axis
    with open(filename, 'w') as f:
        keys = sorted(values.keys())
        for key in keys:
            if isinstance(values[key], list):
                vals = values[key]
            else:
                vals = [values[key]]
            for val in vals:
                f.write("%f %f\n" % (key, val))
    if normalize:
        filename_norm = filename + ".normalized"
        max_val = max_value(values.values())
        with open(filename_norm, 'w') as f:
            keys = sorted(values.keys())
            for key in keys:
                if isinstance(values[key], list):
                    vals = values[key]
                else:
                    vals = [values[key]]
                for val in vals:
                    f.write("%f %f\n" % (key, val / max_val))
    if medians:
        filename_median = filename + ".medians"
        medians = dict((x[0], median(x[1])) for x in values.items())
        with open(filename_median, 'w') as f:
            keys = sorted(medians.keys())
            for key in keys:
                f.write("%f %f\n" % (key, medians[key]))
        if normalize:
            filename_median_normalize = filename + ".medians.normalized"
            with open(filename_median_normalize, 'w') as f:
                max_val = max(medians.values())
                for key in keys:
                    f.write("%f %f\n" % (key, medians[key]/max_val))

def combine(bubble_sizes, perf_metrics, min_gap):
    """ Min gap defines the number of seconds between the
        start of end of a bubble and the perf measurement """
    perf_times = sorted(perf_metrics.keys())

    perf_bubble = dict()
    for (start_time, end_time) in perf_times:
       # Find the bubble (if any) which we fit within cleanly
        for (bubble_start, bubble_end) in bubble_sizes.keys():
            if (bubble_start + min_gap) < start_time and (bubble_end - min_gap) > end_time:
                bubble_size = bubble_sizes[(bubble_start, bubble_end)]
                if bubble_size not in perf_bubble:
                    perf_bubble[bubble_size] = []
                perf_bubble[bubble_size].append(perf_metrics[(start_time, end_time)])
    return perf_bubble

if __name__ == '__main__':
    if len(sys.argv) < 5:
        print('Invalid arguments\nprocess_bubble.py experiment_name bubble_output perf_output margin')
        sys.exit(1)
    
    with open(sys.argv[2], 'r') as bubble, open(sys.argv[3], 'r') as perf:
        (ips, ipc) = process_perf(perf)
        bubble_sizes = process_bubble(bubble)
        bubble_ipc = combine(bubble_sizes, ipc, float(sys.argv[4]))
        bubble_ips = combine(bubble_sizes, ips, float(sys.argv[4]))

        ips_new = dict()
		# Use the midpoint of the interval as the time for the datapoint
        for key in ips.keys():
            ips_new[(key[0]+key[1])/2.0] = ips[key]
        ipc_new = dict()
        for key in ipc.keys():
            ipc_new[(key[0]+key[1])/2.0] = ipc[key]

        prefix = sys.argv[1]
        print_metrics(prefix, "time", "ips", ips_new, True)
        print_metrics(prefix, "time", "ipc", ipc_new, True)
        print_metrics(prefix, "bubble_size", "ipc", bubble_ipc, True, True)
        print_metrics(prefix, "bubble_size", "ips", bubble_ips, True, True)
