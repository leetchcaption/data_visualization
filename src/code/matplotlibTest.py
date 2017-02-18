import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt

SEED = 5000000

if __name__ == '__main__':

    np.random.seed(SEED)
    y = np.random.standard_normal((20, 2)).cumsum(axis=0)  # 依照标准正态分布生成的伪随机数
    plt.figure(figsize=(7, 4))
    print(y)
    # plt.plot(y, lw=0.5)
    # plt.plot(y, 'rv')

    # plt.plot(y[:, 0], lw=1.5, label='1st')
    # plt.plot(y[:, 1], lw=3, label='2nd')
    # plt.plot(y, 'rv')

    y[:, 0] = y[:, 0]*100
    plt.plot(y[:, 0], lw=1.5, label='1st')
    print(y[:, 1])
    plt.plot(y[:, 1], lw=1.5, label='2nd')
    plt.plot(y, 'go')

    plt.grid(True)
    plt.legend(loc=0)
    plt.axis('tight')
    plt.xlabel('Test index')
    plt.ylabel('Test value')
    plt.title('standard normal distribution test')
    plt.show(True)
