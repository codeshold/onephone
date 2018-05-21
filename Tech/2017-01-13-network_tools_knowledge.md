---
title: linux网络知识和工具(持续更新)
layout: post
author: WenfengShi
category: 技术
tags: [network, tools]
---

> 涉及主机调优、网络性能调优、网络问题排查等方向，包含工具和原理的介绍

1. 了解ifconfig中的参数信息
- dropped与overruns的区别
dropped，表示这个数据包已经进入到网卡的接收缓存fifo队列，并且开始被系统中断处理准备进行数据包拷贝（从网卡缓存fifo队列拷贝到系统内存），但由于此时的系统原因（比如内存不够等）导致这个数据包被丢掉，即这个数据包被Linux系统丢掉。
overruns，表示这个数据包还没有被进入到网卡的接收缓存fifo队列就被丢掉，因此此时网卡的fifo是满的。为什么fifo会是满的？因为系统繁忙，来不及响应网卡中断，导致网卡里的数据包没有及时的拷贝到系统内存，fifo是满的就导致后面的数据包进不来，即这个数据包被网卡硬件丢掉。所以，个人觉得遇到overruns非0，需要检测cpu负载与cpu中断情
- [The Missing Man Page for ifconfig][9]
- [RX error overrun][6]

2. 能够查询和修改网卡驱动参数及硬件配置
- `ethtool`命令, [参考链接]()
- 读懂并修改网卡 offload , RX/TX checksum, scatter, gather等配置, [参考链接][1]

3. 深层次的理解网卡各类参数的意义，理解linux网络对战的排队机制
- 见[Linux 网络堆栈的排队机制][2]
- [Queueing in the Linux Network Stack][7]

4. 了解网络内核参数
- [Linux之TCPIP内核参数优化][4]
- 实例讲解，[Improving TCP performance over a gigabit network with lots of connections and high traffic of small packets][10]

5. Wireshark/Tshark相关**网络工具**和**脚本**汇总
- [Tools][3]
- 很实用，Wireshark/Tshark用户肯定需要知道和了解的

6. netsniff
netsniff 套件中包含netsniff, trafgen, ifpps等工具；该套件是一个高性能的网络工具，功能丰富
- netsniff（数据包捕获/回放）
`netsniff-ng --in em3  --out /home/em3.pcap --silent --ring-size 500MiB --prio-high --verbose --bind-cpu 0`
- trafgen（流量生成）
`trafgen --cpp --dev ens33 --conf synflood.trafgen --verbose`
- ifpps （实时流量查询）
`ifpps --dev ens160`

7. 其他
- 实时流量查询命令, `vnstat`
- 打印出网卡p5p2内核ring buffer, `dmesg | grep p5p2`
- 查看网卡流量信息, `cat /proc/net/dev`
- 查看网络内核参数设置，`sysctl -a | grep net.core`
- 查看网卡PCI信息, `lspci -vvv | grep -i ethernet -A 5`


  [1]: http://docs.gz.ro/node/282
  [2]: http://www.codeweblog.com/linux-%E7%BD%91%E7%BB%9C%E5%A0%86%E6%A0%88%E7%9A%84%E6%8E%92%E9%98%9F%E6%9C%BA%E5%88%B6/
  [3]: https://wiki.wireshark.org/Tools
  [4]: http://www.cnblogs.com/fczjuever/archive/2013/04/17/3026694.html
  [5]: http://www.lenky.info/archives/2012/02/1028
  [6]: http://blog.csdn.net/wjw7869/article/details/49835409
  [7]: http://www.linuxjournal.com/content/queueing-linux-network-stack
  [8]: http://www.draconyx.net/articles/netsniff-ng-high-performant-packet-sniff.html
  [9]: http://blog.hyfather.com/blog/2013/03/04/ifconfig/
  [10]: http://serverfault.com/questions/357799/improving-tcp-performance-over-a-gigabit-network-with-lots-of-connections-and-hi
