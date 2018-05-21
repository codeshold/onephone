---
layout: post
title: TOE,RDMA等相关概念及Chelsio产品介绍
category: 科研
tags: [高速网络]
---
## 核心基础概念
1. FCoE：以太网光纤通道 (Fibre Channel Over Ethernet)
- 它是一个存储网络协议，允许在以太网上发送光纤通道帧， 且IP通信和光纤通道通信使用相同的以太网端口。
2. HBA：[host bus adapter][1]，主机总线适配器
- 它是连接主机计算机到网络/存储设备的可插拔式卡，支持多种存储网络协议，HBA通常是扩展卡，如PCI Express卡，它插入主机计算机的总线传送iSCSI或FC协议。
3. OEM： 原始设备制造商（original equipment manufacturer）
4. CNA：[Converged network adapter][2]，融合网路适配器，也称C-NIC
- 作为计算机输入/输出设备，其融合了HBA和网络适配器的功能。简言之，通过CNA可同时访问SAN（存储区域网络）和传统的计算机网络。
- 如单一万兆以太网适配器端口上同时运行TCP/IP，iSCSI和光纤通道以太网数据流a
![image_1arf3ukpp14sou51ihn3mi1nl69.png-32.9kB][3]
5. TOE：TCP Offlod Engine，TCP负荷减轻引擎，也称TCP卸载引擎。
- TOE一般由软硬件构成，将传统的TCP/延伸，把网络数流量的处理工作全部转到网卡上的集成硬件中进行，服务器只承担TCP/IP控制信息的处理决策任务
![image_1arf8052e1hec5qgo9oon72jfm.png-95.7kB][4]
6. ASIC：特定用途集成电路（Application Specific Integrated Circuit）
7. InfiniBand：InfiniBand架构是一种支持多并发链接的"转换线缆"技术，是一种长缆线的连接方式，具有高速、低延迟的传输特性。
- 主要是用于在服务器集群，系统之间的互联。
- **发展**
> 需要说明的是，即使在系统之间的互联，InfiniBand也还面临着竞争对手，这是因为自英特尔、微软退出IBTA之后，IBM、惠普也在不久后退出，并在第二年提出**RDMA**(Remote Direct Memory Access，远程直接内存存取)技术，期望用10 Gbps Ethernet搭配**TOE**(TCP/IP Offload Engine，TCP/IP负荷卸载引擎)的硬件加速设计，以更标准、低廉的方式与InfiniBand进行竞争。此外，由Broadcom、Chelsio、惠普、NetApp和微软等厂商推动的**iWarp**，一种用于远程直接内存访问、远程直接数据放置的保护协议，它淘汰了两端的网卡，也是一种标准的协议。另外，**英特尔的I/O加速技**术也与InfiniBand具有一定的竞争关系。

9. RDMA: Remote Direct Memory Access，远程直接内存存取
- [RDMA原理][5]
8. iWARP: Internet Wide Area RDMA Protocol 一种用于远程直接内存访问、远程直接数据放置的保护协议，它淘汰了两端的网卡，也是一种标准的协议。
- 一种通过以太网做RDMA的解决方案，其能够试下同Infiniband同样的RDMA特性
9. Cut-though：直通转发技术 (Cut-through)又叫快速转发。
10. SCSI：Small Computer System Interface，小型计算机系统接口
- 一种用于计算机和智能设备之间（硬盘、软驱、光驱、打印机、扫描仪等）系统级接口的独立处理器标准。
- 是一种智能的通用接口标准。
![image_1arfpueog2sqhq5106neftf189.png-93.8kB][6]
10. iSCSI：Internet 小型计算机系统接口 （iSCSI：Internet Small Computer System Interface）
- iSCSI技术是一种新储存技术，该技术是将现有SCSI接口与以太网络(Ethernet)技术结合，使服务器可与使用IP网络的储存装置互相交换数据
- 是一种基于 TCP/IP的协议，用来建立和管理 IP 存储设备、主机和客户机等之间的相互连接，并创建存储区域网络（SAN）。
11. SMB：Server Message Block 服务信息块，又称Common Internet File System（CIFS）A
- 由微软、英特尔开发的一种软件程序级的网络传输协议，主要用来使得一个网络上的机器共享计算机文件、打印机、串行端口和通讯等资源。它也提供认证的行程间通讯机能。
- SMB 是在会话层（session layer）和表示层（presentation layer）以及小部分应用层（application layer）的协议。SMB使用了NetBIOS的应用程序接口
- 它主要用在装有Microsoft Windows的机器上，在这样的机器上被称为Microsoft Windows Network。
12. RoCE：[RDMA over Converged Ethernet][7]
12. iSER：[iSCSI Extensions for RDMA][8]
-  对iSCSI协议进行了RDMA扩展的计算机网络协议。
-  支持RDMA的包括：基于TCP的RDMA服务（iWARP)，不基于TCP的RoCE协议，以及InfiniBand技术。
- iSER允许直接在SCSI计算机内存缓冲区中进行数据的传输，无需中间层的数据拷贝和过多的CPU干预。
- 读命令的执行
![image_1arhrlk0mnfd12hd1hpc2ap148a1g.png-94.6kB][9]
- 写命令的执行
![image_1arhrnve2uh1kq3o24bqneuu1t.png-111.1kB][10]

10. **SR‐IOV**：single‐root I/O virtualization；**PF**：physical function；**VFs** ： multiple virtual functions ；**VI** Virtual Interfaces


## Chelsio产品
### TCP Offload at 40Gbps
- 原文链接：[TCP Offload at 40Gbps][11]
- TOE技术特点。
This opens the way for very powerful extensions to pure protocol offload, including:
1. Direct Data Placement (DDP), which addresses the memory subsystem bottleneck problem on receive
2. Direct Data Sourcing (DDS), which addresses the memory subsystem bottleneck problem on send
3. Application layer data integrity check (CRC) offload, typically used in data critical applications, which are not satisfied with the relatively weak Internet checksum protection(e.g. iSCSI header and payload digests)
4. Reliable remote direct memory to memory access with RDMA
5. Further application layer offload, such as application layer payload recovery security protocol offload
6. Per connection TCP level traffic management and quality of service

### Terminator 5 ASICA（终结者T5）
1. T5 is a highly integrated, hyper- virtualized 10/40GbE controller built around a programmable
protocol-processing engine, with full offload of a complete Unified Wire solution comprising
**NIC**, **TOE**, **iWARP RDMA**, **ISCSI**, **FCoE** and **NAT** support.

2. T5 ASIC 体现了Chelsio公司的，第五代TOE设计技术，第四代iSCSI设计技术，第三代iWARP RDMA实现技术
3. T5-Based Unified Adapter
![image_1arfpecinpba14gl17nb1ucn1uo71t.png-400.2kB][12]

4. T5 Capability Overview
![image_1arfq3b5g5j71q0s1c4v17hctfcm.png-299.9kB][13]

5. Storage Value Propositon
![image_1arfqaleg6qjo1nub1sik170n13.png-200.5kB][14]

5. High Performance RDMA 
- 1.5 µsec latency, line rate bandwidth
- iWARP support on Linux OFED
- Network Direct support 
- Socket user\space I/O (TCP and UDP, raw Ethernet) 
- Transport for Microsoft SMB\Direct (SMB 3.0)



## 参考及扩展阅读
1. [融合网络适配器(CNA)：网络整合之王][15]
2. [SAN架构、FC与FCoE][16]
3. [FCoE基本原理][17]
4. [关于TOE技术的发展及概况的研究--2005年][18]
5. [TOE-Technical-Briefi:TCP Offload at 40Gbps][19]
6. [Chelsio 白皮书系列][20]
7. [RDMA原理][5]

  [1]: https://en.wikipedia.org/wiki/Host_adapter
  [2]: https://en.wikipedia.org/wiki/Converged_network_adapter
  [3]: http://static.zybuluo.com/wuzhimang/uzsx0w85rt8hu8sdb6o4sq96/image_1arf3ukpp14sou51ihn3mi1nl69.png
  [4]: http://static.zybuluo.com/wuzhimang/ygbio5xaiglcueqt4zaqh7yn/image_1arf8052e1hec5qgo9oon72jfm.png
  [5]: http://wiki.mbalib.com/wiki/RDMA
  [6]: http://static.zybuluo.com/wuzhimang/p0oon2hqfjw402xpz1z1wrj3/image_1arfpueog2sqhq5106neftf189.png
  [7]: https://en.wikipedia.org/wiki/RDMA_over_Converged_Ethernet
  [8]: https://en.wikipedia.org/wiki/ISCSI_Extensions_for_RDMA
  [9]: http://static.zybuluo.com/wuzhimang/72wbvnohvlpfyjyerw8dzea1/image_1arhrlk0mnfd12hd1hpc2ap148a1g.png
  [10]: http://static.zybuluo.com/wuzhimang/j2alxe8s7dc3w82ty46qfsa4/image_1arhrnve2uh1kq3o24bqneuu1t.png
  [11]: http://www.chelsio.com/wp-content/uploads/2013/09/TOE-Technical-Brief.pdf
  [12]: http://static.zybuluo.com/wuzhimang/gmyq6gvobgollpc24zzywoqm/image_1arfpecinpba14gl17nb1ucn1uo71t.png
  [13]: http://static.zybuluo.com/wuzhimang/v9ftdyybtqlvl805ujckx0vi/image_1arfq3b5g5j71q0s1c4v17hctfcm.png
  [14]: http://static.zybuluo.com/wuzhimang/wmwfyk06i235m0s4jqgwpy43/image_1arfqaleg6qjo1nub1sik170n13.png
  [15]: http://www.enkj.com/idcnews/Article/20130807/1562
  [16]: http://storage.it168.com/a2011/0125/1153/000001153724_1.shtml
  [17]: http://www.cnblogs.com/zhuyp1015/archive/2012/08/11/2633311.html
  [18]: http://d.wanfangdata.com.cn/Periodical/hongw200503005
  [19]: http://www.chelsio.com/wp-content/uploads/2013/09/TOE-Technical-Brief.pdf
  [20]: http://www.chelsio.com/white-papers/
