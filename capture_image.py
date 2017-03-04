__author__ = 'Jacksgong'

# coding=utf-8
import urllib
import re


def getHtml(url):
    page = urllib.urlopen(url)
    html = page.read()
    return html





def getImg(html):
    reg = r'src="(.+?\.jpg)" pic_ext'
    imgre = re.compile(reg)
    imglist = re.findall(imgre, html)
    x = 0
    for imgurl in imglist:
        # urllib.urlretrieve(imgurl,'%s.jpg' % x)
        if imgurl:
            print "\"" + imgurl + "\","
            x += 1
    return x

total = 0
i = 4
while i <= 74:
    html = getHtml("http://tieba.baidu.com/p/2460150866?pn=" + str(i))
    total += getImg(html)
    if total >= 800:
        break
    i += 1
