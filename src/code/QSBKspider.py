import urllib
import re

class QSBKspider:

    #init some vals
    def __init__(self):
        self.pageIndex = 1
        self.user_agent = 'Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)'
        self.headers = {
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
            'Accept-Language': 'zh-CN,zh;q=0.8',
            'Connection': 'keep-alive',
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.87 Safari/537.36'
        }
        self.stories = []
        # 存放是否继续运行的变量
        self.enable = False

    def getHtml(self, pageIndex, baseUrl):
        try:
            url = baseUrl + str(pageIndex)
            req = urllib.request.Request(url, None, self.headers)
            response = urllib.request.urlopen(req, timeout=4000)
            html = response.read().decode('utf-8')
            return html
        except urllib.request.URLError as e:
            print(e)

    def getStories(self, pageIndex, baseUrl):
        pageHtml = self.getHtml(pageIndex, baseUrl)
        if not pageHtml:
            print("Sorry~ loading error,please wait...")
            return None
        pattern = re.compile(
            r'<div class="author clearfix">[\s\S]*?<h2>(.*?)'
            r'</h2>[\s\S]*?<div class="content">[\s\S]*?<span>([\s\S]*?)'
            r'</span>[\s\S]*?<i class="number">(.*?)</i>',re.S)
        pageStories = []
        items = re.findall(pattern, pageHtml)
        for item in items:
            storyList = [item[0].strip(), item[1].strip(), item[2].strip()]
            pageStories.append(storyList)
        return pageStories

    # 加载并提取页面的内容，并加载到list中
    def loadPage(self):
        baseUrl = "http://www.qiushibaike.com/hot/page/"
        if self.enable == True:
            if len(self.stories) < 2 :
                index = self.pageIndex
                pageStories = self.getStories(index, baseUrl)
                self.stories.append(pageStories)
                self.pageIndex += 1

    def getOneStory(self, pageStories, page):
        for story in pageStories:
            isQuit = input()
            self.loadPage()
            if isQuit == 'Q':
                self.enable = False
                return
            print(page, story[0], story[1], story[2]+"人点赞")


    def start(self):
        print('please wait...\n','press Q to quit!')
        self.enable = True
        self.loadPage()
        nowPage = 0
        while self.enable:
            if len(self.stories) > 0:
                pageStories = self.stories[0]
                nowPage += 1
                del self.stories[0]
                self.getOneStory(pageStories, nowPage)


if __name__ == '__main__':
    spider = QSBKspider()
    spider.start()



