# coding=utf-8
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.gridspec as gridspec
import pandas as pd

# gs = gridspec.GridSpec(3,3)
# plt.subplot(gs[1:,-1])
# x = [4,9,2,1,8,5]
# plt.plot(x)
# plt.show()

# a = np.arange(10)
# plt.plot(a,a*1.5,'o',color='green')
# plt.plot(a,a*1.7,'.',color='blue')
# plt.show()

ps = pd.Series([9,8,7,6],['a','b','c','d'])
print(ps['b']+ps['d'])
