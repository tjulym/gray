import matplotlib.pyplot as plt

import matplotlib.font_manager
matplotlib.rcParams["font.family"] = 'Helvetica'

fig = plt.figure(figsize=(6, 2), dpi=300)

plt.subplots_adjust(hspace=0.001, wspace=None, top=0.95, bottom=0.2, left=0.085, right=0.99)

labels = ["ContextSwitch", "L1IMPKI", "LIDMKPI", "L2MPK2", "TLBDMPKI", "TLBIMPKI", 
  "BranchMPKI", "L3MPKI", "MLP", "cpuUtil", "MemUtil", "MemBW", "LLC", "IPC", "DiskIO", "NetworkIO"]

imports = []

with open("RFR_imports_all.csv", "r") as f:
    imports = f.readlines()
    imports = [float(i) for i in imports]

plt.bar(range(len(imports)), imports)


plt.xlabel("Input Features", labelpad=0)
plt.ylabel("Feature Importances",labelpad=0)
# plt.gca().tick_params(axis="x", pad=-2)

plt.show()