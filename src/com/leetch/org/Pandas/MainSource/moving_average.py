# coding=utf-8

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

show()