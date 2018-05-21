---
title: linux shell 学习摘记（8） 
layout: post
author: WenfengShi
category: 技术
tags: [shell]
---

> 《linux shell 脚本编程攻略 （第2版）》 第八章 “当一个好管家” 笔记  
  
> 常用命令：`du`, `time`, `ps`, `watch`, `whoami`, `who`, `w`, `users`, `uptime`, `last`, `logrotate`, `powertop`, `iotop`, `fsck`, **入侵检测脚本**, **活跃用户脚本**  
  
  
- **du** disk usage  
    1. `du -s -h .`, `-s` summary  
    2. `du -c .` 磁盘使用总计  
    3. `du --exclude "*.txt" FILES(s)`, `--exclude-from XXX`  
    4. `du --max-depth 2 DIRECTORY`  
    5. 找出目录中最大的十个文件`du -ak /home/ | sort -nrk 1 | head -n4`; `find -type f -exec du -k {} \; | sort -nrk 1 | head`  
  
- **time**, 一个是bash内建time，一个是二进制程序time，后者功能更多  
  
- 手机与当前登录用户、启动日志和启动故障的相关信息  
    1. `whoami`,`who`, `w`  
    2. `users` 当前登录主机的用户列表; `users | tr ' ' '\n' | sort | uniq`  
    3. `uptime` 系统运行多久  
    4. `last` 获取上一次启动一级用户登录会话的信息，以`/var/log/wtmp`作为输入文件；`last reboot`获取重启会话；`lastb`获取失败的用户会话  
  
- **ps**  
  
- `watch`  
  
- **logrotate**  
  
- syslog记录日志，**logger**, [入侵检测脚本]()  
  
- 找出系统中用户的活跃时间段(`last`) [脚本]()  
  
- **powertop**  
  
- **iotop** 监视磁盘  
  
- 检查磁盘及文件系统错误 `fsck`  
