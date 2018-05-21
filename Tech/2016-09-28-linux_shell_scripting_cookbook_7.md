---
title: linux shell 学习摘记（7） 
layout: post
author: WenfengShi
category: 技术
tags: [shell]
---

> 《linux shell 脚本编程攻略 （第2版）》 第七章 “无网不利”笔记  
  
> 常用命令：`ifocnfig`, `host`, `nslookup`, `dhclient`, `route`, `ping`, `fping`, `nc`, `lsof`, `netstat`, `iwconfig`, `ssh`, `sshfs`, `firewall`, `&子进程`  
  
- 打印网络接口列表`ifconfig | cut -c-10 | tr -d ' ' | tr -s '\n'`  
  
- 提取IP地址`ifconfig em1 | grep -E -o "inet addr:[^ ]*" | grep -o "[0-9.]*"`  
  
- 硬件地址欺骗`ifconfig em1 hw ether 00:1c:bf:87:25:d5`  
  
- 分配给当前系统的域名服务器`cat /etc/resolv.conf`  
  
- `host codeshold.me`(/ect/hosts), `nslookup codeshold.me`  
  
- `dhclient em1`  
  
- `route add deafult gw IP_ADDRESS INTERFACE_NAME`, `route add default gw 192.168.0.1 wlan0`  
  
- `ping -c 2 codeshold.me`, 列出网上所有活动的主机`fping`  
  
- 通过`&`加速脚本执行速度，并行执行, `wait`等待所有子进程结束后在退出  
  
```  
#!/bin/bash  
for ip in 10.10.{0..255}.{1..255}  
do   
    (  
        ping $ip -c 3 &> /dev/null;  
        if [ $? -eq 0 ];  
        then  
            echo $ip is alive  
        fi  
    )&  
done  
wait  
```  
  
- `fping -a 192.160.1/24 -g`, `fping -a < ip.list`  
  
- **ESSID**(Extended Service Set Identification) `iwconfig`   
  
```  
#!/bin/bash  
  
IFACE=wlan0  
IP_ADDR=10.10.82.155  
SUBNET_MAST=255.255.255.0  
GW=192.168.1.1  
HW_ADDR="00:1c:bf:87:25:d2"  
  
ESSID="homenet"  
WEP_KEY=8b140b20e7  
FREQ=2.462G  
KEY_PART=""  
  
if [[ -n $WEP_KEY ]];  
then  
    KEY_PART="key $WEP_KEY"  
fi  
  
ifconfig $IFACE down  
  
if [ $UID -ne 0 ];  
then  
    echo "Run as root"  
    exit 1;  
fi  
  
if [[ -n $HW_ADDR ]];  
then  
    ifconfig $IFACE hw ether $HW_ADDR  
    echo Spoofed MAC ADDRESS to $HW_ADDR  
fi  
  
iwconfig $IFACE essid $ESSID $KEY_PART freq $FREQ  
  
ifconfig $IP_ADDR netmask $SUBNET_MASK  
  
route add default gw $GW $IFACE  
  
echo Successfully configured $IFACE  
  
```  
  
- **ssh 端口转发**  
    1. `ssh -L 8000:www.codeshold.me:80 user@localhost` 将本地端口8000的流量转发到www.codeshold.me:80上  
    2. `ssh -fL 8000:www.codeshold.me:80 user@localhost -N`, `-f`后台运行， `-N`无需执行命令，只进行端口转发  
    3. **反向端口转发**: `ssh -R 8000:localhost:80 user@REMOTEMACHINE`   
  
- 在本地挂载远程驱动器  
    1. `sshfs -o allowother user@remotehost:/home/path /mnt/mountpoint`  
    2. `umount /mnt/mountpoint`  
  
- 列出本地主机当前的开放端口 `lsof -i | grep ":[0-9]\+->" -o | grep "[0-9]\+" -o | sort | uniq`  
  
- `netstat -tnp`  
  
- 创建网络套接字 `nc -l 1234`, `nc HOST 1234`; `nc -l 1234 > destionationfilename`, `nc HOST 1234 < sourcefilename`  
  
- **iptables**互联网连接共享  
  
```  
#!/bin/bash  
echo 1> /proc/sys/net/ipv4/ip_forward  
iptables -A FORWARD -i $1 -o $2 -s 10.10.0.0/16 -m conntrack --ctstate NEW -j ACCEPT  
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT  
iptables -A POSTROUTING -t nat -j MASQUERADE  
```  
