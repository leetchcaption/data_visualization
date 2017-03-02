from urllib import request
import urllib as ub


def do_getContent(url, data=None):
    header = {
        'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
        'Accept-Language': 'zh-CN,zh;q=0.8',
        'Connection': 'keep-alive',
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.87 Safari/537.36'
    }
    values = {'username': 'cqc', 'password': 'XXXX'}
    try:
        req = request.Request(url, None, header)
        response = ub.request.urlopen(req, timeout=3000)
    except ub.request.HTTPError as e:
        print(e.name)
    return response.read()


if __name__ == "__main__":
    url = "http://www.baidu.com"
    html = do_getContent(url, None)
    print(html)