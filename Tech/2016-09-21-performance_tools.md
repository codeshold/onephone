---
title: 性能测试工具
layout: post
author: WenfengShi
category: 技术
tags: [tools, performance]
---

> 因项目的需要，自己对一些主流的性能测试工具做了详细的调研工作（包括开源和商业的）。本文是自己的**简要分享**，希望能帮助有需要的人，其中部分工具是本人使用过的。  
更新时间：**20160915**

> 介于项目并不是面向Web网站服务器的，所以关于web测试这块的工具可能罗列的不多（只涉及主要的了），毕竟仅web这块的工具就很多了！

## 一、系统性能测试工具
> 有关**Web服务器**性能测试工具的介绍放在了“软件性能测试章节”章节。

### 开源免费
1. Iometer
- I/O子系统性能测试
- 其在工业界被广泛使用
- 支持多种平台（Linux, Windows， Mac OS等）
- 网址：[http://www.iometer.org/][1]

2. Iozone
- I/O性能测试
- Iozone是一个文件系统benchmark工具，可测试不同的操作系统中文件系统的读写性能，且含有gnuplot画图脚本。
- 支持多种平台，适合用在大规模集群系统上测试NFS的性能
- 网站：[http://www.iozone.org/][2]

3. FIO
-  I/O性能测试
-  一个用于对磁盘IO进行基准或压力测试的工具，支持19种不同类型的IO引擎，在测试行为上，支持设置IO优先级，多线程测试等等特性。
-  网站：[http://freecode.com/projects/fio][3]

4. SPEC CPU
- CPU等性能测试
- SPEC CPU是SPEC（标准性能评测组织）开发的专门用于评价CPU性能的一套基准测试程序，主要应用于桌面型和服务器型CPU的性能评价。测试范围专注于系统的处理器、内存子系统和使用到的编译器。
- 网站：[https://www.spec.org/cpu2006/][4]

3. Netperf
- 网络性能测试
- 根据应用的不同，可以进行不同模式的网络性能测试，即批量数据传输（bulk data transfer）模式和请求/应答（request/reponse）模式。Netperf测试结果所反映的是一个系统能够以多快的速度向另外一个系统发送数据，以及另外一个系统能够以多块的速度接收数据。
- 网站：[http://www.netperf.org/][5]

> 其他的一些用于系统性能监控工具/命令：Perfmon(Windows 自带系统监测工具）， sysstat， vmstat， rstati，Mercury SiteScope等


### 商业产品
1. Sisoft Sandra
- Windows系统下的基准评测软件
- 含几十种以上的测试项目，能够查看系统所有配件的信息，而且能够对部分配件（如CPU、内存、硬盘等）进行打分(benchmark)，并且可以与其它型号硬件的得分进行对比。另外，该软件还有系统稳定性综合测试、性能调整向导等附加功能。
- Enterprise版费用最低为**$2195**,Lite版本免费
- 网站：[http://www.sisoftware.eu][6]

## 二、软件性能测试工具
> 软件性能测试中，有大部分是关于**WEB应用(服务器）**的测试

### 开源免费
1. Apache JMeter
- Java桌面应用压力测试工具
- 用于对软件做压力测试，它最初被设计用于Web应用测试但后来扩展到其他测试领域。 它可以用于测试静态和动态资源例如静态文件、Java 小服务程序、CGI 脚本、Java 对象、数据库， FTP 服务器, 等等。JMeter 可以用于对服务器、网络或对象模拟巨大的负载，来在不同压力类别下测试它们的强度和分析整体性能。 
- 网站：[http://jmeter.apache.org/][7]

2. Grinder
- Java负载测试框架
- 可通过多种负载注射器来为分布式测试提供了便利。支持用于执行测试脚本的Python脚本引擎HTTP测试可通过HTTP代理进行管理。
- 网站：[http://grinder.sourceforge.net/][8]

3. Tsung
- 多协议分布式负载测试
- 可用于HTTP, WebDAV, SOAP, PostgreSQL, MySQL, LDAP and Jabber/XMPP 等多类服务器性能测试
- 网站：[http://tsung.erlang-projects.org/][9]

4. Gatling
- web应用性能测试框架
- 一个基于Scala, Akks和Nettyde性能测试框架，能兼容所有的浏览器，支持HTTP，WebSockets, Server-sent svents, JMS
- 网站：[http://gatling.io][10]

6. perf
- 软件性能分析
- perf是一款强大工具，且有丰富的功能部件。Perf 不仅可以用于应用程序的性能统计分析，也可以应用于内核代码的性能统计和分析。应用程序可以利用 PMU，tracepoint 和内核中的特殊计数器来进行性能统计。
- 网站：[https://perf.wiki.kernel.org/index.php/Main_Page][11] 

6. curl-loader
- Web应用测试
- 可模拟成千上万的HTTP/HTTPS和FTP/FTPS客户端应用程序，且每个均拥有自己的源IP
- 网站：[http://curl-loader.sourceforge.net/][12]

4. TCPCopy
- TCP流回放工具
- 可支持各类网络服务器应用程序性能测试
- 网站：[https://github.com/wangbin579/tcpcopy][13]

4. OpenSTA
- web服务器benchmakr工具
- 功能强大，自定义功能设置完备，但设置通过Script来完成。
- windows平台
- 网站：[http://opensta.org/][14]

6. Siege
- http压力测试和benchmark工具
- 以根据配置对一个WEB站点进行多用户的并发访问，记录每个用户所有请求过程的相应时间，并在一定数量的并发访问下重复进行。 Siege 支持基本的认证，cookies， HTTP 和 HTTPS 协议。
- 网站：[http://www.joedog.org/siege-home/][15]

4. Web Polygraph
- Web性能测试
- 这个工具是很多公司的标准测试工具，包括微软在分析其软件性能的时候，也是使用这个工具做为基准工具的。很多招聘测试员的广告中都注明需要熟练掌握这个测试工具。有商业支持。
- 网站：[http://www.web-polygraph.org/][16]

6. ab
- Apache HTTP 服务器benchmark工具
- 网站：[http://httpd.apache.org/docs/2.4/programs/ab.html][17]

6. Httperf
- web服务器/应用性能测试工具
- 网站：[http://www.labs.hpe.com/research/linux/httperf/][18]

7. wrk
- HTTP基准测试工具
- 一款采用异步并发模型的HTTP基准测试工具： 不同于 ab、webbench，它采用异步并发模型，能够发送更大且可控的压力；内置 LuaJIT，能够通过 lua 脚本模拟常见的业务行为，模拟更加真实的场景；相比常见的HTTP基准测试工具，占用更少CPU、更少内存 支持 HTTP、 HTTPS，能够动态修改头、修改Body方法等；支持混合场景
- 网站：[http://github.com/wg/wrk][19]


### 商业产品
1. HP Loadrunner
- 预测系统行为和性能的工业标准级负载测试工具 
- 一种较高规模适应性的，自动负载测试工具，它能预测系统行为，优化性能。LoadRunner强调的是整个企业的系统，它通过模拟实际用户的操作行为和实行实时性能监测，来帮助更快的确认和查找问题。
- 支持系统：Microsoft Windows and Linux (Load Generator only)， 费用较贵，且按协议收费。有社区免费版本（Community Edition ）。
- 网站：[http://www8.hp.com/us/en/software-solutions/loadrunner-load-testing/][20]

2. WebLOAD
- web应用性能测试工具
- 可测试Ajax, Adobe Flex, .NET, Oracle Forms, HTML5等各类web应用。
- 支持Windows， Linux系统
- 网站：[http://radview.com/][21]

3. LoadUI / SmartBear TestComplete
- web应用性能测试工具
- SmartBear公司的产品，LoadUI Pro版本最低每年**$5,999**
- 网站：[https://smartbear.com/product/ready-api/loadui/overview/][22]

3. IBM Rational Performance Tester（简称 RPT）
- 应用程序性能测试引擎
- Rational Performance Tester 将易用性与深入分析功能相结合，从而简化了测试创建、负载生成和数据收集，以帮助确保应用程序具有支持数以千计并发用户并稳定运行的性能。
- 100个虚拟用户每小时`$60.00` 
- 网站：[http://www-03.ibm.com/software/products/en/rpts][23]

2. kylinPET
- 国产性能测试工具
- 一款功能强大的性能测试工具；界面友好、操作方便，资源占用率低；自带TCP/IP协议栈，支持虚拟大量IP；支持IPv4、IPv6的多种业务测试；支持WEB/WebService业务与Flex（HTTP）、IMS业务（SIP）、IPTV业务（RTSP/IGMP/MLD）、XMPP、Socket业务、数据库、JMS、FTP/SFTP、WEB视频（包括FLV/MP4/HTTP Live Streaming/HTTP Smooth Streaming/HTTP Dynamic Streaming）、WebSocket、JAVA；支持多种协议组合。
- 网站：[http://www.kylinpet.com/][24]

4. Silk Performer， QA Load
- 负载测试工具
- Borland 公司产品，Silk Performer是一种在工业领域最高级的企业级负载测试工具。可以模仿成千上万的用户在多协议和多计算的环境下工作。QAload是一款应用性能测试工具
- Silk Performer约`78000元人民币`
- 网站：[http://www.borland.com/][25]

5. NeoLoad
- Web应用（和移动应用）负载测试工具
- 有免费版本使用
- 网站：[http://www.neotys.com/][26]

5. Load Test (included with SOAtest)
- 性能测试工具
- 支持SOAtest测试，JUnits，和轻量级的socket-based组件
- 网站：[https://www.parasoft.com/][27]

6. Login VSI
- 基于windows虚拟桌面的性能测试软件
- 网站：[www.loginvsi.com][28]

7. Telerik Test Studio
- 基于windwos的web、桌面应用程序的性能测试软件
- 网站：[http://www.telerik.com/teststudio][29]


> 其他的一些性能测试工具有：Visual Studio Ultimate edition， Tosca Testsuite， BlazeMeter等


  [1]: http://www.iometer.org/
  [2]: http://www.iozone.org/
  [3]: http://freecode.com/projects/fio
  [4]: https://www.spec.org/cpu2006/
  [5]: http://www.netperf.org/
  [6]: http://www.sisoftware.eu
  [7]: http://jmeter.apache.org/
  [8]: http://grinder.sourceforge.net/
  [9]: http://tsung.erlang-projects.org/
  [10]: http://gatling.io
  [11]: https://perf.wiki.kernel.org/index.php/Main_Page
  [12]: http://curl-loader.sourceforge.net/
  [13]: https://github.com/wangbin579/tcpcopy
  [14]: http://opensta.org/
  [15]: http://www.joedog.org/siege-home/
  [16]: http://grinder.sourceforge.net/
  [17]: http://httpd.apache.org/docs/2.4/programs/ab.html
  [18]: http://www.labs.hpe.com/research/linux/httperf/
  [19]: http://github.com/wg/wrk
  [20]: http://www8.hp.com/us/en/software-solutions/loadrunner-load-testing/
  [21]: http://radview.com/
  [22]: https://smartbear.com/product/ready-api/loadui/overview/
  [23]: http://www-03.ibm.com/software/products/en/rpts
  [24]: http://www.kylinpet.com/
  [25]: http://www.borland.com/en-GB/Products/Software-Testing/Performance-Testing/Silk-Performer
  [26]: http://www.neotys.com/
  [27]: https://www.parasoft.com/
  [28]: http://www.loginvsi.com/
  [29]: http://www.telerik.com/teststudio

