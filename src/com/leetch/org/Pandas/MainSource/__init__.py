# coding=utf-8
import matplotlib.pyplot as plt
import numpy as np

# a = np.arange(0.0,5.0,0.02)
# plt.plot(a,np.cos(2*np.pi*a),'r--')
# plt.xlabel("时间",fontproperties='SimHei',fontsize=15,color='green') # 对x轴增加文本标签
# plt.title("图形标题标签") # 对图形整体增加显示标签
# plt.annotate() #箭头绘制
#
# #复杂的绘图区域
# plt.subplot2grid() # 将一个区域分裂成多个不同的区域
# plt.subplot2grid((3,3),(1,0),colspan=2)

fig, ax = plt.subplots()
ax.plot(10*np.random.randn(100),10*np.random.randn(100),'o')
ax.set_title("Simple Scatter")
plt.show()
