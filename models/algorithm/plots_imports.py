import matplotlib.pyplot as plt

import matplotlib.font_manager
matplotlib.rcParams["font.family"] = 'Helvetica'

fig = plt.figure(figsize=(6, 2), dpi=300)

plt.subplots_adjust(hspace=0.001, wspace=None, top=0.95, bottom=0.4, left=0.085, right=0.99)

labels = ["ContextSwitch", "L1IMPKI", "LIDMKPI", "L2MPK2", "TLBDMPKI", "TLBIMPKI", 
  "BranchMPKI", "L3MPKI", "MLP", "cpuUtil", "MemUtil", "MemBW", "LLC", "IPC", "DiskIO", "NetworkIO"]

imports = [0.034530860809174564, 0.026436732464862715, 0.018671770888933348, 0.02118301167576339, 0.028002179237578993, 0.025212133207370317, 0.021871092354022806, 0.03414631801315351, 0.033694065095914695, 0.037655745893735354, 0.04246270153932243, 0.031696429667382925, 0.037109156172821345, 0.04398218649535896, 0.0039, 0.030140421264397387]


imports_d = {}
for i in range(len(labels)):
    imports_d[labels[i]] = imports[i]

imports_sort = sorted(imports_d.items(), key = lambda x:x[1], reverse=True)

print("\n".join([str(i[1]) for i in imports_sort]))
print(",".join([str(i[0]) for i in imports_sort]))

plt.bar(range(len(labels)), [i[1] for i in imports_sort])

plt.xticks(range(len(labels)), [i[0] for i in imports_sort], rotation=55)

plt.xlabel("Input Features", labelpad=-12)
plt.ylabel("Feature Importances",labelpad=0)
plt.gca().tick_params(axis="x", pad=-2)

plt.show()