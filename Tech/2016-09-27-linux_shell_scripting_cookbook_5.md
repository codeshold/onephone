---
title: linux shell 学习摘记（5） 
layout: post
author: WenfengShi
category: 技术
tags: [shell]
---

> 《linux shell 脚本编程攻略 （第2版）》 第五章 ”一团乱麻？没有这回事“ 笔记

> 主要命令：`wget`, `lynx`, `curl`, `图片抓取脚本`, `网页相册生成脚本`

- **wget**
    1. `wget -t 5 www.codeshold.me`, `wget -t 0 www.codeshold.me` 无限次尝试, `-O outfile.html`, `-o out.log`
    2. 可限速 `--limit-rate 20k`, 可限制配额 `--quota 100m`或`-Q 100m` 
    3. 断点续传 `wget -c www.codeshold.me`
    4. 镜像整个网站 `wget --mirror --convert-links www.codeshold.me` 或者 `wget -r -N -k -l DEPTH URL`，其中`-k`和`--convert-links`指示wget将页面的链接地址转换为本地地址，`-N`使用文件的文件戳
    5. `wget --user USERNAME --password PADDWD URL`
    6. `wget http://10.108.255.249/cgi-bin/do_login --post-data "username=$name&password={TEXT}$pass&drop=0&type=1&n=100"i -q`

- **lynx**

- **curl**
    1. `curl www.codeshold.me -o swf.html --progress`, `--silent` 不显示进度信息
    2. 断点续传 `curl URL/file -C offset`, `curl -C -URL`（程序自己推断出续传的位置）
    3. 参照页(refer)可标志用户从哪个页面到达当前页面的，呈现的页面可能会不一样 `curl --referer www.google.com www.codeshold.me`
    4. `curl www.codeshold.me --cookie "user=wuzhimang;pass=mydream"`, 将cookie另存为一个文件 `curl www.baidu.com --cookie-jar cookie.file`
    5. 使用用户代理(user agent)，某些网站需特定的浏览器支持支持（如IE）`curl www.codeshold.me --user-agent "Mozilla/5.0"` [用户代理字符串](http://www.useragentstring.com)
    6. 添加头部信息`curl -H "Host: www.codeshold.me" -H "Accept-language: en" www.codeshold.me`
    7. 限定 `--limit-rate 20k`, `--max-filesize bytes`
    8. 认证 `curl -u user:pass http://codeshold.me`, `curl -u user http://10.108.255.249/`
    9. 添加头部 `-I` 或 `--head`
    10. 命令行访问Gmail (不能用的）

```
$ cat gmail_bash.sh
#!/bin/bash

username='wuzhimang@gmail.com'
password='XXXX'

SHOW_COUNT=5

echo
curl -u $username:$password "https://mail.google.com/mail/feed/atom" | \
tr -d '\n' | sed 's:</entry>:\n:g' | \
sed -n 's/.*<title>\(.*\)<\/title.*<author><name>\([^<]*\)<\/name><email>\([^<]*\).*/From: \2 [\3] \nSubject: \1\n/p' | \
head -n $(( $SHOW_COUNT * 3))
```

- [图片抓取器](https://github.com/wenfengshi/CoScripts/blob/master/shell/img_downloader.sh)

- [网页相册](https://github.com/wenfengshi/CoScripts/blob/master/shell/generate_album.sh)

- POST请求 `curl URL -d "XXX"`, `wget URL --post-data "XXX" -O output.html` [脚本](https://github.com/wenfengshi/CoScripts/blob/master/shell/FDU_login.sh)

