import matplotlib.pyplot as plt
import pandas as pd
import timeit
import random

x = random.randint(10**3, 10**6)

def test_naive():
    a, b, c = x, 2 * x, x // 2

def test_shift():
    a, b, c = x, x << 1, x >> 1

def test_mixed():
    a, b, c = x, x * 2, x >> 1

def test_mixed_swaped():
    a, b, c = x, x << 1, x // 2

def observe(k):
    print(k)
    return {
        'naive': timeit.timeit(test_naive),
        'shift': timeit.timeit(test_shift),
        'mixed': timeit.timeit(test_mixed),
        'mixed_swapped': timeit.timeit(test_mixed_swaped),
    }

def get_observation():
    return pd.DataFrame([observe(k) for k in range(10)])

if __name__ == '__main__':
    # Series([4, 5, 7]).plot()
    data = get_observation()
    # Series(data).plot()
    data.plot()
    print(data)
    plt.show()