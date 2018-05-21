---
title: 360黑客攻防技术分享会--记录
layout: post
author: WenfengShi
category: 技术
tags: [security, note]
---

> 图灵社区， 360黑客攻防技术分享会
> 技术关键字: XSS, CSRF, WAF, BeEF, CSP

## 1. 李响《从应急响应看黑客攻击纵深》
> 360信息安全部 0Kee Team, 擅长Web攻防，运维安全，先主要专注应急响应攻击溯源研究
> 2014年加顾360，曾在网站检测团队”库带计划“项目工程工作过。

案例
1. 安全防御平台
2. shelllog日志
3. webshell高警
4. rootkie 系统后门
5. 溯源应用log工具

Geo info --> whois 查询信息 --> 社工QQ到乌云白帽子

应急响应步骤
1. 确认漏洞类型？确定业务类型？
- SQL注入/OS命令注入/弱口令
- 核心业务/边缘业务/合作业务

2. 确认机器类型？网络环境类型
- 核心机器/非核心机器
- 核心网段/隔离网段

3. 攻击着做了哪些事？攻击者背景？
- 检测系统
- web/log 分析要点
- shellog & banshlog & webshell 分析要点
- 调查攻击者身份背景

4. 时间反思?
－不足、改进


应急响应中的“坑”: 开发人员、使用者的角度分析

案例解决方案: 攻击反弹


## 2. 孟之杰《初识前端攻击》
> 奇舞团高级研发工程师《黑客攻防技术宝典：浏览器实战篇》译者之一


网站的主要攻击方式,以及前端相关的攻击形式
- XSS
- CSRF
- 网络劫持(https-->http)
- 社会工程学(给一段代码放在)

CSRF: Cross-site request forgery 
1. 微博案例
2. 非幂等请求使用post
3. 给表单增加token, 对请求增加refer进行校验

用户环境多样化：浏览器、插件类型版本不同，攻击、防御方法也不同
chrome 相对的做的更多，较firefox激进

## 3. 王珂、任言《XSS攻击与前端防御》
> 王珂， 0Kee Team 成员，奇虎360高级安全研究员，前端安全工具“360护心镜”作者，入选BlackHat和Kcon2016兵器谱
> wangke-it@360.cn
> http://0kee.360.cn/hxj
> 任言， 毕业于天津大学，0Kee Team成员，擅长渗透测试和Web漏洞挖掘，参与开发"Skywolf", php灰盒代码审计工具，入选Kcon2016兵器谱


XSS: Cross-site scripting
> beef The Browser Exploitation Framework 
> 补天漏洞响应平台 http://butian.360.cn/


网站内的js能做什么： 执行本地命令、读取本地文件等都不行，但是能做很多事情
- XSS 攻击邮箱，盗取cookie...
- XSS 新浪微博，蠕虫
- XSS + CSRF --> GetShell
- XSS攻击内网，获取内网IP, 存活机器
- XSS 钓鱼

XSS防御
- 关键字过滤流量，WAF(web application firewall, 网站应用级入侵防御系统) 网站程序通用防护模块(基础防御、一定要)
- Http Only
- CSP 内容安全策略， content security policy, 缓解潜在的跨站脚本问题 -- google
- “360护心镜”--配置、部署灵活，对大部分类型的css起到防护作用，漏洞预警，平台化处理漏洞 --> 开源、有公共平台

