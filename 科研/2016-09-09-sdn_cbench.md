---
layout: post
title: SDN Cbench 安装
category: 科研
tags: [SDN]
---

## 1. 为什么要写这篇“浅显”的博客
- 网上搜索到的安装步骤基本都是来源于[这篇13年的文章][1]，而这篇文章来源于11年的[OFLOPS:User manual][2]，**安装步骤都out了**，没必要那么繁琐，故需要更新
- 笔者实际做了相关的实验，并不是简单的**复制再改改**，具体安装步骤已精简过
- 分享也是一种自我提升的过程（但本文内容确实很浅），只是为了方便大家
- Cbench是一个很好的开源工具，**安装**和使用都应很方便


## 2. Cbench安装步骤

### 2.1 一般安装
Cbench是OFLOPS（an OpenFlow testing platform）的一个部件，以下是Cbench，也是OFLOPS的一般安装步骤（已在CentOS 7.2 和 Ubuntu 14.04下安装测试过）

- 安装相关的依赖包
`yum install -y autoconf automake libtool libpcap-devel net-snmp-devel libconfig-devel`
或者
`apt-get install -y autoconf automake libtool libpcap-dev libsnmp-dev libconfig-dev`

- 下载OpenFlow和OFLOPS
`git clone git://gitosis.stanford.edu/openflow.git`
`git clone git://gitosis.stanford.edu/oflops.git`

- 下载NetFPGA并编译
```
[root@gf01 benchmark]# ls
oflops  openflow
[root@gf01 benchmark]# cd oflops && git submodule init && git submodule update
[root@gf01 oflops]# cd netfpga-packet-generator-c-library
[root@gf01 netfpga-packet-generator-c-library]# ./autogen.sh && ./configure && make
```
- 编译安装Cbench（即OFLOPS）
```
[root@gf01 netfpga-packet-generator-c-library]# cd ..
[root@gf01 oflops]# sh ./boot.sh && ./configure && make && make install
[root@gf01 oflops]# cd cbench
[root@gf01 cbench]# ./cbench -h
help message
......
```

### 2.2 简易安装
为方便大家，已将自己下载并更新了的git packages上传到[网盘][3]上,下载后简单的安装步骤如下：

- 参考2.1第一步安装依赖包
- 下载源码编译安装
```
# unzip -q cbench_201606.zip
# cd netfpga-packet-generator-c-library && ./autogen.sh && ./configure && make
# cd .. && sh ./boot.sh && ./configure && make && make install
# cd cbench && ./cbench -h
```

## 3. 使用说明
参考 http://www.sdnlab.com/15112.html 或者本人后续的分享

## 4. 可能出现的问题
1. linux下的环境不尽一样，若编译过程中出现各类缺少相应软件包的问题，即"not found"，可以针对特定的包进行安装，也可以一开始就安装整个Development环境，CentOS下`yum groups install Development Tools`
2. 若需要手动编译安装**libconfig**, 可从 http://www.hyperrealm.com/libconfig/ 下载源码包，然后编译安装
3. 其他有关安装的疑惑和问题可参考官方文档[OFLOPS:User manual][5]的第5-6页
4. 其他问题欢迎留言


## 5. 参考资料
1. https://floodlight.atlassian.net/wiki/pages/viewpage.action?pageId=1343657
2. http://archive.openflow.org/wk/images/3/3e/Manual.pdf
3. http://www.sdnlab.com/15112.html


  [1]: https://floodlight.atlassian.net/wiki/pages/viewpage.action?pageId=1343657
  [2]: http://archive.openflow.org/wk/images/3/3e/Manual.pdf
  [3]: http://pan.baidu.com/s/1eR4EszK
  [4]: http://www.sdnlab.com/15112.html
  [5]: http://archive.openflow.org/wk/images/3/3e/Manual.pdf`
