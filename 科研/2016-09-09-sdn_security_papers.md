---
layout: post
title: SDN security papers 
category: 科研
tags: [SDN]
---

1. [软件定义网络:安全模型、机制及研究进展][1]
- Software Defined Networking:Security Model, Threats and Mechanism
- `王蒙蒙,刘建伟,陈杰,毛剑,毛可飞.软件定义网络:安全模型、机制及研究进展.软件学报,2016,27(4):969-992`

2. [FLOWGUARD: building robust firewalls for software-defined networks][2]
- `Hongxin Hu, Wonkyu Han, Gail-Joon Ahn, and Ziming Zhao. 2014. FLOWGUARD: building robust firewalls for software-defined neworks. In Proceedings of the third workshop on Hot topics in software defined networking (HotSDN '14). ACM, New York, NY, USA, 97-102. DOI=http://dx.doi.org/10.1145/2620728.2620749`

3. [Fleet: defending SDNs from malicious administrators][3]

4. [A slick control plane for network middleboxes][4]

5. [NetFuse: Short-circuiting Traffic Surges in the Cloud][5]
- `Y. Wang, Y. Zhang, V. Singh, C. Lumezanu and G. Jiang, "NetFuse: Short-circuiting traffic surges in the cloud," 2013 IEEE International Conference on Communications (ICC), Budapest, 2013, pp. 3514-3518.`
- 借助OpenFlow control消息来探测活动流，使用多维度的流量聚合来定位问题(toxin-antitoxin-like mechanism)，

6. [Lightweight DDoS flooding attack detection using NOX/OpenFlow][6]
- `Braga R, Mota E, Passito A. Lightweight DDoS flooding attack detection using NOX/OpenFlow. In: Proc. of the 35th IEEE Conf. on Local Computer Networks (LCN). Denver, 2010. 408?415. [doi: 10.1109/LCN.2010.5735752]`
- Keys: DoS, DDoS, Artificial Neural Networks
- 利用自组织映射算法（SOM,self organizing maps，应用于神经网络中一种分类算法）flow进行分类，通过选定的6-tuples（Average of Packets per flow， Average of Bytes per flow， Average of Duration per flow， Percentage of Pair-flows，  Growth of Single-flows，Growth of Different Ports）来对flow进行分类，以此来判定DoS/DDoS供给（通过训练集来进行训练，TCP、UDP、ICMP flooding），消耗低，检测率高；关键在于statistics time interval的确定；**问题**：检测具有一定的滞后性
- 辅助阅读论文《基于自组织映射网络的流量分类算法》

7. [Poisoning network visibility in software-defined networks: New attacks and countermeasures][7]
- `Hong S, Xu L, Wang H, Gu G. Poisoning network visibility in software-defined networks: New attacks and countermeasures. In: Proc. of the 2015 Annual Network and Distributed System Security Symp. (NDSS 2015). San Diego: Internet Society, 2015. 1?15.`
- TopoGuard --> 解决 topological poisoning attack，就control提供的 Host Tracking Service && Link Discovery Service 进行了特定的分析，针对**Host Location Hijacking && Link Fabrication Attack**提出了解决方案-- Authenticate Host Entity, Verify the Legitimcay of Host Migration（迁移前发送port_down，迁移之后control还要确认之前的location unreachlabe，即cause-and-effect）&& Authenticate for LLDP packets, Verify for Switch Port Property(如检测host-generated traffic，设置端口类型为Device Type,只允许LLDP在交换机链路和switch-to-control之间）;**不足**：
    
8. [AVANT-GUARD: Scalable and vigilant switch flow management in software-defined networks.][8]
- `Shin S, Yegneswaran V, Porras P, Gu G. AVANT-GUARD: Scalable and vigilant switch flow management in software-defined networks. In: Proc. of the 2013 ACM SIGSAC Conf. on Computer & Communications Security. Berlin: ACM, 2013. 413?424. [doi: 10.1145/2508859.2516684]`
- connection migration && actuating trigger  
- 解决data-to-control saturation attack，针对的主要是DoS/DDoS，提出了connection migration和acuating triggers方式，只将有效的TCP连接信息或者请求发送给control（TCP连接建立的几个图，connection migration有四个阶段，classification, report, migration, relay，共两次与control通信，分别进行migration、relay action）；actuating trigger（defining a control, condition registeration (traffic rate monitering, event nofication) conditional flow rule activation）其实就是预先设置一个触发条件，并把相应的action/流表存到switch中，等待被触发 --> 主要的问题在于只适合TCP
        
9. [OpenFlow: A security analysis][9]
- `Kloti R, Kotronis V, Smith P. OpenFlow: A security analysis. In: Proc. of the 21st IEEE Int’l Conf. on Network Protocols (ICNP). Goettingen, 2013. 1?6. [doi: 10.1109/ICNP.2013.6733671]`
- 结合STRIDE威胁检测模型和攻击树技术，设计了一种可针对OpenFlow安全性进行有效分析的威胁检测模型

10. [OF-GUARD: A DoS attack prevention extension in software-defined networks][10]
- `Wang H, Xu L, Gu G. OF-GUARD: A DoS attack prevention extension in software-defined networks. In: Proc. of the Poster Session of the Open Networking Summit 2014. Santa Clara: USENIX, 2014. 1?2.`

11. [Rosemary: A robust, secure, and highperformance network operating system][11]
- `Shin S, Song Y, Lee T, Lee S, Chung J, Porras P, Yegneswaran V, Noh J, Kang BB. Rosemary: A robust, secure, and highperformance network operating system. In: Proc. of the 2014 ACM SIGSAC Conf. on Computer and Communications Security.
Scottsdale: ACM, 2014. 78?89. [doi: 10.1145/2660267.2660353]`
- 解决control健壮性(robustness & resilience)，安全性的缺陷，设计实现了Rosemary控制器，控制器主要由data abstraction layer, rosemary kernel (resource manager, security manager, systemlog manager, 内核程序区), system libries, resource monitor构成。其将所有应用程序运行在一个封闭的应用程序内，实时监控各个应用程序的行为（防止某一应用程序影响SDN Stack或造成crash），应用程序的合法性通过签名来判定,micro-NOS --> 实现了control 的Robutness && Resilience。**可改进**：基于角色的签名机制，应用程序是作为一个整体的，不能更好的对应用程序各个模块的访问权限进行细粒度的控制;一个应用可能有不同的用户使用，这是否应考虑进去？
- From linux: ulimits, pipeline, cpu core bounding
- http://nss.kaist.ac.kr/ 

12. [Participatory networking: An API for application control of SDNs][12]
- `Ferguson AD, Guha A, Liang C, Fonseca R, Krishnamurthi S. Participatory networking: An API for application control of SDNs. In: Proc. of the ACM SIGCOMM 2013 Conf. on SIGCOMM. Hong Kong: ACM, 2013. 327?338. [doi: 10.1145/2486001.2486003]`
- PANE --> share tree, policy tree, HFT()Complication，设计了一个内嵌安全机制的PANE控制器，解决了网络控制及可见性的安全分解和不可信任用户间访问请求的冲突问题。允许权限的下级授权，同时通过其提供的API，终端用户可以动态自主的请求网络资源，允许管理员根据网络资源制定相应的访问控制策略。主要挑战--如何安全的分解网络的控制及可见性；如何解决实体请求之间的冲突。系统主要构造含，ShareTree, Policy Tree, HFT(Hierarchical Flow Tables) Compilation等，且其提供了未来资源请求功能（灵活的调度）

13. [FlowChecker: Configuration Analysis and Verification of Federated OpenFlow Infrastructures][13]
- `Al-Shaer E, Al-Haj S. FlowChecker: Configuration analysis and verification of federated openflow infrastructures. In: Proc. of the 3rd ACM Workshop on Assurable and Usable Security Configuration. Chicago: ACM, 2010. 37?44. [doi: 10.1145/1866898. 1866905]`
- 通过二元决策图技术(binary decision diagramsB)对OpenFlow流表的配置信息进行重新编码,并结合模型检测(model checking)技术,提出FlowChecker 检测系统,通过形式化的方法对不同交换机和控制器之间的流规则一致性进行检验.通过与 FlowVisor网络切片技术相结合,FlowChecker还可以对新协议的正确性、可达性和安全性等问题进行验证. 其使用CTL(Computational Tree Logic)语言；**可改进**：offline方式，即是事后检测

14. [Consistent updates for software-defined networks: Change you can believe in][14]
- `Reitblatt M, Foster N, Rexford J, Walker D. Consistent updates for software-defined networks: Change you can believe in. In: Proc. of the 10th ACM Workshop on Hot Topics in Networks. Cambridge: ACM, 2011. 1?6. [doi: 10.1145/2070562.2070569]`
- 解决transient 状态的不一致性（即流规则更新过程中的一致性和正确性），将问题分解为Per-packer Consistency && Per-flow Conststency，前者通过给每个包添加一个Versioning字段来确保每个只会被同一个configuration处理，后者通过给内部交换机先更新，ingress switch 后更新并设置timeouts来实现。问题：每个流的一致性主要是针对TCP的，但是UDP数据包的一致性呢？规则timeout的设定是一个关键的问题，怎么处理呢？作者假设的是是单个ingress，多个呢？ 

15. [OpenFlow: A security analysis][15]
- `Kloti R, Kotronis V, Smith P. OpenFlow: A security analysis. In: Proc. of the 21st IEEE Int’l Conf. on Network Protocols (ICNP). Goettingen, 2013. 1?6. [doi: 10.1109/ICNP.2013.6733671]`

16. [VeriFlow: Verifying network-wide invariants in real time.][16]
- `Khurshid A, Zhou W, Caesar M, Godfrey PB. VeriFlow: Verifying network-wide invariants in real time. In: Proc. of the 1st Workshop on Hot Topics in Software Defined Networks. New York, 2012. 49?54. [doi: 10.1145/2342441.2342452]`
- 实时检测全网范围内的不变性（invariants），采用了多维前缀树(a multidimensional prefix tree, trie)数据结构，先将网络进行等价类划分（EC）并找出与新规则有关的EC，接着通过遍历trie转发图（EC, device），最后通过（invariant, modified EC）来进行验证。特点是：realtime，可检测transient && longterm anomalies。问题：不支持修改包头的action,即处理报的转换。

17. [Improving Network Management with Software Defined Networking][17]
- `Kim H, Feamster N (2013) Improving network management with software defined networking. IEEE Communications Magazine 51(2):114-119` - 解决network configuration and management，提出了一个基于SDN的an event-driven network control framework -- **Procera**, 解决了网络状态频繁变动的响应、high-level policy language（**基于functional reactive programming（FRP）**）、定位性能瓶颈等问题。其突出点在于高层的策略语言，即相当于提供了一个north-bound interface，Procear的主要部件包括一个Policy engine，作者就Georgia campus校园内的上网认证做了一个分析(两个VLAN,认证后scanning，之后才正常访问)，详细的设计得参考另一篇论文。

18. [Model checking invariant security properties in OpenFlow][23]
- `Son S, Seungwon S, Yegneswaran V, Porras P, Guofei G. Model checking invariant security properties in OpenFlow. In: Proc. of the 2013 IEEE Int’l Conf. on Communications (ICC). Budapest: IEEE, 2013. 1974?1979. [doi: 10.1109/ICC.2013.6654813]`
- FLOVER --> **主要内容**:解决动态插入的流规则不会违反潜在的安全策略;将实际问题抽象成了一个 non-bypass protery问题，将规则翻译成assertion set，借助第三方工具来进行检测（Yices SMT solver, 可满足性检测,Statisfiablity MOdulo Theories）,分为 coverage violation和modify violation，通过形式化的语言进行验证;实验阶段，进行了in-line模式的测试和batch处理模式的测试 --> 提高性能(阈值的确定)；**可改进点**：通过一个Yices SMT solver来检测non-bypass property violations;是否有更好的工具，是否直接能在controll内核进行验证

19. [SDN Security: A Survey][19]
- `S. Scott-Hayward, G. O'Callaghan and S. Sezer, "Sdn Security: A Survey," Future Networks and Services (SDN4FNS), 2013 IEEE SDN for, Trento, 2013, pp. 1-7. [doi: 10.1109/SDN4FNS.2013.6702553]`

20. [Towards a Secure Controller Platform for OpenFlow Applications][20]

21. [Enforcing Network-Wide Policies in the Presence of Dynamic Middlebox Actions using FlowTags][21] 

22. [A Security Enforcement Kernel for OpenFlow Networks][22]
- `Porras P, Shin S, Yegneswaran V, Fong M, Tyson M, Gu G. A security enforcement kernel for OpenFlow networks. In: Proc. of the 1st Workshop on Hot topics in Software Defined Networks. Helsinki: ACM, 2012. 121?126. [doi: 10.1145/2342441.2342466]`
- FortNOX --> **主要内容**：基于角色的授权和安全限制下发（role-based authorization && security constraint enforcement）；算法-->alias-set rule reduction algorithm；在NOX上实现的，解决动态流隧道问题--dynamic-flow tunneling。**可改进点**：算法的有效性是否可以提升？针对每一个rule都进行检测？是否可以定期的批量进行规则冲突的检测？

23. [Modle Checking Invariant Security Properties in OpenFlow][23]

24. [FRESCO: Modular Composable Security Services for Software-Defined Networks][24]
- `Shin S, Porras P, Yegneswaran V, Fong M, Gu G, Tyson M. FRESCO: Modular composable security services for software-defined networks. In: Proc. of the ISOC Network and Distributed System Security Symp. (NDSS). San Diego: Internet Society, 2013. 1?16.`
- FRESCO -->  **主要内容**:安全应用软件的可模块化开发；FRESCO Security Enforcement Kernel (SEK) --> 解决Rule confilt detection；使用的是FortNOX算法 --> alias set rule reduction

25. [Securing the Software-Defined Network Control Layer][25]
- `Porras P, Cheung S, Fong M, Skinner K, Yegneswaran V. Securing the software-defined network control layer. In: Proc. of the 2015 Annual Network and Distributed System Security Symp. (NDSS 2015). San Diego: Internet Society, 2015. 1?15.`
- SE-Floodlight --> **主要内容**:authorization service, role-based autorization, rule冲突协商，安全审计服务；进步--主要扩展SEK的，更详细的安全机制，有安全审计服务

26. [A NICE way to test openflow applications][26]
- `Canini M, Venzano D, Pere P, Ni, Kosti D, Rexford J. A NICE way to test openflow applications. In: Proc. of the 9th USENIX Conf. on Networked Systems Design and Implementation. San Jose: USENIX Association, 2012. 1?14.`
- 使用该模型对真是的Python应用程序进行漏洞测试和验证，**可改进**：SDN的部署和应用处于初级阶段，并不适用

27. [CloundWatcher: Network Security Monitoring Using OpenFlow in Dynamic Clound Network][27]
- **主要内容**：利用Openflow协议，控制路由路径，使得网络流量经过特定的安全节点；针对网络安全设备（被动的和in-line模式的），分析并比较了四种算法。**可改进点**：算法分析时，主要是针对单个security devices的，针对多个安全设备，尤其是in-line的安全设备，对算法的效率并没有充分考虑，尤其是在云服务下;对于多个in-line安全设备， 那就是有约束条件的最短路径问题 --> 这个方向是否有研究的前景？<--这种算法在SDN中应该还有其他的应用场景
    
28. [Flowvisor: A network virtualization layer][28]
- `R. Sherwood, G. Gibb, K. Yap, G. Appenzeller, M. Casado, N. McKeown, and G. Parulkar, “Flowvisor: A network virtualization layer,” OpenFlow Switch Consortium, Tech.Rep, 2009.`
- **主要内容**：借鉴VLAN，在物理网络上搭建完全相互隔离的虚拟网络 --> testbed <-- slice the network hardware；网络资源的切分-->Topology, Bandwidth, Device CPU, Forwarding Tables --> 资源的切分。 **可改进**：CPU的切分，都是粗力度的，简单的是对OpenFlow message rate的，这个可以进一步可改进；forwarding "slow path" packets --> 从多个端口发出 --> 应用场景，如安全设备

29. [Towards SDN-Defined Programmable BYOD (Bring Your Own Device) Security][29]
- `Sungmin Hong, Robert Baykov, Lei Xu, Srinath Nadimpalli, Guofei Gu. "Towards SDN-Defined Programmable BYOD (Bring Your Own Device) Security." To appear in Proc. of the Network and Distributed System Security Symposium (NDSS'16), San Diego, California, Feb. 2016. (Acceptance ratio 15.4%=60/389)`
- 提出一个新的安全解决方案（企业网络）——PBS（Programmable BYOD Security）, 针对移动APP和设备的网络管理、策略实施，提供了一个细粒度、应用级别的网络安全。<--受SDN的启发，将移动设备元素（apps，network interface）抽象化，加入到传统的SDN网络中，提供一个全网络，内容敏感，app-specific 的策略实施（无需改变SDN交换机的部署）

30. [SANE: A Protection Architecture for Enterprise Networks][30]
- `M. Casado, T. Garfinkel, A. Akella, M. J. Freedman, D. Boneh, N. McKeown, and S. Shenker. SANE: A Protection Architecture for Enterprise Networks. In Proceedings of the 15th USENIX Security Symposium (SS), volume 15, 2006.`

31. [Ethane: Taking Control of the Enterprise][31]
- `M. Casado, M. J. Freedman, J. Pettit, J. Luo, N. McKeown, and S. Shenker. Ethane: Taking Control of the Enterprise. ACM SIGCOMM Computer Communication Review (CCR), 37(4):1–12, 2007.`

32. [Openflow Random Host Mutation: Transparent Moving Target Defense Using Software Defined Networking][32]
- `J. H. Jafarian, E. Al-Shaer, and Q. Duan. Openflow Random Host Mutation: Transparent Moving Target Defense Using Software Defined Networking. In Proceedings of the First Workshop on Hot Topics in Software Defined Networks, pages 127–132. ACM, 2012.`

33. [Resonance:Dynamic Access Control for Enterprise Networks][33]
- Resonance的访问控制策略基于flow-level information 和 real-time alerts。其通过SDN来提高了企业网络的安全（传统的网路是的reactive的，且严重依赖主机安全和middleboxs）,在Georgia Tech's network进行了实验。借助二元组（security group, status）对主机进行了细粒度的控制访问，通过和其他的系统结可提供有力的攻击防御功能。同SANE不同，其可以支持连续监控和基于接口政策的控制。



34. [Compling Path Queries][34]
- 借助确定性有限状态机（DFA），针对基于路径的流量监测引入了一个申明式查询语言。方便网络操作员进行实时的问题诊断，安全策略下发，容量规划(capacity planning)

35. [A Clean Slate 4D Approach to Network Control and Management][35]

36. [The Road to SDN][36]

37. [A First Step Toward Network Security Virtualization:From Concept To Prototype][37]

38. [OperationCheckpoint: SDN Application Control][38]
- SE-Floodlight

39. [A Survey of Securing Netwokrs using Software Defined Networking][39]
- 综述

40. [Routing Bottlenecks in the Internet: Causes, Exploits, and Countermeasures][40] 

41. [SPIFFY: Inducing Cost-Detectability Tradeoffs for Persistent Link-Flooding Attacks][41]
- 提出了针对使用traffic patterns攻击的对抗方法--SPIFFY。通过临时提高核心链路的带宽，来增加攻击者的成本，或者使攻击流量容易识别(通过rate change test)，而带宽的提升是通过SDN流量工程技术实现虚拟带宽的提升；**问题**：作者提出的假设之一是通过增加攻击者的成本可以很好的进行防范，但实际上的很多的DDos攻击是恶意、有针对性的，很在乎成本?

42. [Bohatei: Flexible and Elastic DDoS Defense][42]
- 借助SDN、NFV实现了一个灵活的，可伸缩的DDoS防御-->Bohatei，提供了可扩展性，反应灵敏性，可恢复性。防御措施可配置，更加灵活。**问题**：其提供的是一个静态规模的防御，针对的是传统DoS攻击，而且并不能解决link-flooding attacks。

43. [FlowTags: Enforcing Network-Wide Policies in the Presence of Dynamic Middlebox Actions][43]
- `S. Fayazbakhsh, V. Sekar, M. Yu, and J. Mogul, “FlowTags: Enforcing Network-Wide Policies in the Presence of Dynamic Middlebox Actions,” in Proceedings of the second workshop on Hot topics in software defined networks. ACM, 2013.`
- 解决的问题：不违背SDN的基本原则（ORIGINBINDING, PATHFOLLOWPOLICY）下，如何将Middleboxes整合到SDN网络中。提出了一个FlowTags架构，通过对middleboxes进行最少的修改，通过提供的API和control交互。--> 通过在数据包头添加Flag，service-chaining, perfomance debugging and forensics**可改进**：只能处理提前定义好的策略，不能处理动态的actions操作。

44. [SPHINX: Detecting Security Attacks in Software-Defined Networks][44]
- 使用flow graphs来模拟实际网络操作，进而检测网络攻击。**可改进**：多个控制器间flow graphs的一致性；SDN网络内部发起的attack是否能进行检测；检测不了入口交换机和出口交换机；数据中心虚拟机的迁移会比较频繁，这样会导致flow graph变化较快。

45. [ECOS: leveraging software-defined networks to support mobile application offloading][45]

46. [FLOWGUARD: Building Robust Firewalls for Software-Defined Networks][46]
- SDN网络防火墙的建立，通过flow tables和fire wall policles,来共同实现健壮的firewalls，firewall Authorization Space 和Flow Path Space整合。

47. [PGA: Using Graphs to Express and Automatically Reconcile Network Policies][47]
- PGA(Policy Graph Abstraction)-->解决和检测策略冲突

48. [Enabling Practical Software-defined Networking Security Applications with OFX][48]
- OFX --> 利用交换机本身的处理能力，动态将模块加载到交换机上，提高性能以及部署的难易。**可改进**：测试未针对新加载的模块功能是否会对硬件之前的正常功能产生影响。       



[1]: http://www.jos.org.cn/ch/reader/view_abstract.aspx?flag=1&file_no=5020&journal_id=jos
[2]: http://dl.acm.org/citation.cfm?id=2620749&CFID=769755616&CFTOKEN=51419368
[3]: http://dl.acm.org/citation.cfm?id=2620750&CFID=769755616&CFTOKEN=51419368
[4]: http://db.cs.duke.edu/courses/compsci514/spring14/Papers/slick-ons13.pdf
[5]: http://www.nec-labs.com/~lume/files/icc13.pdf
[6]: http://ieeexplore.ieee.org/xpls/abs_all.jsp?arnumber=5735752
[7]: http://faculty.cs.tamu.edu/guofei/pubs_byArea.htm#sdn
[8]: http://faculty.cs.tamu.edu/guofei/pubs_byArea.htm#sdn
[9]: http://ieeexplore.ieee.org/document/6733671/?arnumber=6733671
[10]: http://faculty.cs.tamu.edu/guofei/pubs_byArea.htm#sdn
[11]: http://www.csl.sri.com/users/vinod/papers/rosemary.pdf
[12]: http://pane.cs.brown.edu/
[13]: http://www.arc.uncc.edu/pubs/saeed_safeconfig10.pdf
[14]: http://www.cs.cornell.edu/~reitblatt/papers/hotnets11.pdf
[15]: http://ieeexplore.ieee.org/xpl/articleDetails.jsp?arnumber=6733671
[16]: http://www.cs.princeton.edu/~xuanz/veriflow-nsdi-2013.pdf
[17]: https://users.ece.cmu.edu/~vsekar/Teaching/Fall14/18859K/papers/procera.pdf
[19]: http://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=6702553&isnumber=6693160
[20]: http://conferences.sigcomm.org/sigcomm/2013/papers/hotsdn/p171.pdf
[21]: https://www.usenix.org/system/files/conference/nsdi14/nsdi14-paper-fayazbakhsh.pdf
[22]: http://www.openflowsec.org/FortNOX_Sigcomm_HotSDN_2012.pdf?origin=publication_detail
[23]: http://faculty.cs.tamu.edu/guofei/
[24]: http://faculty.cs.tamu.edu/guofei/
[25]: http://www.csl.sri.com/users/porras/SE-Floodlight.pdf
[26]: http://www-users.cselabs.umn.edu/classes/Spring-2014/csci8211/Papers/SDN%20Testing%20A%20NICEWay%20to%20Test%20OpenFlow%20Applications.pdf
[27]: http://faculty.cs.tamu.edu/guofei/
[28]: http://archive.openflow.org/downloads/technicalreports/openflow-tr-2009-1-flowvisor.pdf
[29]: http://faculty.cs.tamu.edu/guofei/
[30]: http://tiny-tera.stanford.edu/~nickm/papers/sane-draft.pdf
[31]: http://dl.acm.org/citation.cfm?id=1282382
[32]: http://www-users.cselabs.umn.edu/classes/Spring-2014/csci8211/Papers/SDN%20Security%20OpenFlow%20Random%20Host%20Mutation-%20Transparent%20Moving%20Target%20Defense%20using%20Software%20Defined%20Networking.pdf
[33]: http://conferences.sigcomm.org/sigcomm/2009/workshops/wren/papers/p11.pdf
[34]: http://www.usenix.org/node/194929
[35]: http://calhoun.nps.edu/bitstream/handle/10945/34771/Xie_Clean_Slate4D-CCR05_DOI.pdf?sequence=1
[36]: http://dl.acm.org/ft_gateway.cfm?id=2560327&type=pdf
[37]: http://faculty.cs.tamu.edu/guofei/
[38]: http://pure.qub.ac.uk/portal/files/13871005/OperationCheckpoint.pdf
[39]: http://maestro.ee.unsw.edu.au/~vijay/pubs/jrnl/15tor.pdf
[40]: http://www.ece.cmu.edu/~minsukk/papers/bottleneck.pdf
[41]: https://users.ece.cmu.edu/~minsukk/papers/spiffy.pdf
[42]: https://www.usenix.org/conference/usenixsecurity15/technical-sessions/presentation/fayaz
[43]: http://www.cs.columbia.edu/~lierranli/coms6998-10SDNFall2014/papers/Flowtags-HotSDN2013.pdf
[44]: https://people.eecs.berkeley.edu/~rishabhp/publications/Sphinx.pdf
[45]: https://www.mendeley.com/catalog/ecos-leveraging-softwaredefined-networks-support-mobile-application-offloading/
[46]: http://faculty.cs.tamu.edu/guofei/
[47]: http://conferences2.sigcomm.org/sigcomm/2015/pdf/papers/p29.pdf
[48]: http://www.usna.edu/Users/cs/aviv/papers/sonchack-ndss16.pdf
