def read_bubble_size(filename):
    sizes = []
    ipcs = []
    with open(filename, 'r') as f:
        for line in f:
            values = line.strip().split()
            sizes.append(int(float(values[0])))
            ipcs.append(float(values[1]))
    return (sizes, ipcs)
