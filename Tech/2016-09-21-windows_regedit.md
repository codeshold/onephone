---
title: windows注册表小知识
layout: post
author: WenfengShi
category: 技术
tags: [windows]
---


## 打开

1. `Win键`，然后输入`regedit`  
2. `Win键`+`R`，打开**运行**，然后输入`regedit.exe`  

## 介绍 

1. 注册表是windows操作系统、硬件设备以及客户应用程序得以正常运行和保存设置的核心“数据库”，也可以说是一个非常巨大的树状分层结构的数据库系统。  
2. 注册表记录了用户安装在计算机上的软件和每个程序的相互关联信息，它包括了计算机的硬件配置，包括自动配置的即插即用的设备和已有的各种设备说明、状态属性以及各种状态信息和数据。利用一个功能强大的注册表数据库来统一集中地管理系统硬件设施、软件配置等信息，从而方便了管理，增强了系统的稳定

## 分类

如下图所示，windows注册表包括以下5个根键：

![image_0at58d4k2f8n16cu138v13g21vgsm.png-28.7kB][8]

1.HKEY_CLASSES_ROOT

- 该根键包括启动应用程序所需的全部信息，包括扩展名，应用程序与文档之间的关系，驱动程序名，DDE和OLE信息，类ID编号和应用程序与文档的图标等。
- 这就是为什么我们双击某一个文档的时候，可以由系统自动调出应用程序的所在了。
- 其子健主要分为两种：一是已经注册的各类文件的扩展名；一是各种文件类型的有关信息

2.HKEY_CURRENT_USER

- 根键包括当前登录用户的配置信息，包括环境变量，个人程序以及桌面设置等

3.HKEY_LOCAL_MACHINE

- 该根键包括本地计算机的系统信息，包括硬件和操作系统信息，安全数据和计算机专用的各类软件设置信息

4.HKEY_USERS

- 根键包括计算机的所有用户使用的配置数据，这些数据只有在用户登录系统时才能访问。这些信息告诉系统当前用户使 用的图标，激活的程序组，开始菜单的内容以及颜色，字体

5.HKEY_CURRENT_CONFIG

- 该根键包括当前硬件的配置信息，其中的信息是从HKEY_LOCAL_MACHINE中映射出来的。

## 使用

### “右键菜单”设置

以[如何在windows 10文件管理器上快速启动bash shell](http://www.howtogeek.com/270810/how-to-quickly-launch-a-bash-shell-from-windows-10s-file-explorer/)为例，可以参考链接手动设置，也可以直接运行下面的**注册表脚本**

- 将bash添加到**右键菜单**（context menu），将下面的内容保存为`.reg`文件，然后用管理员权限运行即可  
如果未设置图标，`"Icon"="%USERPROFILE%\\AppData\\Local\\lxss\\bash.ico"`这个可以去掉，其他的内容自行修改

```
Windows Registry Editor Version 5.00

[HKEY_CLASSES_ROOT\Directory\Background\shell\bash]
@="Open a Bash shell here"
"Icon"="%USERPROFILE%\\AppData\\Local\\lxss\\bash.ico"

[HKEY_CLASSES_ROOT\Directory\Background\shell\bash\command]
@="\"C:\\Windows\\System32\\bash.exe\""
```

- 将Bash从**右键菜单**中移除的脚本，保存为`.reg`文件，然后用管理员权限执行即可。

```
Windows Registry Editor Version 5.00

[-HKEY_CLASSES_ROOT\Directory\Background\shell\bash]
```

## 说明
1. [参考网站](http://www.howtogeek.com/270810/how-to-quickly-launch-a-bash-shell-from-windows-10s-file-explorer/)




  [8]: http://static.zybuluo.com/wuzhimang/tiwtzpdtflrgo6aifmfj7rdv/image_1at58d4k2f8n16cu138v13g21vgsm.png
