import matplotlib.pyplot as plt

import matplotlib.font_manager
matplotlib.rcParams["font.family"] = 'Helvetica'

fig = plt.figure(figsize=(6, 2), dpi=300)

plt.subplots_adjust(hspace=0.001, wspace=None, top=0.95, bottom=0.4, left=0.085, right=0.99)

labels = ["ContextSwitch", "L1IMPKI", "LIDMKPI", "L2MPK2", "TLBDMPKI", "TLBIMPKI", 
  "BranchMPKI", "L3MPKI", "MLP", "cpuUtil", "MemUtil", "MemBW", "LLC", "IPC", "DiskIO", "NetworkIO"]

imports = [0.029367134278762988, 0.028716694474658168, 0.017801958643464014, 0.019796197545694512, 0.019629590244466946, 0.024775664603026097, 0.019249730689196907, 0.039041155531454465, 0.035197313567860336, 0.03323699449802262, 0.05084154207725082, 0.03567827155089144, 0.03515876589040348, 0.04725016661245032, 0.0, 0.028071506676567902,
0.001354273812900192, 0.0008311451136191685, 0.0007641483015499159, 0.0006357958962134793, 0.0008861792642628132, 0.0020371213738036315, 0.0010483094460890141, 0.0016916002345261183, 0.0012820238014672092, 0.001199250621117822, 0.0006021914524545984, 0.0009114677470193692, 0.0013835834124662175, 0.0014250528892376896, 0.0, 0.0008040384044307145,
0.0003750625055882217, 0.0004157995711048895, 0.0006603895205189423, 0.0006574600471057052, 0.0003441453803850402, 0.00029310422126849266, 0.0004500638076576238, 0.0003381838279091199, 0.0005557734849042268, 0.0005192189181778072, 0.0005271307449822022, 0.0002889253001843464, 0.00048337116145562027, 0.00041650516486222956, 0.0003735645631758086, 0.00023075723924111834,
0.001375253269739664, 0.0011909139589839583, 0.0006199878006147436, 0.0007625405794365488, 0.0006884733237812156, 0.0, 0.0011923806920530466, 0.0003335868129672972, 0.0012503945192671533, 0.00025042137831185105, 0.0019316591313019696, 0.0008955264576268185, 0.0018481803931553937, 0.0008768847097743556, 0.0, 0.0008695940388378727,
0.0348733113303764, 0.030468403191134193, 0.020384366515470535, 0.018397307042831098, 0.022545580438807878, 0.027790445603115894, 0.015905269730678816, 0.039160190132946256, 0.03218465989655467, 0.028765364730997636, 0.045198386802482525, 0.03271894007366471, 0.03738346233722306, 0.04768933094509847, 0.0, 0.026788306799748897,
0.001186858218495321, 0.0010931838182237433, 0.0014197096830697923, 0.00029931115851502556, 0.0011723775633564236, 0.0014118488788257663, 0.0009941908425973988, 0.0020829167241747117, 0.0008271373824698157, 0.0011605700347231305, 0.002026623129205252, 0.0018221827659145257, 0.001537918966726943, 0.001342882953983267, 0.0, 0.0005138101255180026,
0.0005198505098037679, 0.0004135440270867364, 0.0005739318933481319, 0.0003906235987105098, 0.0002839593654783047, 0.0004278861138384444, 0.000204637537840929, 0.0002526272852835575, 0.0002577256071860134, 0.00033191707349995486, 0.00047634683622409485, 0.00027470745391592016, 0.000271128424577095, 0.00035339507828397376, 0.00041349075285642106, 0.0004000125279347741,
0.0015281966833933, 0.0009203487635461551, 0.0010279652105177773, 0.0011190583496582997, 0.0004994192998259003, 0.0, 0.0004436676172160192, 0.0013971693612028627, 0.0010327214427946873, 0.0011808453136720283, 0.0010211478116412584, 0.0011054881251388094, 0.0005750995203195404, 0.0009103772669793458, 0.0, 0.0005637421515929956]


plt.bar(range(len(imports)), imports)


plt.xlabel("Input Features", labelpad=0)
plt.ylabel("Feature Importances",labelpad=0)
# plt.gca().tick_params(axis="x", pad=-2)

plt.show()