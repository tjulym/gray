import matplotlib.pyplot as plt

import matplotlib.font_manager
matplotlib.rcParams["font.family"] = 'Helvetica'

fig = plt.figure(figsize=(6, 2), dpi=300)

plt.subplots_adjust(hspace=0.001, wspace=None, top=0.95, bottom=0.4, left=0.1, right=0.99)

labels = ["ContextSwitch", "L1IMPKI", "LIDMKPI", "L2MPK2", "TLBDMPKI", "TLBIMPKI", 
  "BranchMPKI", "L3MPKI", "MLP", "cpuUtil", "MemUtil", "MemBW", "LLC", "IPC", "DiskIO", "NetworkIO"]

imports = []

with open("RFR_imports.csv", "r") as f:
    imports = f.readlines()
    imports = [float(i) for i in imports]

imports_d = {}
for i in range(len(labels)):
    imports_d[labels[i]] = imports[i]

imports_sort = sorted(imports_d.items(), key = lambda x:x[1], reverse=True)

print("\n".join([str(i[1]) for i in imports_sort]))
print(",".join([str(i[0]) for i in imports_sort]))

plt.bar(range(len(labels)), [i[1] for i in imports_sort])

plt.xticks(range(len(labels)), [i[0] for i in imports_sort], rotation=55)

# plt.xlabel("Input Features", labelpad=-12)
plt.ylabel("Feature Importances",labelpad=0)
plt.gca().tick_params(axis="x", pad=-2)

plt.show()