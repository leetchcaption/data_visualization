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