---
title: 配置ntp(知其所以然)
layout: post
author: WenfengShi
category: 技术
tags: [linux]
---

> 最近在一家公司出差，被人问及"如何自动实现服务器间的时间同步"，对方百度了几篇教程，但并没有成功，重点是**教程**反而使得当事人对ntp.conf下的配置更加迷惑！自己写了篇简单的博文，说明下...

## 场景说明

1. 两台业务服务器的系统时间要确保同步(10.10.88.171, 10.10.88.172)
2. IDC机房内有一台ntp服务器(10.10.88.123)，但有时候会连接不上
3. 业务服务器不能连外网，但有本地yum源
3. 服务器操作系统以CentOS 7为例

## 配置说明

1. 将10.10.88.171作为一个本地业务ntp服务器，在不能和10.10.88.123服务器同步的时候，使用本机自己的系统时间并提供ntp服务
2. 10.10.88.172 作为ntp客户端，实时和10.10.88.171保持时间同步

## NTP Server 配置

### 1. 安装软件

`yum install ntp`

### 2. 修改ntp.conf中的restrict值

配置文件`/etc/ntp.conf`
```bash
# Permit time synchronization with our time source, but do not
# permit the source to query or modify the service on this system.
restrict default nomodify notrap nopeer noquery
```
第一行restrict允许其他客户端请求你的时间服务器，**保持默认即可**(默认是未注释的)！
详细参数说明如下：

- noquery 禁止从该ntpd中dump状态数据
- notrap 禁止控制消息trap该服务器
- nomodify 禁止所有企图修改该服务器的ntpq请求
- nopeer 禁止所有企图建立peer association的数据包

### 3. 仅允许特定网段客户端与ntp服务器进行同步

- ntp.conf中添加`restrict 10.10.88.0 mask 255.255.255.0 nomodify notrap`
- 如果本地主机需要查询和修改权限，再添加`restrict 127.0.0.1` --> **建议添加**，若有保持默认即可!
- 由于服务器不能联网，建议注释掉部分内容并添加`server 10.10.88.123 iburst`,如下
```bash
#server 0.centos.pool.ntp.org iburst
#server 1.centos.pool.ntp.org iburst
#server 2.centos.pool.ntp.org iburst
#server 3.centos.pool.ntp.org iburst
server 10.10.88.123 iburst
```

### 4. 将本地时间作为备份

> 当ntp服务器(10.10.88.171)不能连接到上级ntp服务器(10.10.88.123)时, 171以本机系统时间提供时间同步服务。

在ntp.conf中添加如下内容，注意是**127.127.1.0**!!!
```bash
server 127.127.1.0 # 本机时间
fudge 127.127.1.0 stratum 10
```
第二行的stratum表示的是时间同步的一个层级关系，stratum-1 server充当重要的网络时间标准，stratum-2 server 请求 startum-1 server 完成时间同步... 类推，startum-n server 请求 startum-n-1 server并完成时间同步


### 5. 启动ntp服务器

`systemctl start ntpd` 启动ntpd服务
`systemctl enable ntpd` 设置开机启动

### 6. 验证ntp
在未启动ntpd服务的Client上(10.10.88.172)，`ntpdate -u 10.10.88.171` 进行验证！
注：如果Client和Server时间差很多，请先进行手动设置Client时间再进行ntpdate同步(要不然，可能会同步失败)


## NTP Client 配置
1. 安装ntpd, `yum install ntpd`
2. 编辑`/etc/ntp.conf`配置文件
- 注释掉以下内容（因为服务器不能连外网）
```bash
#server 0.centos.pool.ntp.org iburst
#server 1.centos.pool.ntp.org iburst
#server 2.centos.pool.ntp.org iburst
#server 3.centos.pool.ntp.org iburst
```
- 添加`server 10.10.88.171 prefer`
3. 启动ntp服务
`system`start ntpd` 启动ntpd服务
`system enable ntpd` 设置开机启动(用于实时更新)
4. 验证
终端输入`ntpstat`
