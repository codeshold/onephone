---
title: 安全测试工具篇（开源&商业）
layout: post
author: WenfengShi
category: 技术
tags: [security, tools]
---

> 因项目的需要，自己对一些主流的安全测试工具做了详细的调研工作（包括开源和商业的）。本文是自己的**简要分享**，希望能帮助有需要的人，其中部分工具是本人使用过的。  
更新时间：**20160915**

> 由于系统安全测试工具和软件安全测试工具有很大的重合，一款优秀的安全软件基本能同时应用于系统安全测试和特定的应用软件测试，而一般的安全防御检测工具也可应用于测试中。故下文没有针对系统测试和软件测试进行分类详细的划分，同时在工具的罗列中也包含了安全防御检测类工具。


## 免费开源
1. Nmap
- 网络发现和安全审计
- 其基本功能包括：1. 探测主机是否在线；2. 扫描主机端口，嗅探所提供的网络服务（包括应用名称和版本信息）；3. 推断主机所用的操作系统及版本信息；4. 探测使用的防火墙/包过滤器的类型；5. 探测其他各类信息，且可定制扫描策略。
- 支持多种平台（Linux, Windows, and Mac OS XA）；支持命令行和图形化界面（GUI）；可灵活绑定其他工具，如Nping, Nidiff，Ncat等
- 网站：[https://nmap.org/][2]

2. OpenVAS
- 开放式漏洞评估
- 号称世界最先进的开源漏洞扫描和管理工具。OpenVAS包括一个中央服务器和一个图形化的前端。其核心部件是中央服务器，包括一套网络漏洞测试程序，可以检测远程系统和应用程序中的安全问题。
- Nessus项目的一个分支, 服务器仅限Linux，客户端可以使Windows和Linux
- 网站：[https://openvas.org/][3]

3. OSSEC 
- 主机入侵检测
- 主要功能有日志分析、完整性检查、rootkit检测、基于时间的警报和主动响应。除具有入侵检测系统功能外，还一般被用在SEM/SIM（安全事件管理/安全信息管理）解决方案中。因其强大的日志分析引擎，ISP、大学和数据中心用其监控和分析他们的防火墙、入侵检测系统、网页服务和验证等产生的日志。
- 支持多种平台（Linux, OpenBSD, FreeBSD, MacOS, Solaris， Windows）
- 网站：[https://ossec.github.io/][4]

5. Metasploit
- 渗透测试（安全漏洞检测）
- 号称世界使用最多的渗透测试软件，包括扫描和审计功能。Metasploit Framework (MSF) 是一个强大的开源平台，供开发，测试和使用恶意代码，其为渗透测试、shellcode 编写和漏洞研究提供了一个可靠平台。
- 支持Windows和Linux平台
- 网站：[https://www.metasploit.com/][6]

4. Security Onion
- 入侵检测、网络安全和日志管理
- 基于Ubuntu的，包含了入侵检测、网络安全监控、日志管理所需的Snort、Suricata、Bro、OSSEC、Sguil、Squert、ELSA、Xplico、NetworkMiner等众多工具。且易于安装和使用。
- 仅支持Linux（Ubuntu)
- 网站：[https://securityonion.net/][5]

7. Snort
- 入侵检测和防御
- 已发展成为一个多平台(Multi-Platform),实时(Real-Time)流量分析，网络IP数据包(Pocket)记录等特性的强大的网络入侵检测/防御系统。有三种工作模式：嗅探器、数据包记录器、网络入侵检测系统。
- 支持多平台（Linux，FreeBSD，Windows）
- 最新版本的发布时间：2015年7月
- 网站：[https://www.snort.org/][7]

8. Suricata
- 入侵检测和防御
- 集IDS, IPS和网络安全监控为一身的引擎
- 支持多种平台（Linux/Mac/FreeBSD/UNIX/Windows）
- 网站：[https://suricata-ids.org][8]

9. Scapy
- 强大的交互式数据包处理程序
- 能够伪造或者解码大量的网络协议数据包，能够发送、捕捉、匹配请求和回复包等等。它可以很容易地处理一些典型操作，比如端口扫描，tracerouting，探测，单元测试，攻击或网络发现（可替代hping，NMAP，arpspoof，ARP-SK，arping，tcpdump，tethereal，P0F等）
- python编写
- 网站：[http://www.secdev.org/projects/scapy/][10]

6. BackTrack
- 专业的计算机安全测试/检测的Linux操作系统
- BackTrack是一套信息安全审计专用的Linux发行版。集成了包括Metasploit，RFMON，Aircrack-NG等200多种安全检查工具；其支持众多的RFID工具和ARM平台。
- 最新版本的发布时间：2012年8月
- 网站：[http://www.backtrack-linux.org/][11]， [https://www.kali.org/][12]， [http://www.kali.org.cn/][13]

7. LMD Tool
- Linux恶意软件扫描
- 网站：[http://www.lmd.de/products/vcl/lmdtools/][14]

8. BFBTester
- BFBTester是一款对二进制程序进行安全检查，确定输入参数、环境变量等是否存在溢出问题的工具。
- 网站：[http://bfbtester.sourceforge.net/][15]

9. lynis
- 安全漏洞扫描工具
- 支持多平台（Linux、FreeBSD和Mac OS）
- 网站：[https://cisofy.com/][16]

10. Auditd
- Linux安全审计
- 功能包括：账户管理， 文件系统管理， 权限管理， 日志文件操作管理

6. Wireshark
- 网络封包分析，可应用于网络安全测试分析
- 网站：[https://www.wireshark.org/][17]

7. Tcpdump/WinDump
- 网络监测和数据收集嗅探，可应用于网络安全测试分析
- 网站：[http://www.tcpdump.org/][18]， [http://windump.polito.it/][19]

9. THC Amap
- 应用软件端口检测
- 用于检测软件是否在给定的端口监听。
- 网站：[https://www.thc.org/thc-amap/][20]

9. Cain and Abel
- 有密码破解、穷举、嗅探、地址解析协议/DNS污染等功能。
- 仅Windows平台
- 网站：[http://www.oxid.it/cain.html][21]

8. WVS
- 自动化的Web应用程序安全测试
- 可以扫描任何可通过Web浏览器访问的和遵循HTTP/HTTPS规则的Web站点和Web应用程序。适用于任何中小型和大型企业的内联网、外延网和面向客户、雇员、厂商和其它人员的Web网站。
- 网站：[http://www.acunetix.com/vulnerability-scanner/][22]

10. Acunetix
- 可用于测试网站和Web应用程序的跨站脚本攻击、SQL注入攻击及其他常见的Web漏洞攻击。
- 网站：[http://www.acunetix.com/][23]

11. Burp Suite
- 一个专门用于测试Web应用安全的完整工具包。它可以作为代理服务器、Web爬虫、入侵工具和转发工具，还可以自动发送请求。
- 网站：[https://portswigger.net/burp/][24]

6. Nikto
- Web服务器扫描
- 其可对网页服务器进行全面的多种扫描，包含超过6400 种有潜在危险的文件/CGIs；超过1200 种服务器版本；超过270种特定服务器问题, 且扫描项和插件可以**自动更新**。
- 可运行在任何有Perl环境的平台上, 但工具较老，最新版本发布时间是2011年2月
- 网站：[https://cirt.net/nikto2/][25]


## 商业产品
1. Nessus
- 系统漏洞扫描与分析工具
- 号称是世界上最流行的漏洞扫描程序，该工具提供完整的电脑漏洞扫描服务，并随时更新其漏洞数据库。Nessus不同于传统的漏洞扫描软件，Nessus可同时在本机或远端上遥控，进行系统的漏洞分析扫描。
- 支持多种平台，支持GUI，其包括Home（家庭版）和Professional（专业版），其中家庭版可免费使用，专业版每年费用为`$2,190.00`
- 网站：[http://www.tenable.com/products/nessus-vulnerability-scanner][26]

2. Core Impact
- 漏洞扫描工具
- 全球公认最强的安全漏洞检测工具，是评估网络系统、站点、邮件用户和Web应用安全的最全面软件解决方案。
- 仅支持Windows平台，支持GUI，费用至少为 `$30,000`
- 网站：[https://www.coresecurity.com/core-impact][27]

3. Nexpose 
- 漏洞扫描工具
- 支持Windows，Linux平台，支持GUI，有免费的社区版本（功能有限），商业版本单用户每年 `$2,000` 起步
- 网站：[https://www.rapid7.com/products/nexpose/][28]

5. AppScan
- Web 安全扫描器
- IBM公司的产品，商业扫描器中做的比较好的，约`48万人民币`
- 网站：[http://www-03.ibm.com/software/products/en/appscan][29]

6. HP Fortify
- 应用安全测试产品
- 既可以在企业内部部署，也可以按需使用支持成千上万种的应用漏洞扫描。惠普公司产品
- 网站：[HP Fortify 软件安全中心][30]

5. 天镜脆弱性扫描与管理系统
- 基于网络的脆弱性分析、评估和综合管理系统，启明星辰公司开发的，软硬件产品。
- 约`79万人民币`
- 网站：[http://www.venustech.com.cn/][31]

3. 绿盟远程安全评估系统
- 专业的NSFOCUS安全小组支持，软硬件产品。
- 约`89万人民币`
- 网站：[http://www.nsfocus.net/][32]

8. Babel Enterprise
- 一款企业级的安全监控平台，可以检查OS安全状态：用户名/密码、内核选项、文件权限、补丁、网络设置、SUID、二进制文件更改等。
- 网站：[http://www.babelenterprise.com/][9]

3. Veracode
- 应用程序漏洞扫描工具
- 网站：[http://www.veracode.com/][33]

4. GFI LanGuard
- 网络安全和漏洞扫描工具
- 网站：[http://www.gfi.com/products-and-solutions/network-security-solutions/gfi-languard][34]

10. Malwarebytes' Anti-Malware
- 恶意软件扫描器
- Windows平台
- 网站：[https://www.malwarebytes.com/antimalware/][35]

11. lynisi Enterprise
- 安全漏洞扫描
- 支持多平台（Linux、FreeBSD和Mac OA）
- 最低价格`￥1.5/system/month`
- 网站：[https://cisofy.com/][16]




  [2]: https://nmap.org/
  [3]: https://openvas.org/
  [4]: https://ossec.github.io/
  [5]: https://securityonion.net/
  [6]: https://www.metasploit.com/
  [7]: https://www.snort.org/
  [8]: https://suricata-ids.org
  [9]: http://www.babelenterprise.com/
  [10]: http://www.secdev.org/projects/scapy/
  [11]: http://www.backtrack-linux.org/
  [12]: https://www.kali.org/
  [13]: http://www.kali.org.cn/
  [14]: http://www.lmd.de/products/vcl/lmdtools/
  [15]: http://bfbtester.sourceforge.net/
  [16]: https://cisofy.com/
  [17]: https://www.wireshark.org/
  [18]: http://www.tcpdump.org/
  [19]: http://windump.polito.it/
  [20]: https://www.thc.org/thc-amap/
  [21]: http://www.oxid.it/cain.html
  [22]: http://www.acunetix.com/vulnerability-scanner/
  [23]: http://www.acunetix.com/
  [24]: https://portswigger.net/burp/
  [25]: https://cirt.net/nikto2/
  [26]: http://www.tenable.com/products/nessus-vulnerability-scanner
  [27]: https://www.coresecurity.com/core-impact
  [28]: https://www.rapid7.com/products/nexpose/
  [29]: http://www-03.ibm.com/software/products/en/appscan
  [30]: http://www8.hp.com/cn/zh/software-solutions/asset/software-asset-viewer.html?asset=1356048&module=1503693
  [31]: http://www.venustech.com.cn/SafeProductInfo/10/32.Html
  [32]: http://www.nsfocus.net/
  [33]: http://www.veracode.com/
  [34]: http://www.gfi.com/products-and-solutions/network-security-solutions/gfi-languard
  [35]: https://www.malwarebytes.com/antimalware/

