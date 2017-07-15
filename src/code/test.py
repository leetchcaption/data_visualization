
fp = open('D:\\workspace\\gitHubSource\\pyDataChart\\src\\test.txt', 'r+', 0)
fp.readline()
fp.seek(10, 1)
print(fp.readline())