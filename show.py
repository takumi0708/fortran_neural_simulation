import numpy as np
import matplotlib.pyplot as plt

data = np.loadtxt("output.dat")

time = data[:, 0]
voltage = data[:, 1]

plt.plot(time, voltage)
plt.xlabel("Time")
plt.ylabel("Voltage")
plt.title("LIF neuron")
plt.grid()

# 画面に表示する代わりにファイルとして保存
plt.savefig("graph.png")
print("画像を保存しました！")
