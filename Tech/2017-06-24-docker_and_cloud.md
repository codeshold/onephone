---
title: “Docker容器和容器云”读书笔记(1)
layout: post
author: WenfengShi
category: 技术
tags: [docker, cloud]
---
博客链接: [http://codeshold.me/2017/06/docker_and_cloud.html](http://codeshold.me/2017/06/docker_and_cloud.html)


> 最开始自己读的是《Docker容器与容器云》第一版（实验室的小伙伴买的，还全新呢），后来在图灵社区提交“新勘误”时被`张霞@Turing`提醒已经出了第二版。于是，自己仔细看了下第二版的前言发现第一版和第二版的差别挺大的，尽管自己能理解Docker技术发展的迅速，但没想到Docker源码的迭代也是这么快！至此第一版很多的内容已经out了, 于是就用银子在社区上换了第二版的书！  
自己想要了解的是Docker源码，尤其是网络部分，所以目前只着重看本书的“第一部分 Docker深入解读”！

## 个人评价
1. 本书不适合初学者，向Docker初学者推荐gitbook——《Docker 从入门到实践》，即Docker practice[下载地址](https://www.gitbook.com/book/yeasy/docker_practice/details)，原因如下
    - Docker技术更新快，当翻译成中文出版后，部分内容可能就out了，而gitbook开源且持续更新！
    - 本书的精华在于对源码的解读，想要理解书中的内容需要很好的知识储备！
    - 这里是我的[docker practice读书笔记](http://www.ituring.com.cn/article/467946)
2. 本书适合那些想要了解Docker工作原理和机制的人！
    - 书中对Docker核心原理的解读真的特别的全面，给浙江大学SEL实验室点个赞！
3. 正因为力求全面，而本书又不仅仅只是讲解核心原理，其中还涉及到很多的Docker的基本用法（这一块内容基本和docker practice相同)，所以不少核心内容的讲解其实并不详细(限于篇章大小吧)，如果作者能提供一些相关知识背景的介绍链接或书籍更好！
    - 比如Docker 网络这一块，需要对iptables、traffic controller等内容有了解（基本的网络知识就不用说了）
4. 自己想要学习的是Docker源码，挑选了很多Docker相关书籍，毫无疑问，本书是最好的一本（中文），内容最新，讲解的也很好！尽管书中没有涉及到具体的源码，但我认为这正是这本书的特色！核心原理讲好了，源码只能是读者自己去实实在在的！
5. 在阅读的过程中自己也发现了一些小的错误,如第114页中对`-A POSTROUTING -s 172.17.0.0/16 ! -o docker0 -j MASQUERADE`规则的解读就有错误，但已经提交勘误了！
6. 书里面有很多浙大SEL团队自己的经验总结，如Docker子命令的分类图、结构图，具体网络配置的实践例子等等，还有最后第三部分“附录”中的内容！！！
7. 容器云部分的内容不做评价(尽管我知道里面k8s的内容已经部分过时了)，对于一个想要了解Docker原理，学习Docker源码的人来说，我认为《Docker容器与容器云》是最好的一本书。尽管有另外一本专门解读Docker源码的书，但是内容已经比较老了！

## 个人笔记
> 目标是学习Docker network 源码，libnetwork, 列举了几个自己在书中的标记，目前自己还是个初学者，待能深入理解相关的内容后再统一做整理吧，现在只能自己在书上做做笔记了！

1. Docker子命令的分类 和 Docker命令结构图 -- P10
2. namespace的6项隔离 -- P29
3. Docker 网络虚拟化架构 -- P109
4. traffic controller 概述 -- P146
5. pipework 原理解析 -- P159
6. OVS 隧道模式 -- P175


## 计划
1. docker practice -- OK
2. docker 容器和容器云 -- ing
3. 源码 -- ing


