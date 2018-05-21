---
layout: post
title: SDN controller test 
category: 科研
tags: [SDN]
---

### 1. [基于OpenFlow南向协议的SDN控制器性能测试方法及定量分析][1]

- 针对OF1.3协议
- 主要测试点
    1. **控制通道容量**。控制器连接交换机的最大数目
    2. **拓扑发现时间**。测试不同规模、不同连接方式下完成网络拓扑发现所需要的时间
    3. **拓扑响应时间**。SDN controller针对图片不变化事件，如Port Down/Up等时间的侦测及响应时间，可以衡量SDN控制器对网络链路的控制能力。
    4. **被动流表下发速度**。即控制器根据既定策略下发流表的速度。可以衡量控制器对上层网络策略的执行能力。
    5. **被动Packet_out消息下发速率**。Packet_out在实际网路运营中关系到LLDP、ARP等协议的应用。

- 运行模式设计
    1. 单点运行模式。一个控制器节点示例运行与一个虚拟机之上
    2. 集群运行模式。每个虚拟机各运营一个控制器节点实例，三个分布式的，运营在不同虚拟机上的控制器实例组合成控制器集群。

- 测试建议
    1. 隔离建议。测试环境隔离
    2. 连接建议。被测试控制器与测试工具直接连接
    3. 迭代建议。每一测试用例迭代执行10次以上，分别记录最大值、最小值和平均值
    4. 复杂均衡验证建议。当控制器以集群模式运行时，建议分别记录各节点实例的CPU、内存使用率，一遍检测在压力之下，控制器集群是否可以进行负载分担。

- 具体测试
    1. **控制通道容量**：模拟了三种不同的网络拓扑，如Linear、Ring、Grid拓扑
    2. **拓扑发现时间**：控制器开启拓扑发现服务的时间，控制器发出第一个包含LLDP数据包的`Packet_out`消息的时间，控制器收到第一个`Packet_in`消息的时间，最后一个由模拟交换机发出的`Packet_in`消息时间，控制器完成拓扑发现时间
    3. **拓扑响应时间**：对应的时间包括Port up/down，Switch up/down， 手动触发关闭port或switch
    4. **被动流表下发速率**：控制器运行L2 Learning Switch应用，一定数量的`ARP_request`消息通过`Pacter_in`消息上送控制器，控制器下发`Packet_out`消息后，模拟交换机以一定速率通过`Pactet_in`消息上送对应的`ARP_Replay`；记录模拟交换机收到的第一个`Flow_mod`消息和最后一个的时间。
    5. **被动Packet_out消息下发速度**：运行L2 Learning Switch应用，模拟交换机以一定速率通过`Packet_in`消息上送一定数量M的`ARP_request`消息，记录模拟交换机收到第一个包含上送`ARP_request`的`Packet_out`及最后一个的时间

### 2. [基于OpenFlow的SDN控制器关键技术研究][2]
    
- SDN controller的**基础模块**：实现网络控制功能的必备模块，全网络信息状态的获取、流量的分析、数据转发路径的计算、流表的生成与下发等基本功能
    1. **数据分发模块**：解析底层网上传的OpenFlow数据包，若是控制信息，如Flow-removed, Port-status,Error等则发送给策略制定模块；若是设备信息，Features则发送给设备管理模块；若是数据信息，如Packet-in消息...
    2. **链路发现模块**：负责维护网络连接状态， LLDP
    3. **网络拓扑模块**：计算网络拓扑和路由转发路径
    4. **信息存储模块**：存储交换机信息、网络拓扑信息和转发路径信息
    5. **策略制定模块**：综合分析网络状态、控制信息以及应用个平面发来的请求信息，制定相关策略，知道流表的生成。
    6. **流表生成模块**:静态流表和动态流表
    7. **下发管理模块**：按照OF协议的格式封装后，下发给交换机
    8. **设备管理模块**：负责底层交换机的管理工作

- SDN controller的**应用模块**：防火墙、负载均衡、网络虚拟化、Web UI
    1. Learning Switch
    2. Forwarding 模块，基于交换机的`Packet-in`消息定制转发决策信息，支持基于数据流的端到端的路由

- 控制器总体架构
    ![控制器总体架构][3]
- 控制器基础模块之间的工作逻辑
    ![控制器基础模块之间的工作逻辑][4]
        
### 3. [南向接口测试方案][5]
- 链路发现
- 拓扑动态更新
- L2/L3/L4层策略的制定，表项下发
- 跨网段测试
- 故障倒换
- QoS测试 --> 限制带宽

### 4. Cbench 
- From [On Controller Performance in Software-Defined Networks][6]

- 介绍

    1. **Latency模式**：即响应延时测试下，Cbench发送一个packet in消息并等待控制器返回匹配的flow-mod消息，如此反复多次，统计每秒内发生的次数即每秒内收到的flow mod数量。--> 控制器响应的延迟时间 --> controller's request processing time under low-load conditions.
    2. **Throughtput模式**：即吞吐量模式下，即对于每个OpenFlow会话，在TCP缓存满之前Cbench一直发送packet in消息，计算返回的flow-mod数，统计每秒内控制器能够处理事务的数量。--> the maxmium flow setup rate that a controller can maintain.
    
- 不足
1. Cbench 无法创建定制的流量，只能以固定的速率发送数据包，建立一个可以定制流量的Cbench， 比如模拟真实的数据中心的流量进行测试。--> 制定一个全局拓扑和测试模式 && 各Cbench实例之间可相互通信 [Performance Evaluation of OpenDaylight SDN Controller][7]

### 5. [Benchmark Open Source SDN Controller][8](March 27, 2016)
- 针对RYU，ODL和ONOX控制器，使用的ONF和IETF BMWG提供的测试方法以及Ixia的IxNetwork SDN Fmulation来进行了压力测试。

### 6. [IETF adopts Veryx’s contribution for SDN controller benchmarking][9](Dec 09, 2015)

### 7. [Benchmarking Methodology for SDN Controller Performance][10]

- 将controller作为一个黑盒进行测试
- Test Considerations
1. network topology
2. test traffic：测试用例应该使用多帧的大小
3. test emulator: 打时间戳
4. connection setup:加密连接和非加密连接，协议版本的支持
5. Measurement Point Specification and Recommendation
6. Connectivity Recommendation: the test setup 应直接和转发控制平面连接
7. Test Repeatability: 推荐一分钟十次

- 测试报告应包含的内容

    - Test Configuration Parameters:
    1. 控制器名称和版本 Controller name and version
    2. 北向接口协议和版本 Northbound protocols and versions
    3. 南向接口协议和版本 Southbound protocols and versions
    4. 控制器冗余模式 Controller redundancy mode (Standalone or Cluster Mode)
    5. 连接设置 Connection setup (Unencrypted or Encrypted)
    6. 网络拓扑 Network Topology (Mesh or Tree or Linear)
    7. 网络设备类型 Network Device Type (Physical or Virtual or Emulated)
    8. 节点数 Number of Nodes
    9. 链路数 Number of Links
    10. 测试流量类型 Test Traffic Type
    11. 控制器所在系统配置 Controller System Configuration (e.g., CPU, Memory, Operating System, Interface Speed etc.,)
    12. Reference Test Setup (e.g., Section 3.1 etc.,)
    - Controller Settings Parameters：
1. Topology re-discovery timeout
2. Controller redundancy mode
    - To ensure the repeatability of test, the following capabilities of test emulator SHOULD be reported
    1. Maximum number of Network Devices that the forwarding plane emulates
    2. Control message processing time

- Benchmarking Tests
    - Network Topology Change Detection Time
    1. Network Topology Discovery Time
    2. Asynchronous Message Processing Time
    3. Asynchronous Message Processing Time
    4. Reactive Path Provisioning Time：在源目的节点之间被动启动一条路径
    5. Proactive Path Provisioning Time：在源目的节点间主动启动一条路径
    6. Reactive Path Provisioning Rate
    7. Proactive Path Provisioning Rate
    8. Network Topology Change Detection Time
    - Scalability
    1. Control Session Capacity
    2. Network Discovery Size
    3. Forwarding Table Capacity
    - Security
    1. Exception Handling
    2. Denial of Service Handling
            



  [1]: http://www.chinaunicom.com.cn/upload/1462953210757.pdf
  [2]: http://xueshu.baidu.com/s?wd=paperuri:%28a33e14d23139ec62f09381427fac3942%29&filter=sc_long_sign&tn=SE_xueshusource_2kduw22v&sc_vurl=http://cdmd.cnki.com.cn/Article/CDMD-10013-1015586341.htm&ie=utf-8&sc_us=9724025196873925999
  [3]: http://static.zybuluo.com/wuzhimang/d2hzpka63c45d766e4paruqt/image_1amavimfqgpf1ttisr4tsbvro1n.png
  [4]: http://static.zybuluo.com/wuzhimang/8h4qs35wu9ualcjaiw9m96i7/heelo.bmp
  [5]: http://www.sdnlab.com/6987.html
  [6]: https://www.usenix.org/system/files/conference/hot-ice12/hotice12-final33_0.pdfws/latest-news/ietf-adopts-veryxs-contribution-for-sdn-controller-benchmarking/
  [7]: http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=7097868
  [8]: https://www.ixiacom.com/company/blog/benchmarking-open-source-sdn-controllers-%E2%80%93-are-they-ready-carrier-grade-services
  [9]: http://www.veryxtech.com/news/latest-news/ietf-adopts-veryxs-contribution-for-sdn-controller-benchmarking/
  [10]: https://datatracker.ietf.org/doc/draft-ietf-bmwg-sdn-controller-benchmark-meth/
