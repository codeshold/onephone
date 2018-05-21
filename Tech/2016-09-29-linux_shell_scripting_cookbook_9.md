---
title: linux shell 学习摘记（9） 
layout: post
author: WenfengShi
category: 技术
tags: [shell]
---

> 《linux shell 脚本编程攻略 （第2版）》 第九章 “管理重任” 笔记  
  
> 常用命令：`ps`, `which`, `whatis`, `whereis`, `file`, `pgrep`, `apropos`, `top`, `kill`, `trap`, `mesg`, `hostname`, `uname`, `/proc`, `crontab`, **imagemagick**, **mysql 脚本**, **用户管理脚本**, **图像管理脚本**  
  
- **ps**  
    1. `ps`, `ps -f`, `ps -e`, `ps aux`, `ps -eo comm,cpu | head`  
    2. 显示所需要的信息`-o`参数, 如pcup, pid, ppid, pmen, comm（可执行文件名）， cmd, user, nice, time, etime（进程启动后流逝的时间）, tty, euid（所关联的tty设备）, stat  
    3. `--sort`根据特定的列进行排序， 如`ps -eo comm,pcpu --sort -pcpu |head`列出占用cpu最多的前10个进程。`ps [OPTIONS] --sort -parameter1,+parameter2,parameter3` 其中＋表示降序，—表示升序。（mac terminal.app 无此功能）  
    4. `ps -C bash -o pid=`直接打印出命令所对应的pid  
    5. `ps -u root -U root -o user,pcpu` 根据用户id等信息过滤ps输出  
    6. `ps -t pts/0,pts/1`通过tty过滤ps输出  
    7. 显示线程相关的信息`-L`， 如`ps -eLf --sort -nlwp | head`, 其中NLWP表示线程的数量，WLP是ps输出中每个条目的线程ID  
    8. `ps -ef`, `ps -e u`, `ps -e w`松宽输出  
    9. 显示进程的环境变量`ps -eo pid,cmd e | tail -n 3`  
  
- `which ls`, `whereis ls`, `file /bin/ls`, `whatis ls`  
  
- `apropos STRING` 搜索和某个单词相关的命令是否存在（whatis database)  
  
- 查看平均负载`uptime` 分别表示1分钟，5分钟， 15分钟内的负载平均值  
  
- 根据字符串搜索`pgrep bas -d ":"`, `pgrep -u root COMMAND`, `pgrep -c COMMND`  
  
- **top**  
  
- **信号**：`kill`用来向系统发送信号；`trap`用来处理接收到的信号  
    1. `kill -l`  
    2. `kill -s SIGNAL PID`, `kill -s SIGKILL PROCESSID`等同于`kill -9 PROCESSID`, `kill -s SIGSTP PROCESSID`等同于Ctrl+Z  
    3. `killall PROCESSNAME`通过进程命令名终止进程 , `killall -u UERNAME PROCESSNAME`, `killall -9 PROCESSNAME`  
    4. `pkill PROCESSNAME`, `pkill -s SINGAL PROCESSNAME`  
    5. `trap 'singal_handler_function_name' SINGALLIST`  

```
#!/bin/bash  
function handler()  
{  
  echo Hey, receievd singal: SIGINT  
}  
  
echo My process ID IS $$  
  
trap 'handler' SIGINT  
  
while true;  
do  
  sleep 1;  
done  
```
  
- 向所有当前的登陆用户发送广播消息`echo hello | wall`  
  
- `mesg y`允许写入消息， `mesg n`不允许写入消息  
  
- 向特定用户发送消息  

```  
#!/bin/bash  
USERNAME=$1  
devices=`ls /dev/pts/* -l | awk '{ print $3,$10 }' | grep $USERNAME | awk '{ print $2 }'`  
for dev in $devices;  
do   
  cat /dev/stdin > $dev  
done  
```  
  
- 采集系统信息  
    1. `hostname`, `uname`, `cat /proc/cpuinfo | sed -n 5p`, `cat /proc/meminfo | head -;`, `cat /proc/partition`或者`fdiks -l`, `lshw`(不一定有)  
    2. **proc** is a pseudo filesystem. 对应的目录下有各个进程的PID, 进一步的有**environ**(进程相关的环境变量), **cwd**(一个到进程工作目录的符号链接), **exe**(进程所对应的可执行文件的链接) `readlink exe`, **fd**包含进程所使用的文件描述符  
  
- **cron**  
    1. `crontab -e`, `crontab -l`, `crontab -u` 每个用户对应有自己的crontab  
  
- [bash读写mysql数据库脚本]()  
  
- [用户管理脚本]()  
  
- **convert 图像处理**  
    1. `convert image.png -resize "50%" image.png`, `convert image.ong -resize 1024x768 image.png`  
    2. [图像管理脚本]()  
  
- **终端截图** `import -window root screenshot.png`, `import screenshot.png`  
  
- 管理多个终端`screen`  
