---
title: DDoS攻击防御与云服务
layout: post
author: WenfengShi
category: 技术
tags: [security]
---
博客链接: [http://codeshold.me/2017/03/ddos_cloud.html](http://codeshold.me/2017/03/ddos_cloud.h)

> 360 ISC安全课程（http://www.ichunqiu.com/course/50301）自学知识点总结和补充  
> 关键词：BGP引流、BGP Anycat、黑洞路由、SYN FLOOD防御、SSDP攻击、CC攻击


## Part 1
> 宫一鸣 360网络安全研究院院长,ops-trust和nsp-sec唯一中国成员,300G流量DDoS攻击防御事件中唯一华人代表,多次在全球顶级安全会议做专题报告。

1. BGP引流
- AntiDDos网络设计：BGP引流+策略路由回注
清洗设备`旁路部署`在核心路由器Router1上，对到达防护对象的流量进行检测和清洗。由于是旁路部署，需要将到达防护对象的下行流量通过BGP引流方式实时牵引至清洗设备进行检测和清洗，清洗完成后，再将正常流量通过策略路由方式回注到原链路Router1，由Router1继续转发给Router2，最终将流量送到防护对象。 (BGP引流策略路由图)
    ![此处输入链接的描述][1]
2. Arbor
- ARBOR 为一嵌入式应用与网络解决方案的专业厂商,集研发生产于一体,并在深圳设有生产工厂。
- [Radware vs Arbor][2]
3. DDoS攻击主要分类
- 直接攻击
- 反射攻击
攻击者通过使用“攻击目标”的地址，向另一台设备发送数据包，来冒充目标。然后收到数据包的设备就会试图联系“攻击目标”，实现DDoS攻击。
4. [代理][3]
- 正向代理
给客户端代理，隐藏客户端，如翻墙工具
- 反向代理
给服务器作代理，隐藏服务器，如CDN技术
5. [SSDP攻击][4]
- SSDP(UDP 1900),简单服务发现协议（SSDP，Simple Service Discovery Protocol）是一种应用层协议，是构成通用即插即用(UPnP)技术的核心协议之一。
- 类似DNS、NTP、SNMP等协议的反射攻击
6. “最后一公里的防御”
- 在主机进行DDoS监测
7. [CC攻击][5]
- [CC][6]（Challenge Collapsar）攻击的是网页，且使用了代理，其请求都是正常的
8. [NetFlow][7]
- 不是“最后一公里”的防御
- Netflow提供网络流量的会话级视图，记录下每个TCP/IP事务的信息。借助实时的检测网络数据流信息，通过与历史记录模式匹配（判断是否正常）、或者与异常模式匹配（判断是否被攻击），让网络管理人员可以实时查看全网的状态，检测网络性能可能出现的瓶颈，并进行自动处理或告警显示，以保证网络高效、可靠地运转。Netflow由Cisco创造。
- 一个NetFlow流定义为在一个源IP地址和目的IP地址间传输的单向数据包流，且所有数据包具有共同的传输层源、目的端口号。
- 常见版本V5
- Arbor的peakflow作的很好
- Google用了SDN
9. [spamhaus][8]
- spamhaus，它是一个国际性非营利组织，其主要任务是跟踪国际互联网的垃圾邮件团伙，实时黑名单技术 ，协助执法机构辨别，追查全世界的垃圾邮件，并游说各国政府制订有效的反垃圾邮件法案。
10. BGP AnyCast
- 利用一个（多个）AS号码在不同的地区广播相同的一个ip段。 利用bgp的寻路原则，短的as path 会选成最优路径，从而优化了访问速度。 
- 其实bgp anycast(任播)是不同服务器用了相同的ip地址。
- BGP AnyCast多用于DNS的网络部署（阿里的DNS）
- Anycast技术可用于DDoS防范
11. ICMP端口不可达
12. layer defence 纵深防御
13. iACL: infrastructure ACL
14. [黑洞路由][9]
- 发生攻击时，在接入路由器上把流量drop到null端口
- 黑洞路由，便是将所有无关路由吸入其中，使它们有来无回的路由，一般是admin主动建立的路由条目。
- null0、介入层路由器、触发路由器（配置特殊的规则，接着其告诉所有的路由器），基于源（目的）地址进行block
- flowspack
15. honey pot 
16. `1.2.3.4`IP地址谁用了？

## Part 2
> 蒋文旭 360云事业部云防护技术组负责任，推出网站卫士，安域等云防护系统成功击破个大云防护系统多次监测追溯到阿里云等对外发出的DDoS攻击

1. DDoS分类
- 攻击者角度：网络层、资源消耗层、应用层、混合型、反射型、慢射型
- 防御角度：DNS层、IDC层、业务层（WEB、业务、数据），即前端防护区（DNS、IDC，基本就是放大的流量）、后端防护区
2. 攻击源
- PC端：代理监测游戏、阳光打码、挂机
- 移动端：刷流量
- 服务器：主机漏洞、web漏洞（乌云平台爆出来的基本都是）
4. web
- 变量混淆
- 二进制混淆
5. 拿一个在线编程网站做CC
1. [NTP放大][10]
2. 云防护（免费）、云堤
3. DDoS到最后就是流量的问题了，只能靠运营商玩了
4. 新的防御技术
- 大数据
- 云监控（监控攻击、流量、类型）
- 数据分析
5. DDoS
- 流量形攻击
- [syn flood 防御方式][11]
        - syn proxy(有两种方式)：转发；reset
        - syn cache：第二次不分配TCB，三次之后再分配，但要保存Sequence Number
        - syn cookie：完全不使用任何存储资源，它使用一种特殊的算法生成Sequence Number，这种算法考虑到了对方的IP、端口、己方IP、端口的固定信息，以及对方无法知道而己方比较固定的一些信息，如MSS、时间等，在收到对方的ACK报文后，重新计算一遍，看其是否与对方回应报文中的（Sequence Number-1）相同，从而决定是否分配TCB资源。
        - 后两者需要修改内核协议栈
- “死扛”、流量调度、靠运营商
6. CC
- 攻击频率比DDoS高的多
- 防御措施：
        - 基本上所有的防火墙都会检测并发的TCP/IP连接数目，超过一定数目一定频率就会被认为是Connection-Flood。
        - cookie反弹
        - js防护（读取浏览器窗口大小）
        - 图片验证（opencv识别度很高，后来发展到要拖动图片）
        - 机器识别：死亡防护（开js反弹等）;url防护;扫描器防护
        - 智能识别：增减识别、机器学习（目录访问频次）
- 演变
        - HTTP FLOOD
        - 垃圾包
        2048的url被劫持、发送`\r\n`，消耗链接，消耗解析资源
        - 资源消耗：数据库资源、慢速包攻击（慢发包、慢收包）
        - 绕过云防护（通过邮件的漏洞、全局扫描）
        - 大文件攻击（小米官网的大图片）
        - 拿别人的现成的东西来作为攻击方式（第三方 [http://www.17ce.com/ ](http://www.17ce.com/)好的工具）
        - CDN
        - 代理模式的http 1.1（把1.0的协议打开）, github, 小说网
        - 301 - 目标永久性转移; 302 - 目标暂时性转移
- 趋势
        - 移动API防护
        - CC防护和业务相结合
        - 云和端防护（机器学习类的计算在端肯定不行）
        - 机器学习
        - CC溯源
        - 云主机
        - IIS 6（和xp很像，基本没有抗攻击能力）
                
    
  [1]: http://support.huawei.com/huaweiconnect/enterprise/data/attachment/forum/dm/ecommunity/uploads/2013/1226/15/52bbe0bbc8c11.png
  [2]: https://mailman.nanog.org/pipermail/nanog/2013-September/061297.html
  [3]: https://hacpai.com/article/1381403388981
  [4]: http://security.pconline.com.cn/668/6686289_1.html
  [5]: http://baike.baidu.com/item/cc%E6%94%BB%E5%87%BB?fr=aladdin#3
  [6]: http://www.jifang360.com/news/2010727/n27358461.html
  [7]: http://baike.baidu.com/link?url=DiURS8x1lhGIZ0lOhOcAAPf6HK6SgdhXJRCQ6X94b0vAXBxzPa5Dakt2SJ8Dlq8K2OCLGdUv4fJfVw1PmcB7Oq
  [8]: http://baike.baidu.com/link?url=u7KVgMoHZJNphH14BX4hZCijzMVqZv124XeSYyiG38tDWsFR9PiMCbp0fHrElNz2FSkaiURLe48C9FsZw_a6ep0z_kExmyIHZJ4KmCAQcNW
  [9]: http://baike.baidu.com/link?url=7uizuat-65zxUrIdYs3vhnz5Bw0Ra22_eUcM5zXMlaxDfshmnsu5Fk9nEhZ-c3DppiMY2qUM3cEulX9bvBrXVy6W_YMt--olTCqP2ma_L4xHtsAPnS03IqOeuz-Dm1aN
  [10]: http://www.2cto.com/article/201402/278775.html
  [11]: http://www.jb51.net/hack/390485.htmltml)

