# coding=utf-8
import random
import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt
# import matplotlib.dates as mdate

from mpl_toolkits.mplot3d import Axes3D

mpl.rcParams['font.size'] = 10

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
years = [2013, 2014, 2015, 2016]
for z in years:
    xs = range(1, 13)
    ys = 1000 * np.random.rand(12)
    color = plt.cm.Set2(random.choice(range(plt.cm.Set2.N)))
    ax.bar(xs, ys, zs=z, zdir='y', color=color, alpha=0.8)

ax.xaxis.set_major_locator(mpl.ticker.FixedLocator(xs))
ax.yaxis.set_major_locator(mpl.ticker.FixedLocator(ys))
ax.set_xlabel('Month')
ax.set_ylabel('Year')
ax.set_zlabel('Sales Net(usd)')

plt.show()