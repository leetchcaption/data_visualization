import numpy as np
import matplotlib as mpl
import matplotlib.pyplot as plt


if __name__ == '__main__':

    y = np.random.standard_normal((10000, 2))
    print(y)
    # 散点图
    # plt.plot(y[:, 0], y[:, 1], 'go')
    # plt.grid(True)
    # plt.xlabel('1st')
    # plt.ylabel('2nd')
    # plt.title('Scatter Plot')
    # plt.show(True)

    # scatter 函数
    # c = np.random.randint(0, 20, len(y))
    # print(c)
    # plt.figure(figsize=(7, 5))
    # plt.scatter(y[:, 0], y[:, 1], c=c, marker='o')
    # plt.colorbar()
    # plt.grid(False)
    # plt.xlabel('1st')
    # plt.ylabel('2nd')
    # plt.title('Scatter Plot Pic.')
    # plt.show(True)

    N = 1000
    # 高斯分布
    x = np.random.randn(1, N)
    y = np.random.randn(1, N)
    T = np.arctan2(x, y)

    plt.scatter(x, y, c=T, s=25, alpha=0.5, marker='o')
    plt.show()