import numpy as np
import matplotlib.pyplot as plt
import matplotlib.finance as mpf

# finance.yahoo.com 雅虎财经网

start = (2015, 5, 1)
end = (2016, 6, 1)

# get datas from yahoo finance net,use yahoo`s open api as following.
quotes = mpf.quotes_historical_yahoo_ochl('CSCO', start, end)
print(quotes)
fig, ax = plt.subplots(figsize=(10, 5))
fig.subplots_adjust(bottom=0.2)

fig.patch.set_facecolor('blue')

mpf.candlestick_ochl(ax, quotes, width=1, colorup='g', colordown='r')
plt.grid(True)
ax.xaxis_date()

# set the color of activity filed
# ax.set_axis_bgcolor('black')

# dates on the x-axis
ax.autoscale_view()
plt.title('CSCO stocks index')
plt.setp(plt.gca().get_xticklabels(), rotation=30)
plt.show()

yahooquotes = np.array(mpf.quotes_historical_yahoo_ochl('YHOO', start, end))
yahoofig, (yahooax1, yahooax2) = plt.subplots(2, sharex=True, figsize=(8, 6))
mpf.candlestick_ochl(ax=yahooax1, quotes=yahooquotes, width=0.6, colorup='r', colordown='g')
yahooax1.set_title('Yahoo Inc.')
yahooax1.set_ylabel('index level')
yahooax1.grid(True)
yahooax1.xaxis_date()
plt.bar(yahooquotes[:, 0] - 0.25, yahooquotes[: 5], width=0.5)
yahooax2.set_ylabel('volume')
yahooax2.grid(True)
yahooax2.autoscale_view()
plt.setp(plt.gca().get_xticklabels(), rotation=30)
plt.show()
