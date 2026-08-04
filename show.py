import numpy as np
import matplotlib.pyplot as plt

# 発火状態の列は読み込まず、最初の3列だけ読む
data = np.loadtxt("output.dat", usecols=(0, 1, 2))

time = data[:, 0]
neuron_id = data[:, 1].astype(int)
voltage = data[:, 2]

# ニューロンごとに描画
for i in np.unique(neuron_id):
    mask = neuron_id == i
    plt.plot(time[mask], voltage[mask], label=f"Neuron {i}")

plt.xlabel("Time")
plt.ylabel("Voltage")
plt.title("LIF Neural Network")
plt.legend()
plt.grid()

plt.savefig("graph.png")
plt.close()

print("graph.pngを保存しました")