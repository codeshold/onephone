---
title: Python网络安全编程
layout: post
author: WenfengShi
category: 技术
tags: [security, python]
---
博客链接: [http://codeshold.me/2017/04/python_security.html](http://codeshold.me/2017/04/python_security.html)

> 360 ISC

## Python && 网络安全

- 基于Python的平台
    - [知道创宇 Seebug](https://www.seebug.org/)
    - [乌云 TangScan](http://wooyun.tangscan.cn/)
    - [BugScan](http://www.bugscan.net/)
    - 远程PoC开发文档，关于Pocsuite, BugScan插件开发文档
- Python的深度
    - sqlmap -- SQL注入神器
    - mitmproxy/mitmdump -- 中间人攻击神奇

- [How To Become A Hacker ](http://www.catb.org/~esr/faqs/hacker-howto.html)(Eric Steven Raymond)

- 应用举例
    - 目录扫描： `web + 多线程｛requests + threading + Queue:[ 后台|敏感文件(svn|upload)|敏感目录(phpmyadmin) ]}`
    - 信息搜索：`web + 数据库 { 中间件 (Tomcat | Jboss) + C段WEB信息 + 搜集特定程序 }`
    - 信息匹配&SQL注入：`web + 正则{抓去信息（用户名｜邮箱?）＋SQL注入}`
    - 反弹shell： `网络`


## Python 编程

> 《python核心编程》, Burpsuite, Sqlmap等工具

### 正则表达式

- `re`模块提供对正则表达式的支持
    1. `re.compile`
    2. `match, find, search`
    3. 匹配结果
- 语法
    - `\d, \D, \s, \S, \w, \W` 大写表示非, `.`匹配任意换行符意外的字符
    - `*?, +?, ??, {m,n}?`使匹配变为非贪婪模式
    - `\A, \z, \b, \B` 分别匹配字符串开头， 字符串结尾， 匹配`\w`和`\W`之间， 匹配`[^\b]`
- re
    - `re.l`忽略大小写
    - `re.L`使用预定字符`\w, \W, \b, \B, \s, \S`取决当前区域设定
    - `re.M`多行模式改变`^`和`$`的行为
    - `re.U`使用与定义字符`\w, \W, \B, \s, \S, \d, \D`取决Unicode定义的字符属性
    - `re.X`详细模式，可以多行，忽略空白字符，并且可以加入注释
- 举例

``` python
# -*- encoding:utf-8 -*-
import re

pattern = re.compile(r'\d')
match = pattern.match('hello sh12iwenfeng ')
print match.group()

word = re.findall('hello', 'hello shiwenfneg')
print word
```

### Web编程
> 与web进行交互，获取web信息

- urllib, urlib2, requests
- urllib: `urllib.urlopen()`, `urllib.urlretrive()`, `urlretrive(url, filename=None, reporthook=None, data=None)`(下载文件)
- urllib2:`urllib2.urlopen()`, `urllib2.Requests()`(定制请求头)
- 用例

``` python
# -*- encoding:utf-8 -*-

import urllib, urllib2

url = 'http://www.baidu.com'
r = urllib.urlopen(url)
# print r.read()
url = 'https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/logo_white_fe6da1ec.png'
r = urllib.urlretrieve(url, filename='/Users/wenfeng/baidu.png')

import requests

r = requests.get(url)
r = requests.post(url)
r = requests.put(url)
r = requests.head(url)
r = requests.options(url)
r = requests.delete(url)

payload = {"key1": "value1", "key2": "value2"}
r = requests.get(url, params=payload)   # 传递参数
print(r.url)        # http:xxxx/get?key2=value2&key1=value1
r.txt               # 响应内容
r.endcoding 'utf-8' # 编码
r.content           # 二进制响应内容

headers = {'content-type': 'applicaiton/json'}
r = requests.get(url, headers = headers)    # 定义请求头，也可加入cookie

r = requests.post('http://www.baidu.com/post', data=payload)
r.status_code       # 返回状态吗
r.headers           # 响应头
r.cookies           # Cookies
r.cookies['example cookie name']

r = requests.get(url, timeout=0.001)    # 设置超时
# 遇到网络问题时，Request会抛出一个ConnectionError异常
# 遇到罕见的无效的HTTP响应时，Request会抛出一个HTTPError异常
# 请求超时，则抛出一个Timeout异常
```

- 结合Burp Suite 写一个爬虫程序
    - Burp Suite 是用于攻击web 应用程序的集成平台
    - [python 爬虫闯关](http://vjson.com/wordpress/%E7%88%AC%E8%99%AB%E9%97%AF%E5%85%B3%E7%AC%AC%E4%B8%80%E5%85%B3.html)

```
# -*- coding: utf-8 -*-

import requests
import json

url_start = 'http://www.baidu.com'

def lesson(rul):
    headers = {
        'Host': 'www.baidu.com',
        'User-Agent': '',
        'Accept': '',
    }
    r = requests.get(url=url, headers=headers)
    # print r.text

    data = json.loads(r.text)
    name_long = len(data['result'])
    # print name_long
    for i in range(name_long):
        print data['result'][i]['courseName']

for i in range(1, 9):
    url = url_start + str(i) + 'xxxxx'
    lesson(url)
```

### 多线程编程

- thread 模块
`start_new_thread(function, args, kwargs = None)`
产生一个新线程，在新的线程中使用指定的参数和可选的kwargs来调用这个函数。
这种方法一定要加`timesleep()`，否则这个县城可能不执行
不能方便的控制线程数

```
# -*- coding: utf-8 -*-

import thread
import time
from subprocess import Popen, PIPE

def ping_check(ip):
    check = Popen(['/bin/bash', '-c', 'ping -c 2 ' + ip], stdin=PIPE, stdout=PIPE)
    data = check.stdout.read()
    if 'ttl' in data:
        print '%s is UP' %ip

def fun1():
    print 'hello world! %s\n' %time.ctime()

def swfmain():
    thread.start_new_thread(fun1, ())
    thread.start_new_thread(fun1, ())
    time.sleep(2)

if __name__ == "__main__":
    # swfmain()
    ip_prefix = '10.10.88.'
    for i in range(1, 255):
        ip = ip_prefix + str(i)
        thread.start_new_thread(ping_check, (ip,))
        time.sleep(0.1)
```

- threading 模块
Thread类， 使用threading模块，子类化Thread类，解决了线程数可控的问题

```
# -*- coding: utf-8 -*-

import threading
import time
import requests

def swf1():
    # print 'hello %s:%s' %(key, time.ctime())
    time_start = time.time()
    r = requests.get(url='http://www.baidu.com')
    t = time.time() - time_start
    print 'Status:%s----%s----%s\n' %(r.status_code, t, time.strftime('%H:%M:%S'))

def main():
    threads = []
    keys = ['zs', 'ls', 'wmz']

    threads_count = len(keys)

    for i in range(threads_count):
        # t = threading.Thread(target=swf1, args=(keys[i],))
        t = threading.Thread(target=swf1, args=())
        threads.append(t)

    for i in range(threads_count):
        threads[i].start()

    for i in range(threads_count):
        threads[i].join()

if __name__ == '__main__':
    main()

```
- 生产者-消费者问题和Queue模块
    - Queue模块`qsize(), empty(), full(), put(), get()`
    - 完美搭档 Queue + Thread

```
# -*- coding: utf-8 -*-

import threading
import Queue
from subprocess import Popen, PIPE
import sys

class DoRun(threading.Thread):
    def __init__(self, queue):
        threading.Thread.__init__(self)
        self._queue = queue

    def run(self):
        while not self._queue.empty():
            ip = self._queue.get()
            # print ip
            check_ping = Popen(['/bin/bash', '-c', 'ping -c 2 ' + ip], stdin=PIPE, stdout=PIPE)
            data = check_ping.stdout.read()
            if 'ttl' in data:
                sys.stdout.write(ip + ' is UP\n')

def main():
    threads = []
    threads_count = 10
    queue = Queue.Queue()

    for i in range(1, 255):
        queue.put('10.10.88.' + str(i))

    for i in range(threads_count):
        threads.append(DoRun(queue))

    for i in threads:
        i.start()

    for i in threads:
        i.join()

if __name__ == '__main__':
    main()
```

### 网络编程
python 支持 AF_UNIX, AF_NETLINK, AF_INET 桃姐子

- socket模块
    - `socket(socket_family, socket_type, protocol=0)`
    - `tcpsocket = socket(socket.AF_INET, socket.SOCK_STREAM)`
    - `s.bind(), s.listen(), s.connect(), s.connect_ex()`
    - `s.recv(), s.send(), s.recvfrom(), s.sendto(), s.getpeername(), s.getsockopt(), s.setsockopt(), s.close()` 方法名字长的对应于UDP套接字(recvfrom, sendto)

- server.py 反弹shell

``` python
# -*- coding: utf-8 -*-

from socket import *
from time import ctime
from subprocess import Popen, PIPE

HOST = ''
PORT = 2333
BUFSIZE = 1024

tcpServer = socket(AF_INET, SOCK_STREAM)
tcpServer.bind((HOST, PORT))
tcpServer.listen(5)

while True:
    print 'waiting for connection...'
    tcpClient, addr = tcpServer.accept()
    print '... connected from: ', addr

    while True:
        data = tcpClient.recv(BUFSIZE)
        if not data:
            break
        cmd = Popen(['/bin/bash', '-c', data], stdin=PIPE, stdout=PIPE)
        data = cmd.stdout.read()
        tcpClient.send('[%s] %s' % (ctime(), data))

tcpClient.close()
tcpServer.close()
```

- client.py

``` python
# -*- coding: utf-8 -*-

from socket import *

HOST = '127.0.0.1'
PORT = 2333
BUFSIZE = 1024

tcpClient = socket(AF_INET, SOCK_STREAM)
tcpClient.connect((HOST, PORT))

while True:
    data = raw_input('~:')
    if not data:
        break
    tcpClient.send(data)
    data = tcpClient.recv(BUFSIZE)
    if not data:
        break
    print data

tcpClient.close()
```

### 数据库编程

- 在没有python DB API之前，每个数据库对应一种接口程序， 而Python DB API 建立了一个统一接口
- python DB API 包含的内容： 数据库连接对象 connection（通道）, 数据库交互对象 cursor （数据）, 数据库异常类 exceptions
- 创建connection, 获取cursor, 执行命令，关闭cursor， 关闭connection 
- 步骤
    1. MySQLdb.Connect(param), 参数包括host, port, user, passwd, db, charset
    2. connection.cursor() 使用该连接并返回游标, connection.commit() 提交当前事务, connection.rollback() 回滚当前事务; connection.close() 关闭连接
    3. cursor对象支持：execute(op[,args]), fetchone(), fetchmany(size), fetchall(), rowcount() 最近一次execute返回数据的行数或影响行数, close()
- 实例

``` python
import MySQLdb

conn = MySQLdb.connect(
                    host = '127.0.0.1',
                    port = 3306,
                    user = 'swfswfswf',
                    passwd = '123#@!',
        )
cus = conn.cursor()

sql = 'select version()'

cus.execute(sql)

print cus.fetchone()

cus.close()
conn.close()

```
