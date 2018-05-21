---
title: 网卡参数查询及设置工具ethtool
layout: post
author: WenfengShi
category: 技术
tags: [network, tools]
---
> ethtool是用来查询和设置网卡驱动&硬件信息的工具，功能很强大！Linux一般都会默认安装，在进行网络调试和网络性能分析时非常有用。提供统计信息查询、ring buffer设置、协议卸载设置、网卡测试等等……

> 自己在进行DDoS攻击模拟、分析和测试中经常使用！

## 简单实例

> 以网卡p5p2为例

- 查看NIC ring buffer大小， `ethtool -g p5p2`

```
[root@globus03 20160924]# ethtool -g p5p2
Ring parameters for p5p2:
Pre-set maximums:
RX:		4078
RX Mini:	0
RX Jumbo:	0
TX:		4078
Current hardware settings:
RX:		2014
RX Mini:	0
RX Jumbo:	0
TX:		4078
```

- 设置NIC ring buffer大小，`ethtool -G p5p2 rx 4078`
详细命令，`ethtool -G|--set-ring devname [rx N] [rx-mini N] [rx-jumbo N] [tx N]`

```
[root@globus03 20160924]# ethtool -G p5p2 rx 4078
[root@globus03 20160924]# ethtool -g p5p2
Ring parameters for p5p2:
Pre-set maximums:
RX:		4078
RX Mini:	0
RX Jumbo:	0
TX:		4078
Current hardware settings:
RX:		4078
RX Mini:	0
RX Jumbo:	0
TX:		4078
```

- 查看网卡驱动信息 `ethtool -i p5p2`

```
[root@globus03 20160924]# ethtool -i p5p2
driver: bnx2x
version: 1.710.51-0
firmware-version: FFV7.12.19 bc 7.12.5 phy 1.45
bus-info: 0000:06:00.1
supports-statistics: yes
supports-test: yes
supports-eeprom-access: yes
supports-register-dump: yes
supports-priv-flags: yes
```

- 查看当前网卡主要信息,` ethtool p5p2`

```
[root@globus03 20160924]# ethtool p5p2
Settings for p5p2:
	Supported ports: [ TP ]
	Supported link modes:   100baseT/Half 100baseT/Full 
	                        1000baseT/Full 
	                        10000baseT/Full 
	Supported pause frame use: Symmetric Receive-only
	Supports auto-negotiation: Yes
	Advertised link modes:  100baseT/Half 100baseT/Full 
	                        1000baseT/Full 
	                        10000baseT/Full 
	Advertised pause frame use: Symmetric Receive-only
	Advertised auto-negotiation: Yes
	Link partner advertised link modes:  100baseT/Half 100baseT/Full 
	                                     1000baseT/Half 1000baseT/Full 
	                                     10000baseT/Full 
	Link partner advertised pause frame use: No
	Link partner advertised auto-negotiation: Yes
	Speed: 10000Mb/s
	Duplex: Full
	Port: Twisted Pair
	PHYAD: 17
	Transceiver: internal
	Auto-negotiation: on
	MDI-X: Unknown
	Supports Wake-on: g
	Wake-on: d
	Current message level: 0x00000000 (0)
			       
	Link detected: yes
```

- 网卡测试命令, `ethtool -t p5p2 online`
详细命令为`ethtool -t|--test devname [offline|online|external_lb]`，其中online表示不需要重启网卡的测试，offline表示要重启网卡

```
[root@globus03 ~]# ethtool -t p5p2 online
The test result is PASS
The test extra info:
register_test (offline)    	 0
memory_test (offline)      	 0
int_loopback_test (offline)	 0
ext_loopback_test (offline)	 0
nvram_test (online)        	 0
interrupt_test (online)    	 0
link_test (online)         	 0
```

## 统计信息
- 查询网卡接收数据包信息,`ethtool -S em2 | grep -i error`

```
[root@globus03 ~]# ethtool -S em2 | grep -i error
     rx_fcs_errors: 0
     rx_align_errors: 0
     rx_frame_too_long_errors: 0
     rx_in_length_errors: 0
     rx_out_length_errors: 0
     tx_mac_errors: 0
     tx_carrier_sense_errors: 0
     tx_errors: 0
```

- 查询网卡接收的数据包信息,`ethtool -S em2 | grep -i error`

```
[root@globus03 ~]# ethtool -S em2 | grep -i rx
     rx_octets: 0
     rx_fragments: 0
     rx_ucast_packets: 0
     rx_mcast_packets: 0
     rx_bcast_packets: 0
     rx_fcs_errors: 0
…………
```

## 协议卸载
> offload 是将本来该操作系统进行的一些数据包处理（如分片、重组等）放到网卡硬件中去做，降低系统 CPU 消耗的同时，提高处理的性能。


- 查询网卡协议卸载(offload)信息, `ethtool -k p5p2`
- 信息说明
1. LSO/LRO
分别对应到发送和接收两个方向，是 **Large Segment Offload** 和 **Large Receive Offload**
2. LSO
在发送数据超过 MTU 限制的时候（太容易发生了），OS 只需要提交一次传输请求给网卡，网卡会自动的把数据拿过来，然后进行切，并封包发出，发出的网包不超过 MTU 限制。
当网卡收到很多碎片包的时候，LRO 可以辅助自动组合成一段较大的数据，一次性提交给 OS处理。
一般的，LSO 和 LRO 主要面向 TCP 报文。
3. GSO/GRO
Generic Segmentation Offload 和 Generic Receive Offload，分别比 LSO 和 LRO 更通用，自动检测网卡支持特性，支持分包则直接发给网卡，否则先分包后发给网卡。这样大数据包只需走一次协议栈，而不是被分割成几个数据包分别走，提高了效率。新的驱动一般用 GSO/GRO。
4. TSO/UFO
T**CP Segmentation Offload** 和 **UDP fragmentation offload**，分别对应 TCP 报文和 UDP 报文。
很典型的，TCP 协议中就考虑了分片存在的情况，往往是切分 TCP 的数据包，叫做 TSO。而一般的情况，则称为 LSO 或者 GSO。
对于其他不支持切片的协议例如 UDP，则只能进行 IP 层上的切片。
5. RSS
RSS(**Receive Side Scaling**)，是一项网卡的新特性，俗称多队列。具备多个RSS队列的网卡，可以将不同的网络流分成不同的队列，再分别将这些队列分配到多个CPU核心上进行处理，从而将负荷分散，充分利用多核处理器的能力。
- 全部信息显示

```
[root@globus03 ~]# ethtool -k p5p2
Features for p5p2:
rx-checksumming: on
tx-checksumming: on
    tx-checksum-ipv4: on
    tx-checksum-ip-generic: off [fixed]
    tx-checksum-ipv6: on
    tx-checksum-fcoe-crc: off [fixed]
    tx-checksum-sctp: off [fixed]
scatter-gather: on
    tx-scatter-gather: on
    tx-scatter-gather-fraglist: off [fixed]
tcp-segmentation-offload: on
    tx-tcp-segmentation: on
    tx-tcp-ecn-segmentation: on
    tx-tcp6-segmentation: on
udp-fragmentation-offload: off [fixed]
generic-segmentation-offload: on
generic-receive-offload: on
large-receive-offload: off
rx-vlan-offload: on [fixed]
tx-vlan-offload: on
ntuple-filters: off [fixed]
receive-hashing: on
highdma: on [fixed]
rx-vlan-filter: off [fixed]
vlan-challenged: off [fixed]
tx-lockless: off [fixed]
netns-local: off [fixed]
tx-gso-robust: off [fixed]
tx-fcoe-segmentation: off [fixed]
tx-gre-segmentation: on
tx-ipip-segmentation: on
tx-sit-segmentation: on
tx-udp_tnl-segmentation: on
tx-mpls-segmentation: off [fixed]
fcoe-mtu: off [fixed]
tx-nocache-copy: off
loopback: off
rx-fcs: off [fixed]
rx-all: off [fixed]
tx-vlan-stag-hw-insert: off [fixed]
rx-vlan-stag-hw-parse: off [fixed]
rx-vlan-stag-filter: off [fixed]
busy-poll: on [fixed]
```

- 协议卸载设置
`ethtool -K eth0 gso off`（接收GSO）
详细命令`ethtool -K|--features|--offload devname feature on|off ...`
