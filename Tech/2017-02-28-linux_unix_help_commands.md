---
title: Uinx/Linux上的帮助查询命令
layout: post
author: WenfengShi
category: 技术
tags: [linux]
---
博客链接: [http://codeshold.me/2017/02/linux_unix_help_commands.html](http://codeshold.me/2017/02/linux_unix_help_commands.html)


> 别人问我为什么不用百度或谷歌，我告诉他 “因为我知道这些”！

1. `man -k KEYWORD` 或 `apropos KEYWORD`
    - 想完成某个任务，但不知道命令时，可通过KEYWORD进行搜索！
    - 比如，**我想知道tcpdump中的数据包过滤表达式怎么写**
        - 命令行键入`man -k packet`命令后，其会返回相关内容，然后发现了**pcap-filter**（如下）
            ![image_1b9vcu1nst2j1o7ml121c3v1rh49.png-9.9kB][1]
        - 接着命令行键入`man pcap-filter`查询，即知道怎么写数据包过滤表示了
        - 下图就是`man pcap-filter`中给出的"过滤TCP流中的SYN和FIN包"表达式
            ![image_1b9vd54jpe0d1ouasl517shlenm.png-4.3kB][2]

2. `help KEYWORD`
    - help 可显示关于bash命令、shell控制结构等其他信息
    - 比如，**我想知道shell脚本中的while循环怎么用**
        - 命令行键入`help while`   
            ![image_1b9vgtvtm1uroplnsehagg14hg13.png-16.8kB][3] 
    - 命令行键入`help`，则可查询到更多的提示（包括知道**哪些是Shell内建命令**）
            ![image_1b9vh4i1g96c1jo7bsf1gj61fqm1g.png-20.4kB][4]

4. `pinfo`
    - 使用的是彩色界面，比`info`命令更易于使用
    - 比如：**我想知道passwd怎么使用**
        - `pinfo passwd`
            ![image_1b9vhk5q211m3nf71a2k1b2q7r92a.png-20.4kB][5]

5.  `rpm -qc RPM-PACKAGE-NAME` 或 `apt-file`
    - 可查询到对应程序的配置文件路径
    - 如，**我想知道sshd的配置文件在哪里**
        - 命令行键入`rpm -qc openssh-server`即可
        - 若不知道软件包名称，可先`rpm -qa | grep ssh`查询下
        ![image_1b9vi594h1rg3u6p115o1fls1htp2n.png-19.6kB][6]
    - 直接`man RPM-PACKAGE-NAME`后在**FILES**一栏也可查询到（更详细）
    - rpm的其他查询功能见`man rpm`(如查看doc文档、安装目录等）

2. `man N KEYWORD`
    - 了解man手册的内部分类（即man 1-10)
    - 如**我想知道/etc/passwd这个文件内容格式的意义**
        - `man 5 passwd`
            ![image_1b9vk5qh01hh411e81a71ers19du3h.png-17.1kB][7]

6. `which KEYWORD` 或 `whatis KEYWORD` 或 `whereis KEYWORD`
    - 以上都可用于定位程序
    - 如：**我想知道sshd这个命令在哪里**
        - which只显示搜索到的**第一个**使用程序名
        - whereis显示**所有**搜索到的程序名
            ![image_1b9vjtthi1jds8hhjt8cso1k9p34.png-7.4kB][8]
    - type命令可以判断命令是否为shell内置命令，如`type echo`
    - `locate KEYWORD` 可用来搜索文件（和`updatedb`配合）
    - `find`

6. `/usr/shar/doc`
    - 该目录下常常包含程序更详细的信息，但该信息通常对要编译和修改程序的人来说有意义（和`man`或`info`提供的不同)
    - 目录中大多保存了一个README文件，如`/usr/share/doc/tar-1.26/README`
    
7. 两个帮助网站
    - Linux文档项目：[www.tldp.org][9] （HOWTO文档很棒！）
    - GNU在线手册：[www.gnu.org/manual][10]


  [1]: http://static.zybuluo.com/wuzhimang/o7g883jdmlhql9ofdtdt68zt/image_1b9vcu1nst2j1o7ml121c3v1rh49.png
  [2]: http://static.zybuluo.com/wuzhimang/bohrj6z3rzkicv9rcrge3d55/image_1b9vd54jpe0d1ouasl517shlenm.png
  [3]: http://static.zybuluo.com/wuzhimang/m1wnipjj7ujb6bvbktka4kf3/image_1b9vgtvtm1uroplnsehagg14hg13.png
  [4]: http://static.zybuluo.com/wuzhimang/invbhtdzcjtmaqjqwqah8z9z/image_1b9vh4i1g96c1jo7bsf1gj61fqm1g.png
  [5]: http://static.zybuluo.com/wuzhimang/ekdzs8azbd1hcchowwqrfu30/image_1b9vhk5q211m3nf71a2k1b2q7r92a.png
  [6]: http://static.zybuluo.com/wuzhimang/z3nzuepmy9vxxfomqtgok7qb/image_1b9vi594h1rg3u6p115o1fls1htp2n.png
  [7]: http://static.zybuluo.com/wuzhimang/41e7wc1ismr51r4qgxoiqilf/image_1b9vk5qh01hh411e81a71ers19du3h.png
  [8]: http://static.zybuluo.com/wuzhimang/zxgkgggs7qn865k0iq2o5a1d/image_1b9vjtthi1jds8hhjt8cso1k9p34.png
  [9]: http://www.tldp.org/
  [10]: https://www.gnu.org/manual/
