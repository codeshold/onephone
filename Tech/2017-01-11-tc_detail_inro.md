---
title: 流量控制工具TC详细说明
layout: post
author: WenfengShi
category: 技术
tags: [network, tools]
---
## 原理介绍
> Linux操作系统中的流量控制器**TC**（Traffic Control）用于Linux内核的流量控制，它利用队列规定建立处理数据包的队列，并定义队列中的数据包被发送的方式， 从而实现对流量的控制。TC模块实现流量控制功能使用的队列规定分为两类，一类是无类队列规定， 另一类是分类队列规定。 无类队列规定相对简单，而分类队列规定则引出了分类和过滤器等概念，使其流量控制功能增强。

1. **无类队列规定**是对进入网络设备(网卡) 的数据流不加区分统一对待的队列规定。
- 使用无类队列规定形成的队列能够 接受数据包以及重新编排、延迟或丢弃数据包。这类队列规 定形成的队列可以对整个网络设备( 网卡) 的流量进行整形， 但不能细分各种情况。
- 常用的无类队列规定主要有pfifo _fast (先进现出) 、TBF ( 令牌桶过滤器) 、SFQ(随机公平队列) 、ID (前 向随机丢包)等等。这类队列规定使用的流量整形手段主要 是排序、限速和丢包。
2. **分类队列规定**是对进入网络设备的数据包根据不同的需求以分类的方式区分对待的队列规定。
- 数据包进入一个分类的队列后， 它就需要被送到某一个类中， 也就是说需要对数据包做分类处理。对数据包进行分类的工具是过滤器，过滤器会返回一个决定，队列规定就根据这个决定把数据包送入相应的类进行排队。
- 每个子类都可以再次使用它们的过滤器进行进一步的分类。直到不需要进一步分类时， 数据包才进入该类包含的队列排队。
- 除了能够包含其它队列规定之外， 绝大多数分类的队列规定还能够对流量进行整形。 这对于需要同时进行调度( 如使用 SFQ ) 和流量控制的场合非常有用。
3. **基本原理图**
![image_1b6at6vf47qubm51vq69qvaod1g.png-54kB][1]
- 接收包从输入接口（Input Interface）进来后，经过流量限制**（Ingress Policing**）丢弃不符合规定的数据包，由输入多路分配器（**Input De-Multiplexing**）进行判断选择......
- 如果接收包的目的是本主机，那么将该包送给上层处理；否则需要进行转发，将接收包交到转发块（Forwarding Block）处理。转发块同时也接收本主机上层（TCP、UDP等）产生的包。转发块通过查看路由表，决定所处理包的下一跳。然后，对包进行排列以便将它们传送到输出接口（Output Interface）。
- 一般我们只能限制网卡发送的数据包，不能限制网卡接收的数据包，所以我们可以通过改变发送次序来控制传输速率。
- Linux流量控制主要是在**输出接口**排列时进行处理和实现的。

## TC规则

### 1. 流量控制
> 流量控制包括以下4种方式

1. SHAPING(限制)
当流量被限制，它的传输速率就被控制在某个值以下。限制值可以大大小于有效带宽，这样可以平滑突发数据流量，使网络更为稳定。shaping（限制）只适用于向外的流量。
2. SCHEDULING(调度)
通过调度数据包的传输，可以在带宽范围内，按照优先级分配带宽。SCHEDULING(调度)也只适于向外的流量。
3. POLICING(策略)
SHAPING用于处理向外的流量，而POLICIING(策略)用于处理接收到的数据。
4. DROPPING(丢弃)
如果流量超过某个设定的带宽，就丢弃数据包，不管是向内还是向外。

### 2. 流量控制处理对象
> 流量的处理由三种对象控制，它们是：qdisc(排队规则)、class(类别)和filter(过滤器)。

#### 2.1 QDisc
- QDisc(排队规则)是**queueing discipline**的简写，它是理解流量控制(traffic control)的基础。
- 无论何时，内核如果需要通过某个网络接口发送数据包，它都需要按照为这个接口配置的qdisc(排队规则)把数据包加入队列。然后，内核会尽可能多地从qdisc里面取出数据包，把它们交给网络适配器驱动模块。
- 最简单的QDisc是pfifo它不对进入的数据包做任何的处理，数据包采用先入先出的方式通过队列。不过，它会保存网络接口一时无法处理的数据包。
- QDISC的分为CLASSLESS QDisc和CLASSFUL QDISC类别,即**不可分类QDisc**和**可分类QDisc**

#### 2.2 CLASSLESS QDisc
1. 无类别QDISC包括
- `[p|b]fifo`
使用最简单的qdisc，纯粹的先进先出。只有一个参数：limit，用来设置队列的长度,pfifo是以数据包的个数为单位；bfifo是以字节数为单位。
- `pfifo_fast`
在编译内核时，如果打开了高级路由器(Advanced Router)编译选项，pfifo_fast就是系统的标准QDISC。它的队列包括三个波段(band)。在每个波段里面，使用先进先出规则。而三个波段(band)的优先级也不相同，band 0的优先级最高，band 2的最低。如果band里面有数据包，系统就不会处理band 1里面的数据包，band 1和band 2之间也是一样。数据包是按照服务类型(Type of Service,TOS)被分配多三个波段(band)里面的。
- `red`
red是**Random Early Detection**(随机早期探测)的简写。如果使用这种QDISC，当带宽的占用接近于规定的带宽时，系统会随机地丢弃一些数据包。它非常适合高带宽应用。
- `sfq`
sfq是**Stochastic Fairness Queueing**的简写。它按照会话(session--对应于每个TCP连接或者UDP流)为流量进行排序，然后循环发送每个会话的数据包。
- `tbf`
tbf是**Token Bucket Filter**的简写，适合于把流速降低到某个值。
2. 无类别QDisc的配置
- 如果没有可分类QDisc，不可分类QDisc只能附属于设备的根,使用命令`tc qdisc add dev DEV root QDISC QDISC-PARAMETERS`
- 要删除一个不可分类QDisc，需要使用命令`tc qdisc del dev DEV root`
- 一个网络接口上如果没有设置QDisc，pfifo_fast就作为缺省的QDisc。

#### 2.3 CLASSFUL QDISC
可分类QDISC包括：

1. CBQ
- CBQ是Class Based Queueing(基于类别排队)的缩写。
- 它实现了一个丰富的连接共享类别结构，既有限制(shaping)带宽的能力，也具有带宽优先级管理的能力。
- 带宽限制是通过计算连接的空闲时间完成的。
- 空闲时间的计算标准是数据包离队事件的频率和下层连接(数据链路层)的带宽。
2. HTB
- HTB是Hierarchy Token Bucket的缩写。
- 通过在实践基础上的改进，它实现了一个丰富的连接共享类别体系。使用HTB可以很容易地保证每个类别的带宽，虽然它也允许特定的类可以突破带宽上限，占用别的类的带宽。
- HTB可以通过TBF(Token Bucket Filter)实现带宽限制，也能够划分类别的优先级。
3. PRIO
- PRIO QDisc不能限制带宽，因为属于不同类别的数据包是顺序离队的。
- 使用PRIO QDisc可以很容易对流量进行优先级管理，只有属于高优先级类别的数据包全部发送完毕，才会发送属于低优先级类别的数据包。
- 为了方便管理，需要使用iptables或者ipchains处理数据包的服务类型(Type Of Service,ToS)。

### 2. 操作原理
- 类(Class)组成一个树，每个类都只有一个父类，而一个类可以有多个子类。某些QDisc(例如：CBQ和HTB)允许在运行时动态添加类，而其它的QDisc(例如：PRIO)不允许动态建立类。允许动态添加类的QDisc可以有零个或者多个子类，由它们为数据包排队。
- 此外，每个类都有一个叶子QDisc，默认情况下，这个叶子QDisc使用pfifo的方式排队，我们也可以使用其它类型的QDisc代替这个默认的QDisc。而且，这个叶子叶子QDisc有可以分类，不过每个子类只能有一个叶子QDisc。当一个数据包进入一个分类QDisc，它会被归入某个子类。
- 如果过滤器附属于一个类，相关的指令就会对它们进行查询。过滤器能够匹配数据包头所有的域，也可以匹配由ipchains或者iptables做的标记。
- 树的每个节点都可以有自己的过滤器，但是高层的过滤器也可以直接用于其子类。如果数据包没有被成功归类，就会被排到这个类的叶子QDisc的队中。相关细节在各个QDisc的手册页中

### 3. 命令规则
> 所有的QDisc、类和过滤器都有ID。ID可以手工设置，也可以有内核自动分配。ID由一个主序列号和一个从序列号组成，两个数字用一个冒号分开。

- **QDISC**，一个QDisc会被分配一个主序列号，叫做句柄(handle)，然后把从序列号作为类的命名空间。句柄采用象10:一样的表达方式。习惯上，需要为有子类的QDisc显式地分配一个句柄。
- 类(**CLASS**)，在同一个QDisc里面的类分享这个QDisc的主序列号，但是每个类都有自己的从序列号，叫做类识别符(classid)。类识别符只与父QDisc有关，和父类无关。类的命名习惯和QDisc的相同。
- 过滤器(**FILTER**)，过滤器的ID有三部分，只有在对过滤器进行散列组织才会用到。详情请参考tc-filters手册页。

## TC命令
tc可以使用以下命令对QDisc、类和过滤器进行操作：

1. **add**，在一个节点里加入一个QDisc、类或者过滤器。添加时，需要传递一个祖先作为参数，传递参数时既可以使用ID也可以直接传递设备的根。如果要建立一个QDisc或者过滤器，可以使用句柄(handle)来命名；如果要建立一个类，可以使用类识别符(classid)来命名。
2. **remove**，删除有某个句柄(handle)指定的QDisc，根QDisc(root)也可以删除。被删除QDisc上的所有子类以及附属于各个类的过滤器都会被自动删除。
3. **change**，以替代的方式修改某些条目。除了句柄(handle)和祖先不能修改以外，change命令的语法和add命令相同。换句话说，change命令不能一定节点的位置。
4. **replace**，对一个现有节点进行近于原子操作的删除／添加。如果节点不存在，这个命令就会建立节点。
5. **link**，只适用于DQisc，替代一个现有的节点。

```
tc qdisc [ add | change | replace | link ] dev DEV [ parent qdisc-id | root ] [ handle qdisc-id ] qdisc [ qdisc specific parameters ]

tc class [ add | change | replace ] dev DEV parent qdisc-id [ classid class-id ] qdisc [ qdisc specific parameters ]

tc filter [ add | change | replace ] dev DEV [ parent qdisc-id | root ] protocol protocol prio priority filtertype [ filtertype specific parameters ] flowid flow-id

tc [-s | -d ] qdisc show [ dev DEV ]

tc [-s | -d ] class show dev DEV tc filter show dev DEV
```

## 具体操作
Linux流量控制主要分为建立队列、建立分类和建立过滤器三个方面。

### 1. 基本步骤
1. 针对网络物理设备（如以太网卡eth0）绑定一个队列QDisc；
2. 在该队列上建立分类class；
3. 为每一分类建立一个基于路由的过滤器filter；
4. 最后与过滤器相配合，建立特定的路由表。

### 2. 模拟实例
流量控制器上的以太网卡(eth0) 的IP地址为192.168.1.66，在其上建立一个CBQ队列。假设包的平均大小为1000字节，包间隔发送单元的大小为8字节，可接收冲突的发送最长包数目为20字节。
假如有三种类型的流量需要控制:

- 是发往主机1的，其IP地址为192.168.1.24。其流量带宽控制在8Mbit，优先级为2；
- 是发往主机2的，其IP地址为192.168.1.30。其流量带宽控制在1Mbit，优先级为1； 
- 是发往子网1的，其子网号为192.168.1.0，子网掩码为255.255.255.0。流量带宽控制在1Mbit，优先级为6。

#### 2.1 建立队列
一般情况下，针对一个网卡只需建立一个队列。
将一个cbq队列绑定到网络物理设备eth0上，其编号为1:0；网络物理设备eth0的实际带宽为10 Mbit，包的平均大小为1000字节；包间隔发送单元的大小为8字节，最小传输包大小为64字节。
`tc qdisc add dev eth0 root handle 1: cbq bandwidth 10Mbit avpkt 1000 cell 8 mpu 64`

#### 2.2 建立分类
分类建立在队列之上。
一般情况下，针对一个队列需建立一个根分类，然后再在其上建立子分类。对于分类，按其分类的编号顺序起作用，编号小的优先；一旦符合某个分类匹配规则，通过该分类发送数据包，则其后的分类不再起作用。

1. 创建根分类1:1；分配带宽为10Mbit，优先级别为8。
- `tc class add dev eth0 parent 1:0 classid 1:1 cbq bandwidth 10Mbit rate 10Mbit maxburst 20 allot 1514 prio 8 avpkt 1000 cell 8 weight 1Mbit`
- 该队列的最大可用带宽为10Mbit，实际分配的带宽为10Mbit，可接收冲突的发送最长包数目为20字节；最大传输单元加MAC头的大小为1514字节，优先级别为8，包的平均大小为1000字节，包间隔发送单元的大小为8字节，相应于实际带宽的加权速率为1Mbit。
2. 创建分类1:2，其父分类为1:1，分配带宽为8Mbit，优先级别为2。
- `tc class add dev eth0 parent 1:0 classid 1:1 cbq bandwidth 10Mbit rate 10Mbit maxburst 20 allot 1514 prio 8 avpkt 1000 cell 8 weight 1Mbit`
- 该队列的最大可用带宽为10Mbit，实际分配的带宽为 8Mbit，可接收冲突的发送最长包数目为20字节；最大传输单元加MAC头的大小为1514字节，优先级别为1，包的平均大小为1000字节，包间隔发送单元的大小为8字节，相应于实际带宽的加权速率为800Kbit，分类的分离点为1:0，且不可借用未使用带宽。
3. 创建分类1:3，其父分类为1:1，分配带宽为1Mbit，优先级别为1。
- `tc class add dev eth0 parent 1:1 classid 1:3 cbq bandwidth 10Mbit rate 1Mbit maxburst 20 allot 1514 prio 1 avpkt 1000 cell 8 weight 100Kbit split 1:0`
- 该队列的最大可用带宽为10Mbit，实际分配的带宽为 1Mbit，可接收冲突的发送最长包数目为20字节；最大传输单元加MAC头的大小为1514字节，优先级别为2，包的平均大小为1000字节，包间隔发送单元的大小为8字节，相应于实际带宽的加权速率为100Kbit，分类的分离点为1:0。
4. 创建分类1:4，其父分类为1:1，分配带宽为1Mbit，优先级别为6。
- `tc class add dev eth0 parent 1:1 classid 1:4 cbq bandwidth 10Mbit rate 1Mbit maxburst 20 allot 1514 prio 6 avpkt 1000 cell 8 weight 100Kbit split 1:0`
- 该队列的最大可用带宽为10Mbit，实际分配的带宽为1Mbit，可接收冲突的发送最长包数目为20字节；最大传输单元加MAC头的大小为1514字节，优先级别为6，包的平均大小为1000字节，包间隔发送单元的大小为8字节，相应于实际带宽的加权速率为100Kbit，分类的分离点为1:0。

#### 2.3. 建立过滤器
过滤器主要服务于分类。
一般只需针对根分类提供一个过滤器，然后为每个子分类提供路由映射。

1. 应用路由分类器到cbq队列的根，父分类编号为1:0；过滤协议为ip，优先级别为100，过滤器为基于路由表。
- `tc filter add dev eth0 parent 1:0 protocol ip prio 100 route`
2. 建立路由映射分类1:2, 1:3, 1:4
- `tc filter add dev eth0 parent 1:0 protocol ip prio 100 route to 2 flowid 1:2`
- `tc filter add dev eth0 parent 1:0 protocol ip prio 100 route to 3 flowid 1:3`
- `tc filter add dev eth0 parent 1:0 protocol ip prio 100 route to 4 flowid 1:4`

#### 2.4 建立路由
该路由是与前面所建立的路由映射一一对应。

1. 发往主机192.168.1.24的数据包通过分类2转发(分类2的速率8Mbit)
- `ip route add 192.168.1.24 dev eth0 via 192.168.1.66 realm 2`
2. 发往主机192.168.1.30的数据包通过分类3转发(分类3的速率1Mbit)
- `ip route add 192.168.1.24 dev eth0 via 192.168.1.66 realm 2`
3. 发往子网192.168.1.0/24的数据包通过分类4转发(分类4的速率1Mbit)
- `ip route add 192.168.1.0/24 dev eth0 via 192.168.1.66 realm 4`

注：一般对于流量控制器所直接连接的网段建议使用IP主机地址流量控制限制，不要使用子网流量控制限制。如一定需要对直连子网使用子网流量控制限制，则在建立该子网的路由映射前，需将原先由系统建立的路由删除，才可完成相应步骤。

#### 2.5 监视
主要包括对现有队列、分类、过滤器和路由的状况进行监视。

1. 显示队列的状况
- 简单显示指定设备(这里为eth0)的队列状况
`tc qdisc ls dev eth0`
- 详细显示指定设备(这里为eth0)的队列状况
`tc -s qdisc ls dev eth0`
2. 显示分类的状况
- 简单显示指定设备(这里为eth0)的分类状况
`tc class ls dev eth0`
- 详细显示指定设备(这里为eth0)的分类状况
`tc -s class ls dev eth0`
3. 显示过滤器的状况
- `tc -s filter ls dev eth0`
4. 显示现有路由的状况
- `ip route`

#### 2.6 维护
主要包括对队列、分类、过滤器和路由的增添、修改和删除。
增添动作一般依照"队列->分类->过滤器->路由"的顺序进行；修改动作则没有什么要求；删除则依照"路由->过滤器->分类->队列"的顺序进行。

1. 队列的维护
一般对于一台流量控制器来说，出厂时针对每个以太网卡均已配置好一个队列了，通常情况下对队列无需进行增添、修改和删除动作了。
2. 分类的维护
- 增添，增添动作通过tc class add命令实现
- 修改，修改动作通过tc class change命令实现
`tc class change dev eth0 parent 1:1 classid 1:2 cbq bandwidth 10Mbit rate 7Mbit maxburst 20 allot 1514 prio 2 avpkt 1000 cell 8 weight 700Kbit split 1:0 bounded`
对于bounded命令应慎用，一旦添加后就进行修改，只可通过删除后再添加来实现。
- 删除，删除动作只在该分类没有工作前才可进行，一旦通过该分类发送过数据，则无法删除它了。因此，需要通过shell文件方式来修改，通过重新启动来完成删除动作。
3. 过滤器的维护
- 增添，增添动作通过tc filter add命令实现
- 修改，修改动作通过tc filter change命令实现
`tc filter change dev eth0 parent 1:0 protocol ip prio 100 route to 10 flowid 1:8`
- 删除，删除动作通过tc filter del命令实现
`tc filter change dev eth0 parent 1:0 protocol ip prio 100 route to 10 flowid 1:8`

4. 与过滤器一一映射路由的维护
- 增添，增添动作通过ip route add命令实现，如前面所示。
- 修改，修改动作通过ip route change命令实现
`ip route change 192.168.1.30 dev eth0 via 192.168.1.66 realm 8`

- 删除，删除动作通过ip route del命令实现
`ip route del 192.168.1.30 dev eth0 via 192.168.1.66 realm 8`
`ip route del 192.168.1.30 dev eth0 via 192.168.1.66 realm 8`


  [1]: http://static.zybuluo.com/wuzhimang/e9fmwwxai2c64omfuxuc17am/image_1b6at6vf47qubm51vq69qvaod1g.png
