import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import seaborn as sns
from matplotlib import rc

import matplotlib.font_manager

fs=60

matplotlib.rcParams["font.family"] = 'Helvetica'

df1 = pd.read_csv("workload99th.txt", header=None, sep="\s+")  #Fig. 6a
df2 = pd.read_csv("function99th.txt", header=None, sep="\s+")  #Fig. 6a


IKNN1 = df1[0]
ILR1 = df1[1]
IRFR1 = df1[2]
ISVR1 = df1[3]
IMLP1 = df1[4]

df11 = pd.DataFrame({"v": IKNN1})
df11["name"] = ["KNN" for i in range(len(df11))]
df12 = pd.DataFrame({"v": ILR1})
df12["name"] = ["LR" for i in range(len(df11))]
df13 = pd.DataFrame({"v": IRFR1})
df13["name"] = ["RFR" for i in range(len(df11))]
df14 = pd.DataFrame({"v": ISVR1})
df14["name"] = ["SVR" for i in range(len(df11))]
df15 = pd.DataFrame({"v": IMLP1})
df15["name"] = ["MLP" for i in range(len(df11))]

df_1 = df11.append(df12).append(df13).append(df14).append(df15)

df_1["Level"] = ["Workload-level" for i in range(len(df_1))]

print(np.percentile(IKNN1,50), np.mean(IKNN1))

IKNN2 = df2[0]
ILR2 = df2[1]
IRFR2 = df2[2]
ISVR2 = df2[3]
IMLP2 = df2[4]

df21 = pd.DataFrame({"v": IKNN2})
df21["name"] = ["KNN" for i in range(len(df21))]
df22 = pd.DataFrame({"v": ILR2})
df22["name"] = ["LR" for i in range(len(df21))]
df23 = pd.DataFrame({"v": IRFR2})
df23["name"] = ["RFR" for i in range(len(df21))]
df24 = pd.DataFrame({"v": ISVR2})
df24["name"] = ["SVR" for i in range(len(df21))]
df25 = pd.DataFrame({"v": IMLP2})
df25["name"] = ["MLP" for i in range(len(df21))]

df_2 = df21.append(df22).append(df23).append(df24).append(df25)

df_2["Level"] = ["Function-level" for i in range(len(df_2))]

df = df_1.append(df_2)

df["v"] = [i*100 for i in df["v"]]

means_dif = []
means_dif.append(np.median(IKNN1) / np.median(IKNN2)-1)
means_dif.append((np.median(ILR1)/np.median(ILR2))-1)
means_dif.append((np.median(IRFR1)/np.median(IRFR2))-1)
means_dif.append((np.median(ISVR1)/np.median(ISVR2))-1)
means_dif.append((np.median(IMLP1)/np.median(IMLP2))-1)

print("Media", means_dif, np.mean(means_dif), max(means_dif))

vars_dif = []
vars_dif.append(np.var(IKNN1) / np.var(IKNN2)-1)
vars_dif.append((np.var(ILR1)/np.var(ILR2))-1)
vars_dif.append((np.var(IRFR1)/np.var(IRFR2))-1)
vars_dif.append((np.var(ISVR1)/np.var(ISVR2))-1)
vars_dif.append((np.var(IMLP1)/np.var(IMLP2))-1)

print("Var", vars_dif, np.mean(vars_dif), max(vars_dif))


fig = plt.figure(figsize=(12, 9))


my_pal = {"Workload-level": "#5D5D5D", "Function-level": "#ED212D"}

ax = sns.violinplot(x="name", y="v", data=df, hue="Level", palette=my_pal, linewidth=1.5, scale="width", inner="box")

from matplotlib.collections import PathCollection
for a in ax.findobj(PathCollection):
    a.set_sizes([500])


legend = plt.legend(ncol=1, fontsize=60, loc=(0.008, 0.69), borderpad=0.1, labelspacing=0.25)

plt.xticks(fontsize=fs)
plt.yticks(fontsize=fs)
plt.grid(linestyle=":")

plt.yticks([0,100,200,300,400])
plt.xlabel("Machine Learning Model", fontsize=fs)

ax.spines["bottom"].set_color("k")
ax.spines["bottom"].set_linewidth(2)
ax.spines["top"].set_color("k")
ax.spines["top"].set_linewidth(2)
ax.spines["left"].set_color("k")
ax.spines["left"].set_linewidth(2)
ax.spines["right"].set_color("k")
ax.spines["right"].set_linewidth(2)
ax.set_axisbelow(True)

plt.tight_layout()

plt.savefig('funcvsworkload99th.eps',format='eps')
plt.savefig('funcvsworkload99th.jpg',format='jpg')

print("Saved...")

plt.show()

