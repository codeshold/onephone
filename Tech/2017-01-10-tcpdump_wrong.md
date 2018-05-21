---
title: tcpdump过滤数据包，结果不对？
layout: post
author: WenfengShi
category: 技术
tags: [network, tools]
---
> 需要写个程序通过`pcap-filter`表达式过滤数据包，测试时发现过滤结果不对！现将问题简化如下(以tcpdump举例)

## 问题描述

1. 通过 **tcpdump** 过滤出**173_20170107_180747_p5p2.pcap** 文件中IP为 **10.10.88.173**的数据包，并保存为**result.pcap**,过滤命令 `tcpdump -r 173_20170107_180747_p5p2.pcap -w result.pcap "host 10.10.88.173"`
2. 原始数据包用**wireshark**打开，设置过滤表达式为`ip.addr==10.10.88.173`，发现IP为 **10.10.88.173**的数据包个数为`7150`
3. 但用**wireshark**打开tcpdump过滤出的**result.pcap**文件，发现其数据包个数为`7152`，如下图！(*此时如果知道原因就不用往下看了*)
![image_1b5sh1esi12fhcde4ln8id1k1r1c.png-97.6kB][1]
![image_1b5sh37cbdt41hthgqrk3ntgo1p.png-89kB][2]


## 问题分析
1. 通过对比wireshark和tcpdump过滤出的数据包，发现**tcpdump**过滤出的pcap文件，多了两个ARP数据包。如图
![image_1b5si96kh1o96afr1qeam615b530.png-37.4kB][3]
2. 但就自己所了解的，ARP协议应属于链路层的，不属于IP网络层的(*这种表述可能有争论*)，为什么tcpdump会将其包含在过滤结果内呢？
3. 通过`man pcap-filter`查阅pcap-filter表达式语法，发现自己写的tcpdump过滤表达式`host 10.10.88.173`是正确的啊
![image_1b5siqkvebebkal10scanm1nf53d.png-4.2kB][4]
4. 但细看却发现，默认下的`host`,`src host`, `dst host`过滤出的数据包，是包含**ARP**， **RARP**协议的！！！wireshark解析ARP数据包，其也包含对应的IP **10.10.88.173**, `man pcap-filter`，其准确描述如下
![image_1b5sj4q5krlc1uka1i1bjul1gkn3q.png-17.1kB][5]

## 问题解决
1. 将tcpdump过滤表达式修改为`ip host 10.10.88.173`，即运行命令`tcpdump -r 173_20170107_180747_p5p2.pcap -w result.pcap "ip host 10.10.88.173"`即可！

## 问题总结
1. 在使用tcpdump或其他工具过特定IP的数据包时，pcap-filter过滤表达式的书写要注意！
2. 如果仅仅是想过滤出IP层的特定IP的数据，需要使用`ip host X.X.X.X`或`ip src X.X.X.X`或`ip dst X.X.X.X`
3. 如果仅仅是想过滤出ARP或RARP协议的IP数据包时，需要使用`arp host X.X.X.X` 或 `rarp host X.X.X.X`
4. `man pcap-filter`，多熟悉下



  [1]: http://static.zybuluo.com/wuzhimang/ih7alq6d44u728xxu016t016/image_1b5sh1esi12fhcde4ln8id1k1r1c.png
  [2]: http://static.zybuluo.com/wuzhimang/e37gs29m8oxvw4hn6iqsvfvi/image_1b5sh37cbdt41hthgqrk3ntgo1p.png
  [3]: http://static.zybuluo.com/wuzhimang/q8tfvs2677hu7wdmw6yefrb1/image_1b5si96kh1o96afr1qeam615b530.png
  [4]: http://static.zybuluo.com/wuzhimang/bnfyrjmnjzxm0w7c2dv2twrb/image_1b5siqkvebebkal10scanm1nf53d.png
  [5]: http://static.zybuluo.com/wuzhimang/n9uxcfysy5vl520ujjemhn8z/image_1b5sj4q5krlc1uka1i1bjul1gkn3q.png
