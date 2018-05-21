---
title: NetDevOps技术分享会
layout: post
author: WenfengShi
category: 碎言
tags: [技术分享]
---
博客链接: [http://codeshold.me/2017/04/sdnlab_netdevops.html](http://codeshold.me/2017/04/sdnlab_netdevops.html)

> 20170408 下午 沪太路335号 3Wcoffee
> 网工不插线技术分享会 -- NetDevOps


## 我与网络运维的二三事

> 佘敦成，阿里巴巴平台技术事业群

- about me
    - 职责
        - 水位监控、业务异常、网络变更、链路扩展
        - 70%凌晨变更， 30%白天
- 坑
    1. 更完后删除垃圾配置
    2. 业务丢包，在Juniper设备上配置counting计数器抓包统计
    3. 集群核心交换机上联链路的更换

- 程序员的思维
    - 大量重复的操作、检查，一定要让机器去做
    - 工具平台开发，研发与运维充分沟通交流
    - 工具发布后，快速更近、反馈迭代
    - 以管理服务器的方式，来管理网络设备

- 白屏化、智能化

- 已经具备的自动化功能
    - 网络设备状态巡检（路由条目）
    - 设备配置管理
    - 变更管控中心


## 打造数据驱动的云网运维平台--释放SDN的价值

> 云杉网络，info@yunshan.net.cn

- 目标明确的时候，做一个自动化工具还是比较容易的, 关键在于找到自己的具体需求

- 熟悉的车祸现场
    - 云里的网络：物理网络、逻辑网络、网络资源、上层应用(汇聚--介入--vSwitch--Hypervisor)
    - 悄无声息的环路 
    - 网络资源
    - 新问题曾出不穷：全是UDP4789(OVBS)

- 数据驱动技术
    - 数据采集：虚拟交换机、多租户网络、全网全时
    - 数据分析：海量流量、数据高效存储
        - DPDK 高速数据包处理
        - strom 实时处理
    - 数据展现


## 如何构建基于SDN网络的自动化运维系统

> DAHO Networks 大河云连

- 网络技术演进
    1. 1974 TCP/IP协议发布会
    2. 1995 IEEE快速以太网标准
    3. 2009 SDN, 2012 Google B4全面启动

- 传统网络运维
DCN网络架构变迁
Google B4 骨干网利用率能达到90%

- SDN NetDevOps

- SDN 运维工作
    - 日常运维工作＋工程项目（编程等）
    - SRE Site Reliability Engineer (网站可靠性工程师)

- SDN运维工具
    - 监控报警（Zabbix, Nagios, Cacti, Smokeping)
    - 统计分析(ELK, Flume)
    - 运维自动化(Python, Java, Shell, Chef, puppet, Ansible, Jenkins)
    - 运维系统建设(CMDB, MySQL, Redis, infuxdb, Grafana, Nginx)

- 运维服务质量
    - SLI 服务质量指标、SLO 服务质量目标， SLA 服务质量协议
    - 监控报警设计
        - 告警通道：微信、钉钉、E-mail
    - 系统分析（控制器系统分析、网络系统分析）
