---
title: Linux路由、防火墙、NAT命令 
layout: post
author: WenfengShi
category: 技术
tags: [运维]
---

## 路由设置
1. 主要命令
- route
`route [-CFvnee]` 
`route  [-v] [-A family] add [-net|-host] target [netmask Nm] [gw Gw] [metric N] [mss M] [window W] [irtt I] [reject] [mod] [dyn] [reinstate] [[dev] If]`
`route  [-v] [-A family] del [-net|-host] target [gw Gw] [netmask Nm] [metric N] [[dev] If]`
`route  [-V] [--version] [-h] [--help]`
- ifconfig
`ifconfig [device] [ IP ] netmask [netmask ip] [up|down]`
- arp
`arp [-v] [-H type] [-i if] -s hostname hw_addr [temp]`
`arp [-v] [-H type] [-i if] -s hostname hw_addr [netmask nm] pub`

2. 静态路由设置
**所规划的路由必须是设备（如eth0）或IP可直接连通的（BroadCast）的**, 即若随意设置 *gw X.X.X.X* 会返回 *SIOCADDRT: Network is unreachable* 的错误信息。
- 添加路由
`route add -net 10.10.82.0/24 gw 10.10.82.1` 
`route add -net 10.10.82.0 netmask 255.255.255.0 gw 10.10.82.1` 效果同上
`route add -net 10.10.82.0/24 dev em1` 发向10.10.82.0/24的数据包会由em1走出
`route add -net 0.0.0.0/0 gw 10.10.88.1` 添加默认路由网关 10.10.88.1
- 删除路由
`route del -net 10.10.82.0/24` 删除对应路由，若匹配了多条，则删除第一条
- 路由配置文件
**通过route命令添加的路由不会写入配置文件，下次重启后失效！**
新建*/etc/sysconfig/network-scripts/route-em1*配置文件，并添加**10.10.82.0/24 via 10.10.82.1 dev em1**。

3. 动态路由设置
需要软件[zebra][1] 或 [Quagga][2] 的支持, 可参考鸟哥的[动态路由器假设：quagga][3]

4. **单网卡多IP设置**，IP Alias
- 方式一：`ifconfig em1:0 192.168.0.100/24 up` 在网卡 em1 上设置新ip，但重启或`service network restart`后会失效
- 方式二：建立虚拟设备配置文件，如下新建 */etc/sysconfig/network-scripts/ifcfg-em1:0* 文件
```
[root@share network-scripts]# pwd
/etc/sysconfig/network-scripts
[root@share network-scripts]# cat ifcfg-em1:0
DEVICE=em1:0
ONBOOT=yes
BOOTPROTO=static
IPADDR=192.168.1.1
NETMASK=255.255.255.0
[root@share network-scripts]# service network restart
```

5. 路由器配置
- 开启内核数据包转发功能
方法一：`echo "1" > /proc/sys/net/ipv4/ip_forward` 临时开启
方法二：`vim /etc/sysctl.conf ` 设置 **net.ipv4.ip_forward = 1**， 然后`sysctl -p`使其立刻生效
- **ARP Proxy -- 同一网段跨在路由器的两边**
如下图的的场景，左边的worakstation和右下角的三台主机属于同一网段，但中间有Linux Router隔开，这时候就需要在Linux Router配置 ARP Proxy。
![ARP Proxy][4]
设置流程如下：
第一步：设定外部 eth0 的 ARP Proxy，分别让PC2-PC4三个 IP 对应到Linux Router的 eth0 MAC。`arp -i eth0 -s 192.168.1.10 08:00:27:71:85:BD pub`， *pub* 表示 eth0 接口会回复该对应的 ARP 请求；
第二步：设置PC2-PC4的单机路由由内部eth1来传递，`route add -host 192.168.1.10 eth1`
第三步：设定内部 eth1 的 ARP Proxy， 让PC1的 IP 对应到 Linux Router的eth1 MAC。`arp -i eth1 -s 192.168.1.101 08:00:27:2A:30:14 pub`。
**上述设置需要写成脚本或直接写入rc.local

## 防火墙
1. 主要命令
- firewall
- iptables


  [1]: http://www.zebra.org/
  [2]: http://www.quagga.net/
  [3]: http://cn.linux.vbird.org/linux_server/0230router_3.php
  [4]: http://static.zybuluo.com/wuzhimang/hn1m0uwupdodezopgq95rh4h/image_1apv3fgip1cl81uua1p2v19k4afq13.png
