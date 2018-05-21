---
title: 数据包解析笔记
layout: post
author: WenfengShi
category: 技术
tags: [security]
---

博客链接: [http://codeshold.me/2017/04/packet_analyse.html](http://codeshold.me/2017/04/packet_analyse.html)

> 360 ISC安全课程

## wireshark

1. IO Graphs, Flow Graph, Round Trip Time Graph(TCP StreamGraph里面还包含了Through Graph, Window Scaling Graph等图)
2. tcp.analysis
    - `tcp.analysis.lost_segment`可以排查丢失的包
    - `tcp.analysis.retransmission`显示包中的所有重传（多了，可能意味着应用性能缓慢或用户报文丢失）
    - `tcp.analysis.duplicate_ack`显示被确认过不止一次的报文（大量的ACK是高延时的迹象）
3. wireshark负责解析的文件以前是放在**EPan**文件夹下
4. 命令行
    - `editcap x.pcapng output.pcapng -i 4` 以4秒位间隔分割文件
    - `tshark -n -q -r x.pcapng -z "conv.tcp"` 查看数据包的TCP会话信息的命令
    - `tshark -r x.pcapng -Y "ip.addr==192.168.0.1" -w x2.pcapng` 筛选出指定的IP地址的数据包文件命令
    - `tshark -n -q -r x.pcap -z "smb.srt"`可以获取协议的响应时间的统计数据

## 协议

- ARP
    1. `arp -a` 可以查看本地的缓存列表
    2. ARP协议的解析使用了2中数据包
        - arp请求，广播(ff:ff:ff:ff:ff:ff)，Target IP是要请求的ip，Target MAC地址是00:00:00:00:00:00
        - arp响应，单播
    3. 免费arp报文，广播，其用于更新，Sender IP地址和Target IP地址都是本机地址，`Target MAC地址是00:00:00:00:00:00`

- IP, TCP/UDP
    1. 经过一个路由器时，TTL至少减1
    2. TTL 表示数据包的生命周期，可以经过的最大路由数
    3. TCP三次握手中，第一次、第二次会出现`SYN`标志位
    3. TCP四次挥手中，第三次会发出`FIN/ACK`的标志位数据包（FIN标志在第一次、第三次出现)
    4. 为什么以太网下wireshark帧的长度为1514（最大的）和54(最小的）？
        - 根据rfc894的说明，以`太网封装IP数据包`的最大长度是1500字节，也就是说以太网最大帧长应该是以太网首部加上1500，再加上7字节的前导同步码和1字节的帧开始定界符，具体就是：`7字节前导同步码 + 1字节帧开始定界符 + 6字节的目的MAC + 6字节的源MAC + 2字节的帧类型 + 1500 + 4字节的FCS`。
        - 按照上述，最大帧应该是1526字节，但是实际上我们抓包得到的最大帧是1514字节，为什么不是1526字节呢？
        原因是当数据帧到达网卡时，在物理层上网卡要先去掉前导同步码和帧开始定界符，然后对帧进行CRC检验，如果帧校验和出错，就丢弃此帧。如果校验和正确，就判断帧的目的硬件地址是否符合自己的接收条件（目的地址是自己的物理硬件地址、广播地址、可接收的多播硬件地址等），如果符合，就将帧交给“设备驱动程序”做进一步处理。这时我们抓包的软件才能抓到数据，因此，抓包软件抓到的是去掉前导同步码、帧开始分界符、FCS之外的数据，其最大值是`6 + 6 + 2 + 1500 = 1514`。
        - 以太网规定，以太网帧数据域部分`最小为46字节`，也就是以太网帧最小是 6 + 6 + 2 + 46 + 4 = 64。除去4个字节的FCS，因此，抓包时就是60字节。当数据字段的长度小于46字节时，MAC子层就会在数据字段的后面填充以满足数据帧长不小于64 字节。由于填充数据是由MAC子层负责，也就是设备驱动程序。不同的抓包程序和设备驱动程序所处的优先层次可能不同，抓包程序的优先级可能比设备驱动程序更高，也就是说，我们的抓包程序可能在设备驱动程序还没有填充不到64字节帧的时候，已经捕获了数据。因此不同的抓包工具抓到的数据帧的大小可能不同。
        - wireshark抓到的可能没有填充数据段，而sniffer抓到的就有填充数据段，wireshark不同的版本抓获的最小数据包的大小有60字节也有54字节的情况
    5. TCP序列号的计算
        - 需要收到的ack确认号等于`tcp.seq + ip.len - 40`
        - 下一个序列号等于当前的序列号＋TCP数据的字节数

- ICMP
    1. ping
        - ICMP 回送请求和回答报文
        - `echo request` type是8，code是0
        - response type 是0，code是0
    2. tracroute
        - ICMP 超时报文
        - `echo request` type是0， code是0
        - response type是11(Time-to-live exceed, 数据包不可达)， code是0
        - 响应，ICMP双包头信息
        - DHCP
            - 基本流程
                1. Discover(广播)
                2. Offer(单播)，但可能会有多个DHCP回复Offer
                3. Reques``t(广播), 客户端往往接受第一个, IP使用期限到一半时，会发送单播Request包，如果没收到ACK，则在3/4时，会广播Request包
                4. ACK (DHCP服务器-->用户), 检查是否有该申请的纪录
            - 当用户不再需要分配IP地址时，用户会发送release包（`ipconfig /release`), 重新请求IP(`ipconfig /renew`)
            - IP过期后则只需Request，ACK两步骤

- DNS(53)
    - 主机和本地域名服务器进行“递归”查询；本地域名服务器向其它服务器则进行“迭代”查询
    - 备份服务器，DNS服务器之间的区域传送（TCP，包括增量传送等多种方式）

- HTTPS(443)
    - TLS是SSL的升级版（传输层）
    - client hello; server hello; certificate; client key exchange ...... Application Data

- FTP(20, 21)
    - 21 控制流
    - 主动模式、被动模式登陆过程都是一样的
    - 用户可以请求以PASV（被动模式）模式进行请求，然后服务器回应IP和端口，然后用户再主动建立TCP连接，进行文件传输
    - 主动模式是服务器建立FTP数据传输链接(windows xp ftp 只有主动模式)

- Kerberos
    - 对称密码学、权威的第三方（KBC）、认证是双向的
    - [流程](http://blog.csdn.net/wulantian/article/details/42418231)
        1. Client `<-->` KDC (UDP), Client向KDC进行认证（采用了时间戳的加密）
        2. KDC 帮助认证 Client, Server， 然后给Client发送了给Clinet和Server的密钥

- NFS
    - Portmap, NFS, Portmap, MOUNT, NFS
    - Portmap没有回复（防火墙的问题）， MOUNT被阻隔（权限问题） 
    - NFS 只认UID，不认用户名（要保证客户端和用户名的UID是一致的）
    - 明文传输

- CIFS
    - Windows文件共享协议，有SMB， SMB2， SMB3 三种版本， 有三种文件权限

- E-Mail
    - 电子邮件传输过程：MUA(邮件用户代理), MTA ... MTA(邮件传输代理), MDA(邮件分发代理), MUA. (有时候MDA会集成在MTA里面)
    - SMTP(25): 发送和中转邮件，把邮件从发信人的邮件服务器发送到收信人的邮件服务器
        - User/Passwd都是用base64的编码进行传输
    - POP(110): 从邮件服务器收取邮件
        - POP3协议允许电子邮件客户端下载服务器上的邮件，但是在客户端的操作（如移动邮件、标记已读等），不会反馈到服务器上，比如通过客户端收取了邮箱中的3封邮件并移动到其他文件夹，邮箱服务器上的这些邮件是没有同时被移动的
    - IMAP: 
        - IMAP提供webmail 与电子邮件客户端之间的双向通信，客户端的操作都会反馈到服务器上，对邮件进行的操作，服务器上的邮件也会做相应的动作

- E-Mail解密
    - Base64解密器, FFV文件识别工具, WinHex十六进制替换, Beyond Compare, Python
    - python `import base64`, `base64.b64decode("amlhbmdSZA==")`
    - 常见文件的格式信息，查看文件头, 
    - `0D0A` CRLF 回撤换行

- 计算机启功流程
    - Windows XP
        - NBNS: TCP/IP NetBIOS(Netbios Name Server) 协议(局域网内部使用，IBM开发的), Windows下默认开启NetBIOS
    - Kali Linux
        - 少很多开启起动程序, ICMPv6

- 无线网络包初探
    - 802.11, Beacon frame, timestatmp, Beacon interval, capabilities information, supported rate ......
    - WEP: wired equivalent privacy 有线等效加密
    - WPA/WPA2 Wi-Fi Protected Access 
    - WEP使用一个静态的密钥来加密所有的通信。WPA不断的转换密钥。WPA采用有效的密钥分发机制，可以跨越不同厂商的无线网卡实现应用。另外WPA的另一个优势是，它使公共场所和学术环境安全地部署无线网络成为可能。而在此之前，这些场所一直不能使用WEP。WEP的缺陷在于其加密密钥为静态密钥而非动态密钥。这意味着，为了更新密钥，IT人员必须亲自访问每台机器，而这在学术环境和公共场所是不可能的。另一种办法是让密钥保持不变，而这会使用户容易受到攻击。由于互操作问题，学术环境和公共场所一直不能使用专有的安全机制。


## 排错、安全

- 因错误配置而导致的网络故障
    - 非聚合网络分流器（聚合网络分流器）有两个口in, out
- Protocol Hierarchy Statistics (Summary)
    - 分析网站
- TCP SYN 扫描
- 嗅探目标操作系统信息
    - 被动型的识别指纹
        - 根据IP头部信息， 如TTL（64/128), 不分片标示(Set), 最长段大小(1440/1460)
        - 根据TCP信息
        - p0f工具：`p0f -r xx.pcap`
    - 主动型识别指纹
        - nmap
- 钓鱼网站案例
    1. 用户向攻击者网站发起一个请求
    2. 服务器返回302，重定向
    3. 客户端重定向，发起GET 请求
    4. 服务器返回了含有混淆的js的页面（含有img图像的iframe)
    5. 客户端向服务器发起GET请求，下载后，则利用漏洞，则图片被之行了
- 木马程序
    - Snort特征
        - `alert tcp any any -> ...` 如何在IDS如何设置Snort警报, CyberEYE ART Session
    - wireshark 分析 IDS 警报
- 手机数据包分析
