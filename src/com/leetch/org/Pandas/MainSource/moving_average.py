## coding=utf-8

from pylab import *
from numpy import *
def moving_average(interval, window_size):
    window = ones(int(window_size)) / float(window_size)
    return convolve(interval,window, 'same')
t = linspace(-4, 4, 100)
y = sin(t) + randn(len(t))*0.1
plot(t, y, 'k.')
y_av = moving_average(y, 10)
plot(y, y_av, 'r')
xlabel('time')
ylabel('value')
grid(True)
show()


from matplotlib import pyplot
pyplot.plot([1,2,3,2,3,2,3,1])
pyplot.plot([1,2,3,2],[3,2,3,1])
pyplot.show()


from matplotlib.pyplot import *
# some simple data
x = [1, 2, 3, 4, 5, 6]
y = [5, 4, 3, 2, 2.4, 12]
#create a figure
figure('simple data')
# divid subplots into 2 * 3 grid
# and select #1
subplot(231)
plot(x, y)
# select #2
subplot(232)
bar(x ,y)
# select #3
subplot(233)
barh(x, y)
# create stacked bar charts
subplot(234)
bar(x, y)
# we need more data for stacked bar CHARTS
y1 = [10, 10, 10, 10, 10, 10]
bar(x, y1, bottom=y, color = 'g')
# box plot
subplot(235)
boxplot(x)
# scatter plot
subplot(236)
scatter(x, y)
show()


from pylab import *
dataset = [
    113, 115, 119, 121, 124,
    124, 125, 126, 130, 126,
    127, 120, 128, 129, 130,
    130, 131, 132, 133, 136
]
subplot(121)
boxplot(dataset, vert=False)
subplot(122)
hist(dataset)

import matplotlib.pyplot as pl
import numpy as np
x = np.linspace(-np.pi, np.pi, 256, endpoint=True)
print(x)
yc = np.cos(x)
ys = np.sin(x)
pl.plot(x, yc)
pl.grid(True)
line = pl.plot(x, ys)
pl.show()


# 添加图例和注解
# generate different normal distributions
from matplotlib.pyplot import *
import numpy as np
x1, x2, x3 = np.random.normal(30, 3, 100)\
    , np.random.normal(20, 2, 100)\
    , np.random.normal(10, 3, 100)
#plot them
plot(x1, label='plot')
plot(x2, label='2nd plot')
plot(x3, label='last plot')
# generate a legend box
legend(bbox_to_anchor=(0., 1.02, 1., .102), loc=3,
       ncol=3, mode="expand", borderaxespad=0.)
# annotate an importtant value
annotate("Important value", (55,20), xycoords='data',
         xytext=(5,38),
         arrowprops=dict(arrowstyle='->'))
show()


import matplotlib.pyplot as plt
import numpy as np
x = np.linspace(-np.pi, np.pi, 500, endpoint=True)
# 正弦函数，将坐标轴移动到图纸中央
y = np.sin(x)
plt.plot(x, y)
ax = plt.gca()
# hide two spines, 隐藏上部和右侧的两条线
ax.spines['right'].set_color('none')
ax.spines['top'].set_color('none')
# move bottom left spine to 0,0
ax.spines['bottom'].set_position(('data', 0))
ax.spines['left'].set_position(('data', 0))
# move ticks positions
ax.xaxis.set_ticks_position('bottom')
ax.yaxis.set_ticks_position('left')
plt.show()

# 绘制直方图，表示一定间隔下的数据点频率的垂直矩形为bin；
# 显示数据的相对频率，直方图的总面积=1
import numpy as np
import matplotlib.pyplot as plt
mu = 100
sigma = 15
x = np.random.normal(mu, sigma, 10000)
ax = plt.gca()
# the histogram of the data
ax.hist(x, bins=35, color='r')
ax.set_xlabel('Values')
ax.set_ylabel('Frequency')
#设置 title，基于对latex表达式的支持，在Python格式化字符串中加入了数学符号
ax.set_title(r'$\mathrm{Histogram:}\ \mu=%d, \ \sigma=%d$' % (mu, sigma))
plt.show()

# 绘制误差条形图
import numpy as np
import matplotlib.pyplot as plt
# generate number of measurements
x = np.arange(10, 50, 5)
# values computed from "measured"
y = np.log(x)
print(x)
print(y)
# add some error samples from standard
xe = 0.1 * np.abs(np.random.randn(len(y)))
# draw and show errorbar, 绘画直方图，ecolor:指定误差条的颜色；linewidth:指定误差条边界宽度
plt.bar(x, y, yerr=xe, width=2, align='center',
        ecolor='r',color='cyan', label='experiment #1', linewidth=5)
# give some explainations
plt.xlabel('# measurement')
plt.ylabel('Measured values')
plt.title('Measurements')
# 图例
plt.legend(loc='upper left')
plt.show()

# 绘制饼图
from pylab import *
# make a square figure and axes
fig = figure(1,figsize=(8, 8))
ax = axes([0.1, 0.1, 0.8, 0.8])
# the slices will be orderd
labels = 'Spring', 'Summer', 'Autumn', 'Winter'
# 占%比，value = x[i]/sum(x)
x = [15, 30, 35, 20]
y = sum(x)
print(y)
# 偏离圆心移量
explode = (0.1, 0, 0, 0)
# autopct 格式化圆弧中的标签格式，如果没有指定startangle，圆弧将从x轴开始逆时针排列开始
pie(x, explode=explode, labels=labels, autopct='%1.1f%%',startangle=67)
title('Rainy days by the season')
show()
