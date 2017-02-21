import numpy as np
import matplotlib.pyplot as plt
import matplotlib.finance as mpf

# 指定元素个数创建一维数组
strike = np.linspace(50, 150, 24)
print(strike)
ttm = np.linspace(0.5, 2.5, 24)

# 向量矩阵化
strike, ttm = np.meshgrid(strike, ttm)
print(strike)

# 隐含波动率 generate fake implied volatilities
iv = (strike - 100) ** 2 / (100 * strike) / ttm

from mpl_toolkits.mplot3d import Axes3D

fig = plt.figure(figsize=(10, 6))
# 组建3D坐标系
ax = fig.gca(projection='3d')
ax.set_xlabel('strike')
ax.set_ylabel('time to maturity')
ax.set_zlabel('implited volatility')

surf = ax.plot_surface(strike, ttm, iv, rstride=2,
                       cstride=2, cmap=plt.cm.coolwarm, linewidth=0.5, antialiased=True)

fig.colorbar(surf, shrink=0.5, aspect=5)
plt.show(True)
