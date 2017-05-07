# coding=utf-8
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

dates = pd.date_range('20160101',periods=6)
print(dates)
df = pd.DataFrame(np.random.randn(6, 4),index=dates, columns=list('ABCD'))
print(df)
df_2 = pd.DataFrame({
    'A':1.,
    'B':pd.Timestamp('20160102'),
    'C':pd.Series(1, index=list(range(4)), dtype='float32'),
    'D':np.array([3] * 4, dtype='int32'),
    'E':pd.Categorical(['test', 'train', 'test','train']),
    'F':'foo'
})
print(df_2.dtypes)

ts = pd.Series(np.random.randn(1000),index=pd.date_range('1/1/2015', periods=1000))
ts = ts.cumsum()
ts.plot()
plt.show()


