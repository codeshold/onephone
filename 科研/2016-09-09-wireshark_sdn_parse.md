---
layout: post
title: 让wireshark支持OF协议解析
category: 科研
tags: [SDN]
---

> 谈到OpenFlow协议数据包的解析，之前自己直接是从Mininet官网下载了虚拟机镜像（ubuntu）的，里面已经包含了wireshark套件，拿来即可用！
最近需要在CentOS物理机上进行抓包分析，在安装Wireshark和openflow dissecctor时碰到了一些小问题，在此总结整理并分享下...

----------

## 0. 说明
1. 本文将按照CentOS的版本分别说明如何安装wireshark，并使其支持OpenFlow协议的解析
2. wireshark新版本已支持OpenFlow,但截至日前，在CentOS上需要手动编译安装，对安装环境等有要求，所以**比较繁琐**，详细请见[官方wiki描述][1]和[wireshark源码下载][2]

## 1. CentOS 6 下 wireshark && openflow
### 1.1 最简单的方法（第三方of dissector）
- yum 安装wireshark`yum install -y wireshark*`，安装成功后如下
```
[root@share ofdissector]# rpm -aq | grep wireshark
wireshark-gnome-1.8.10-17.el6.x86_64
wireshark-devel-1.8.10-17.el6.x86_64
wireshark-1.8.10-17.el6.x86_64
```
- 启动wireshark（`wireshark &`），查看其版本信息(可直接通过命令`wireshark -v`)，是否支持**lua**,如下图
![wireshark version information][3]
    1. **如果不支持lua**,可下载第三方解析包[ofdissector][4],原git网页上已有详细的编译安装说明，很简单(需要scons环境，`yum install scons -y`)！
    2. **如果支持lua**,可直接从floodlight上下载[lua文件][5]，然后放入wireshark插件目录（Help-->About Wireshark-->Floders / Plugins，笔者直接放入全局目录下），接着重启wireshark即可
```
[root@gf01 Desktop]# cd /usr/lib64/wireshark/plugins/1.10.14/
[root@gf01 1.10.14]# wget https://raw.githubusercontent.com/floodlight/loxigen-artifacts/master/wireshark/openflow.lua
[root@gf01 1.10.14]# chmod a+x openflow.lua 
```

### 1.2 安装最新版本wireshark
在CentOS下安装新版本支持openflow协议的wireshark很繁琐，不建议本步骤，如需这样建议直接升级系统到CentOS7！！！
1. 下载编译安装，如下系统报了Qt5Core版本的错误，且yum支持qt3的安装，故需要转入Qt5的安装
```
[root@share ~]# wget https://www.wireshark.org/download/src/wireshark-2.0.3.tar.bz2
[root@share ~]# tar -xjf wireshark-2.0.3.tar.bz2
[root@share ~]# cd wireshark-2.0.3 && ./configure
......
checking for sed... (cached) /bin/sed
checking for GNU sed as first sed in PATH... yes
checking if profile builds must be generated... no
checking for Qt5Core - version >= 5.0.0... no
checking for QtCore - version >= 4.7.0... no
configure: error: Qt is not available
[root@share ~]# cat /etc/redhat-release
CentOS release 6.7 (Final)
[root@share ~]# yum search qt
...
qt3.x86_64 : The shared library for the Qt 3 GUI toolkit
...
qt3-devel.i686 : Development files for the Qt 3 GUI toolkit
...
```
2. Qt5的安装，笔者从google找到了一篇详细的安装教程——[如何在CentOS6上安装Qt5和Qwt][6]，参考这份文档安装好两个后重新编译wireshark即可(如果你成功的话)，但关键是需要可能需要**“重新编译gcc,重新编译gcc，重新编译gcc”**，这是一个超级耗时的过程（笔者在戴尔OPTIPLEX 9020主机上编译直接花了4个小时，哭了...）
3. [gcc编译安装][7]，这个在第2步中的教程中已经包含，只是在国内需要找镜像下载，具体地址可以从[gnu ftp][8]上找到，如下
```
[root@share ~]#  wget http://mirrors.ustc.edu.cn/gnu/gcc/gcc-6.1.0/gcc-6.1.0.tar.gz
```
> 本方法很繁琐，有兴趣和时间的可以尝试，毕竟原生版本在支持力和性能方面会好不少

## 2. CentOS 7 下 wireshark && openflow
### 2.1 最简单的方法(第三方of dissector)
1. yum安装wireshark，参见**1.1-->支持lua**，安装成功后，版本信息如下，其是支持lua的，且启动wireshark后，发现该版本并不支持openflow协议(（Help-->About Wireshark-->Plugins)，直接参考**1.1-->支持lua**即可！
```
[root@gf01 1.10.14]# cat /etc/redhat-release 
CentOS Linux release 7.2.1511 (Core) 
[root@gf01 1.10.14]# rpm -aq | grep wireshark
wireshark-devel-1.10.14-7.el7.x86_64
wireshark-gnome-1.10.14-7.el7.x86_64
wireshark-1.10.14-7.el7.x86_64
[root@gf01 1.10.14]# wireshark -v
wireshark 1.10.14 (Git Rev Unknown from unknown)

Copyright 1998-2015 Gerald Combs <gerald@wireshark.org> and contributors.
This is free software; see the source for copying conditions. There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Compiled (64-bit) with GTK+ 2.24.28, with Cairo 1.14.2, with Pango 1.36.8, with
GLib 2.42.2, with libpcap, with libz 1.2.7, with POSIX capabilities (Linux),
without libnl, with SMI 0.4.8, with c-ares 1.10.0, with Lua 5.1, without Python,
with GnuTLS 3.3.8, with Gcrypt 1.5.3, with MIT Kerberos, without GeoIP, without
PortAudio, with AirPcap.

Running on Linux 3.10.0-327.el7.x86_64, with locale en_US.UTF-8, with libpcap
version 1.5.3, with libz 1.2.7, GnuTLS 3.3.8, Gcrypt 1.5.3, without AirPcap.
Intel(R) Xeon(R) CPU E5-2620 v3 @ 2.40GHz

Built using gcc 4.8.5 20150623 (Red Hat 4.8.5-4).
[root@gf01 1.10.14]# 

```
### 2.2 安装最新版本wireshark

1. yum 安装Qt5相关软件包
`yum search qt5`
2. 参考**1.2**进行编译安装wireshark

## 3. 参考链接
1. qt下载 http://qt-project.org/downloads 及 https://www.qt.io/download-open-source/#section-2
2. gcc编译 https://gcc.gnu.org/wiki/InstallingGCC
3. CentOS 6.7下安装qt5 https://wiki.qt.io/How-to-Install-Qt-5-and-Qwt-on-CentOS-6
4. https://wiki.wireshark.org/OpenFlow



  [1]: https://wiki.wireshark.org/OpenFlow
  [2]: https://www.wireshark.org/download/src/
  [3]: http://static.zybuluo.com/wuzhimang/xil5jdq9ov5mtetkkd29dcsh/image_1ajr51bnu1cc9dvvg6n1v1n1gf59.png
  [4]: https://github.com/CPqD/ofdissector
  [5]: https://raw.githubusercontent.com/floodlight/loxigen-artifacts/master/wireshark/openflow.lua
  [6]: https://wiki.qt.io/How-to-Install-Qt-5-and-Qwt-on-CentOS-6
  [7]: https://gcc.gnu.org/wiki/InstallingGCC
  [8]: http://www.gnu.org/prep/ftp.html

