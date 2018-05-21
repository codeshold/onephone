---
title: 再读《Linux Shell脚本攻略》
layout: post
author: WenfengShi
category: 技术
tags: [shell]
---
  
> 最近有空，自己又重新看了遍《Linux Shell脚本攻略（第二版）》。尽管接触Linux Shell 已有两年了，但通过再读这本入门教程，自己收获还是挺多的，确实是一个好的工具书。为了**抗遗忘**和**方便查阅**，于是自己写了些笔记总结，分享一下。  
  
> 说明：    
1. 针对原书的一个简单梳理（有少许自己添加的内容）  
2. 可用来**查阅**, **复习**及**自测**（详细内容需看原文）  
3. 适合有基础的人阅读  
 
## 第1章  
  
- 主要内容：bash基础概念、终端打印、数学运算等  
  
- 主要命令：`let`, `cat`, `变量字符串处理`, `数学计算`, `管道|`, `重定向`, `$`, `expr`, `bc`, `echo`, `$#`, `$*`, `$0`, `eval`, `tr`, `printf`, `read`, `tput`, `循环语句`, `条件语句`, `分隔符IFS`等  
  
- [章节总结](http://codeshold.me/2016/09/linux_shell_scripting_cookbook_1.html)  
  
## 第2章  
  
- 主要内容：GNU/Linux常用命令、加密散列命令、并行执行  
  
- 主要命令：`cat`, `script`, `scriptreplay`, `find -exec`, `xargs`, `tr`, `md5sum`, `sha1sum`, `md5dep`, `crypt`, `gpg`, `base64`, `opensslpasswd`, `sort`, `uniq`, `mktemp`, `split`, `csplit`, `${URL%*.}`, `${URL##*.}`, `rename`, `look`, `echo -e`, `grep -q`, `PIDARRAY+=("$!")`, `expect`等  
  
- [章节总结](http://codeshold.me/2016/09/linux_shell_scripting_cookbook_2.html) 
  
## 第3章  
  
- 主要内容：文件生成、挂载文件、iso镜像  
  
- 常用命令：`comm`, `chmod/chown`, `chattr`, `touch`, `列出目录的相关命令`, `readlink`, `file`, `<<<`, `dd`, `有关光盘的各类命令`,`mkfs.ext4`, `mkisofs`, `isohybrid`, `mount/umount`, `fdisk`, `loseup`, `sync`, `cdrecord`, `eject`, `diff`, `patch`, `seq`, `tail`, `dmesg`, `pidof`, `pushd/popd`, `wc`, `tree`      
  
- [章节总结](http://codeshold.me/2016/09/linux_shell_scripting_cookbook_3.html)  
  
## 第4章  
  
- 主要内容：命令行文本处理、正则表达式、sed/awk等  
  
- 常用命令：`正则表达式`, `grep/egrep`, `sed`, `awk`, `cut`, `find`, `xargs`, `tr`, `变量切片`    
  
- [章节总结](http://codeshold.me/2016/09/linux_shell_scripting_cookbook_4.html)  


## 第5章   
- 主要内容：通过shell与web进行交互，实现web页面的数据采集、解析能任务, POST/GET数据，Twitter客户端脚本  
  
- 常用命令：`wget`, `lynx`, `curl`, `图片抓取脚本`, `网页相册生成脚本`  
  
- [章节总结](http://codeshold.me/2016/09/linux_shell_scripting_cookbook_5.html)  
  
## 第6章  
  
- 主要内容：主要涉及数据的备份、归档、压缩等命令， 还包括全盘镜像  
  
- 常用命令： `tar`, `gzip`, `zcat`, `zip`, `unzip`, `lzma`, `pbzip`, `rsync`, `git`, `squashfs`, `fsarchiver`    
  
- [章节总结](http://codeshold.me/2016/09/linux_shell_scripting_cookbook_6.html)  
  
## 第7章  
  
- 主要内容：网络配置相关的命令，ssh用法，高级端口转发，原始网络通信，防火墙配置等  
  
- 常用命令：`ifconfig`, `host`, `nslookup`, `dhclient`, `route`, `ping`, `fping`, `nc`, `lsof`, `netstat`, `iwconfig`, `ssh`, `sshfs`, `firewall`, `&子进程`    
  
- [章节总结](http://codeshold.me/2016/09/linux_shell_scripting_cookbook_7.html)  
  
  
## 第8章  
  
- 主要内容：系统监控方面的命令，日志记录、保镖生成、磁盘使用、cpu占用、文件系统检测等等  
  
- 常用命令：`du`, `time`, `ps`, `watch`, `whoami`, `who`, `w`, `users`, `uptime`, `last`, `logrotate`, `powertop`, `iotop`, `fsck`, **入侵检测脚本**, **活跃用户脚本**    
  
- [章节总结](http://codeshold.me/2016/09/linux_shell_scripting_cookbook_8.html)  
  
  
## 第9章  
  
- 主要内容：系统管理方面的命令，还介绍了mysql， 图片缩放，窗口截屏等命令  
  
- 常用命令：`ps`, `which`, `whatis`, `whereis`, `file`, `pgrep`, `apropos`, `top`, `kill`, `trap`, `mesg`, `hostname`, `uname`, `/proc`, `crontab`, **imagemagick**, **mysql 脚本**, **用户管理脚本**, **图像管理脚本**    
  
- [章节总结](http://codeshold.me/2016/09/linux_shell_scripting_cookbook_9.html)  
  
