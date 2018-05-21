---
title: “图解服务器端网络架构”小结
layout: post
author: WenfengShi
category: 技术
tags: [network]
---
博客链接: [http://codeshold.me/2017/05/network_architecture.html](http://codeshold.me/2017/05/network_architecture.html)

> 一本写给网络架构师和服务器工程师的书! 很棒！
对于想成为码网农工（码农＋网工）的我来说，这本书带给自己的帮助很大，至少让自己在参加网络技术大赛的期间收获了不少！
其中还有另外一本书《图解基础设施设计模式》！
[这里](http://www.ituring.com.cn/book/1494)有针对《图解服务器端网络架构》这本书的介绍，也包括试读章节（第0章就是教读者怎么使用本书的）！
本文主要是自己的读书笔记……


## 0x00 网络架构的流程
1. 网络架构分为六个阶段
    - 需求定义: 客户需给出需求方案说明书（RFP，Request For Proposal）
    - 基础设计
    - 详细设计
    - 架构
    - 测试: 单元测试、正常测试、故障（冗余化）测试等
    - 运行
2. 网络架构的重点是基础设计
    - 物理设计: 定义服务器端所有实体对象的所有规则
    - 逻辑设计
    - 安全设计和负载均衡设计
    - 高可用设计: 冗余
    - 管理设计
    - 设计原则（`华为AMPRSC原则, availability + manageability + performance + recoverability + security + cost`)


## 0x01 物理设计

### 1. 技术
1. IEEE 802.3, IEEE 802.11
2. 双绞线、同轴电缆
    - STP (shielded twist pair, 屏蔽双绞线) 抗电磁干扰，只有在工厂等恶劣的条件下会用到
    - UTP (unshielded twist pair, 非屏蔽双绞线) 使用广泛
    - 双绞线中的“类”，其代表传输速度，值越大传输速度就越大，如1000BASE-T
    - 双绞线中的“直通线”和“交叉线”
        - MDI和MDI-X, Medium Dependent Interface，即RJ-45铜线的排列顺序
        - 交换机的端口是MDI-X端口，但有自动识别端口类型功能的交换机（Auto MDI/MDi-X)
        - MDI和MDI-X使用直通线连接（两边对称，平行排列）
        - 端口类型相同时使用交叉线连接
        - 1000BASE-T 中八根铜线都会用到
    - 双绞线电缆的最大传输距离是100米
    - 中继集线器大多已被交换集线器所代替（都可用于故障排除，但后者通信量少）
    - 设置速率和双工，通过交换FLP(Fast Link Pulse, 快速连接脉冲)信号
3. 单模光纤、多模光纤
    - 光通道叫做模
    - 单模光纤（SMF）， 多模光纤（MMF, Multi Mode Fiber）
    - 单模传播距离远，价格高（70km)，MMF是550m
    - 连接器有SC、LC型

### 2. 设计
1. CE交换机（Customer Edge), VSS(Virtual Switching System 虚拟交换系统)
2. 服务器端有两种结构类型
    - 串联式结构:管理方便
    - 并联式结构:容易扩展
3. 选用设备时应参考考查项的最大值
4. iSCSI、FCoE(Fiber Channel over Ethernet)
5. 接入交换机、汇聚交换机、核心交换机
    - EoR(End of row)端列头式
        - 以整个机架`列`为单位配置接入叫混迹的类型
        - 布线复杂
        - 需要管理的接入交换机数量少
    - ToR(Top of Rack)机架式
        - 以整个机架为单位配置接入交换机的类型
        - 布线操作比较轻松
        - 由于是在每个机架中配置接入交换机，故要管理的设备较多
6. 电源引入机架后：PDU(Power Distribution Unit 电源分配单元)， UPS(Uninterrupible Power Supply 不间断电源)


## 0x02 逻辑设计

### 1. 技术
1. 数据链路层
    - 前导码(8字节)、帧头、FCS(Frame Check Sequence)
    - MAC地址中前24位叫做OUI(Organizationally Unique Identifer 组织唯一标识符)
2. 网络层
    - CIDR(Classless Inter-Domain Routing 无分类域间路由)
    - IGP(Interior Gateway Protocol) + EGP(Exterior Gateway Protocol)
        - IGP: RIPv2, OSPF, EIGRP(Enhanced Interior Gateway Routing Protocol)
        - EGP: BGP
        - AS(Autonomous System)
        - OSPF: `100/带宽(Mibt/s)` 开销，等价多路径
        - EIGRP: `1000/最小带宽`， `微秒/10`
3. AD(Administrative Distance 管理距离)值类似于针对每个路由协议制定的优先级，值越小优先的等级就越高
4. 静态NAT, NAPT(Network Address Port Translation) 和 Twice NAT(双重NAT, 将源目的地址一起转换)
    - 支持NAT的两大要素是NAT表和代理ARP
5. 广播地址：本地、受限、直接（远程开机 WoL, Wake-on-LAN)
6. ARP, GARP(Gratutious ARP 无故ARP):检测IP是否冲突、更新相邻设备的表(GARP通告，但也可以取消)
7. `224`开头是D类地址
8. ICMP
    - ICMP 差错报告报文 echo
    - ICMP 询问报文: 时间超时、源点抑制、改变路由、终点不可达、参数问题
9. VLAN: 基于端口的VLAN(交换机)；打标VLAN（VLAN ID)

### 2. 设计
1. VLAN的设计
    - 防火墙内侧VLAN、防火墙外侧VLAN
    - 迁移的通信流量对服务产生的影响控制在最小
    - 数据备份的VLAN
    - 数据迁移的VLAN
    - VLAN尽量做大，且采用核心交换机，这样可以使得管理优势最大化
2. IP地址分配的统一
    - 网络设备的IP地址从数字最大的编号用起
    - 服务器和用户终端的IP地址从数字最小的编号用起
3. 路由器 && L3交换机 的选择


## 0x03 数据安全设计和负载均衡设计
### 1. 技术
1. 传输层技术
2. 负载均衡设备可以监控服务器（进行健康检查）
    - 健康检查可分为L3检查、L4检查、L7检查
        - L3: 通过ICMP来检查IP是否正常等
        - L4：针对端口号等
        - L7: 针对应用程序
    - 目的NAT是LB的基础
3. 负载均衡方式
    - 静态
        - 轮询
        - 加权比例
    - 动态
        - 最少连接数
        - 最短响应时间
    - 源IP地址会话保持、Cookie会话保持
    - 可选功能: SSL加速、HTTP压缩、连接汇聚
4. `HTTP 1.0`, `HTTP 1.1`, `HTTP 2.0`
5. CSR(Certificat Signing Request 证书签名请求) ：为获得服务器证书而提交给CA机构的随机字符串
6. 从会话层到应用层的技术
7. FTP传输文件
    - 主动模式
        - 控制连接使用`TCP/21`, 数据连接使用`TCP/20`, 大多数默认采用这种
        - Windows标准FTP客户端功能中甚至只有这种模式
        - 由服务器方面发出数据连接的请求(SYN `TCP/20`) 是一种特殊的模式
    - 被动模式
        - 控制连接使用`TCP/21`, 数据连接不使用特定端口的模式
        - 出于安全考虑，使用这种模式的例子多了起来
8. DNS使用TCP进行区域传输
9. 端口号：`0~1023`
10. 状态检测和包过滤之间的区别！（前者针对连接，后者针对数据包）
11. UTM(Uinfied Threat Management 统一威胁管理) 设备综合了VPN(IPSec VPN, SSL VPN)、IDS/IPS、反病毒、反垃圾邮件过滤等设备
12. 新一代的防火墙能更深入的识别应用
13. FQDN(Fully Qualified Domain Name 完全合格域名)

### 2. 设计
1. 数据安全设计
    - 定义安全域，Untrust区域、DMZ区域、Trust区域
    - 将默认启动服务控制在最小范围内
2. 多级防御，UTM(Performance)
3. 负载均衡设计


## 0x04 高可用性设计

### 1. 技术

#### 1.1 物理层
1. 将多条物理链路聚合成一条逻辑链路
    - 链路聚合分为三种模式
        - 静态
        - PAgP(Port Aggregation Protocol, 端口聚合协议): 思科专有
        - LACP(Link Aggregation Control Protocol, 链路聚合控制协议), `Eth-Trunk链路聚合`
2. 多个物理网卡集结成一个逻辑网卡
    - 三种网卡组合方式: AFT(Adapter Fault Tolerance 适配器容错),ALB(Adapter Load Balancing 适配器负载均衡), 链路聚合
3. 将不同种类的物理网卡组合使用
    - 板载网卡、扩展网卡
4. 将多台物理设备集结成一台逻辑设备
    - VSS(Virtual Switching System) ：思科
    - 很多厂商都有自己的技术，华为、思科等都有
    - 堆叠线
5. 高可用设计的主角是STP(Spanning-Tree Protocol)
6. 上行链路故障检测（追踪）技术 UFD(Uplink Failture Detection)
7. GVRP 实现动态VLAN

#### 1.2 数据链路层
1. 生成树协议 STP
2. 根网桥、阻塞端口等
3. STP有三种(P286)
    - PVST(Per VLAN Spanning-Tree)：思科
    - RSTP(Rapid Spanning-Tree 快速生成树协议)
        - 可快速进行切换
    - MSTP(Multiple Spanning-Tree 多生成树协议)
        - 减少通信开销和资源占用
        - 多了VLAN组成一个组群
        - 每个域内多个生成树
        - 执行和处理是基于MSTI的
![image_1bhn3j8dp1bl91j76pafmih45d9.png-55.2kB][1]


#### 1.3 网络层
1. FHRP(First Hop Redundancy Protocol 第一跳冗余协议)和路由协议
2. FHRP: 默认网关冗余备份协议(P293)
    - HARP(Hot Standby Routing Protocol 热备份路由协议)：思科
    - VRRP(Virtual Prouter Redundancy Protocol 虚拟路由器冗余协议)
    - GLBP(Gateway Load Balancing Protocol 网关负载均衡协议)
3. 通过IGP实现冗余
4. BPDU守护，FAST Port边缘端口
![image_1bhn3kuuq1388g7o9ua1b8p120um.png-105.1kB][2]


#### 1.4 传输层到应用层
1. 防火墙荣誉技术是在FHRP中添加了几项同步技术
    - 同步连接信息
    - 设置虚拟MAC地址
2. 负载均衡的冗余技术则是进一步添加了应用程序的同步技术
    - 同步会话保持信息

### 2. 设计
1. 串联式、并联式
2. 两层(无汇聚交换机)、三层


## 0x05 管理设计
1. NTP 时间同步
    - “层”的概念： Stratum
2. 用SNMP检测故障
    - MIB(Management Information BAse 信息管理库), OID(Object Identifier 对象标识符) 
3. Syslog检测故障
4. 传递设备信息
    - CDP：Cisco Discovery Protocol 思科的L2层
    - LLDP: Link Layer Discovery Protocol 链路层发现协议, DMZ区不激活，Unstrust区激活
5. 确定主机名
6. 通过标签管理连接
    - 线缆标签
    - 本体标签
7. 设计密码
8. 管理设备信息
    - 恢复方式及备份方式

> 《图解服务器端网络架构》错误处
1. P355 中`Cisco Descovery Protocol`中的Descovery应是Discovery



  [1]: http://static.zybuluo.com/wuzhimang/i79yf1eaafy68ouxstk0ojqq/image_1bhn3j8dp1bl91j76pafmih45d9.png
  [2]: http://static.zybuluo.com/wuzhimang/pdv6nkp49czwhvyj2i7h3nsv/image_1bhn3kuuq1388g7o9ua1b8p120um.png
