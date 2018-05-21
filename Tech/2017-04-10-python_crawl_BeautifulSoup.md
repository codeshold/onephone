---
title: Python爬虫
layout: post
author: WenfengShi
category: 技术
tags: [python]
---
博客链接: [http://codeshold.me/2017/04/python_crawl_BeautifulSoup.html](http://codeshold.me/2017/04/python_crawl_BeautifulSoup.html)

## 0x01 相关

Python 相关库：requests, re, BeautifulSoup, hackhttp(四叶草)
- BeatuifulSoup
```
# 解析内容
from bs4 import BeautifulSoup
soup = BeautifulSoup(html_doc)

# 浏览数据
soup.title
soup.tilte.name
soup.title.string

# BeautifulSoup正则使用
```
- `pip install hackhttp`

## 0x02 百度URL采集
> 百度URL采集器

[zoomeye](https://www.zoomeye.org/)采集, 网络空间搜索引擎, 知道创宇

## 0x03 高精度字典生成器
> 扩展至BurpSuite


