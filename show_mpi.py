import numpy as np
import matplotlib.pyplot as plt

data = np.loadtxt("eeg.dat")

time = data[:, 0]
eeg = data[:, 1]

# 平均値を引いて0付近に調整
eeg = eeg - np.mean(eeg)

plt.figure(figsize=(10, 4))
plt.plot(time, eeg, linewidth=0.8)

plt.xlabel("Time")
plt.ylabel("Amplitude")
plt.title("Simulated EEG")
plt.grid()

plt.tight_layout()
plt.savefig("eeg.png", dpi=200)
plt.close()

print("eeg.pngを保存しました")