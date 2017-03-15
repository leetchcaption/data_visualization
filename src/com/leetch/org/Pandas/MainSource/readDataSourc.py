# coding=utf-8

import requests

url = "https://github.com/timeline.json"

r = requests.get(url)
json_data = r.json()
print(json_data)

repos = set()

for entry in json_data:
    try:
        repos.add(entry['message'])
    except KeyError as e :
        print('No key in this json...')

from pprint import pprint
pprint(repos)