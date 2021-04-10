#!/usr/bin/env python

import sys

def RepresentsInt(s):
    try: 
        int(s)
        return True
    except ValueError:
        return False

# Returns IPC and IPS as indexed by time
def process_perf(f):
    #print f
    allLines = []
    for l in f.readlines():
	    l = l.strip()
	    allLines.append(l)
    numLines = len(allLines)
    #print "Number of lines in perf file: ", numLines
    #start_time = float(f.readline().strip())
    start_time = float(allLines[0])
    cycles = dict()
    instructions = dict()
    ipc = dict()
    ips = dict()
    #Subrata: commenting out the previous parsing and adding new. In some cases cycles were not being recorded resulting in parsing error
    i = 1 # we have already used the first line (index 0) for start time
    while (i < numLines):
	try:
	       line_cyc = allLines[i]
	       i = i + 1
	       line_inst = allLines[i]
	except IndexError:
		msg = 'Total number of lines %(numLines)s. Index error at line %(i)s' % locals()
		print(msg)

        values_cyc = line_cyc.strip().split()
        values_inst = line_inst.strip().split()

        if(len(values_cyc) != len(values_inst)):
                #Looks like one of the counters were not properly read leading to few extra white charecters left in the line
		#print 'skipping', str(i)
                i = i +1
                continue

	if((values_cyc[2] != 'cycles') or (values_inst[2] != 'instructions')):
		print 'skipping', str(i)
		i = i +1
                continue
                #print line_cyc
		#print line_inst
        	#raise Exception('Parsing error in .perf file: Some timesteps missing either cycles or instructions')
	
	if(values_cyc[0] != values_inst[0] ):
		msg = 'Parsing error in .perf file: Timestamps of instructions and cycles did not match. Line %(i)s' % locals()
        	raise Exception(msg)
	
	time = float(values_cyc[0])

        if((RepresentsInt(values_cyc[1]) == False) or (RepresentsInt(values_inst[1]) == False)):
		#One of the values were not properly recorded. Skipping..
		#print 'skipping', str(i)
		i = i +1
		continue
	
	cycles[time] = int(values_cyc[1]) 
        instructions[time] = int(values_inst[1])
	i = i + 1

    #end while
    '''
    for line in f:
        values = line.strip().split()
        if values[2] == 'instructions':
            time = float(values[0])
            instructions[time] = int(values[1])
        elif values[2] == 'cycles':
            time = float(values[0])
            cycles[time] = int(values[1])
    if set(cycles.keys()) != set(instructions.keys()):
        raise Exception('Some timesteps missing either cycles or instructions')
    '''	
    times = sorted(cycles.keys())
    prev_time = 0
    for time in times:
        absolute_time = time + start_time
        ips[absolute_time] = float(instructions[time]) / float(time - prev_time)
        ipc[absolute_time] = float(instructions[time]) / float(cycles[time])
        prev_time = time
    
    #print "Number of perf record pairs found : ", len(cycles), len(instructions)
    return (ips, ipc)

if __name__ == '__main__':

    #print "process_perf.py called"

    if sys.argv[1] == '--help':
        print('process.py experiement perf_file')
        sys.exit(0)
    if len(sys.argv) < 3:
        print('Error: Incorrect argument count')
        sys.exit(1)


    experiment = sys.argv[1]
    perf_filename = sys.argv[2]
    with open(perf_filename, 'r') as f:
        (ips, ipc) = process_perf(f)

    with open(experiment + ".ipc", 'w') as ipc_f, open(experiment + ".ips", 'w') as ips_f:
        times = sorted(ipc.keys())
        for time in times:
            ipc_f.write('%f %f\n' % (time, ipc[time]))
            ips_f.write('%f %f\n' % (time, ips[time]))
        
