---
layout: post
title: GridFTP编译 
category: 科研
tags: [高速网络]
---

### DELL 服务器说明
* 服务器硬件配置说明
1. CPU信息：`lscpu`; 详细信息： `cat /proc/cpuinfo` (`grep`, `sort`, `uniq`, `wc -l`, `cut -f2 -d:`)
2. 内存信息：`free -h`; 详细信息：`cat /proc/meminfo`
3. 硬盘信息：`fdisk -l`， `df -lh` （1979.1 GB, 419.1 GB）
4. RAID 信息
![image_1ap22f3r0crg1hra1014t1qbu9.png-110.3kB][1]

* iDRAC 说明
1. 默认用户名/密码：root/calvin --> 现已统一修改给root/123456
2. IP地址依次为`10.10.88.161~163`(服务器在机架中的位置自底向上)
* OS 说明
1. CentOS 7
2. IP地址依次为`10.10.88.171~173`（服务器在机架中的位置自底向上）
3. 主机名和root密码依次为`gridftp01`,`gridftp02`,`girdftp03`
4. 默认登录用户名依次为`gridftp01`,`gridfrp02`,`gridftp03`，密码均为`123456`
5. 新增`gridftp04`
6. 系统版本信息`lsb_release -a`
* GridFTP源码
1. source code 可以直接从`10.10.88.154`下载（GridFTP\source_code\globus-toolkit-git.zip）

### 配置本地yum源
修改 */etc/yum.repos.d/CentOS-Base.repo* （配置文件如下） ，添加`baseurl=http://10.10.82.154/centos6/` , `yum clean all && yum list`即可。

```
......
[base]
name=CentOS-$releasever - Base
mirrorlist=http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os&infra=$infra
#baseurl=http://mirror.centos.org/centos/$releasever/os/$basearch/
baseurl=http://10.10.82.154/centos6/
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6
......
```
### Autotools学习文档
1. 下载的autotools入门文档在154主机上（ppt && pdf）
2. 两个介绍的比较好的中文博客[Autotools 使用入门](http://darktea.github.io/notes/2012/06/24/autotools.html), [例解 autoconf 和 automake 生成 Makefile 文件](http://www.ibm.com/developerworks/cn/linux/l-makefile/)
3. 一个最好的英文介绍博客[Autotools Tutorial](https://www.lrde.epita.fr/~adl/autotools.html)
## 1. 环境部署&&生成configure
* *github*上下载最新版本的源代码（`10.10.82.154:/home/project/863/GridFTP/source_code/globus-toolkit-git.zip`），不过由于linxu上直接git不下来(远程服务器老断)，所以是在windows下好后拷过去的，所以后期需要unix2dos进行处理。
* `yum install openssl* libtool* git unix2dos` # 安装libtool、libtool-devel、git、unix2dos工具包
* `touch globus-version.inc` # 防止编译报缺少文件的错误
* `chmod -R a+x *`
* `./unixtool.sh` # 执行下列脚本

```shell
#/bin/bash
for i in $(find . )
do 
    dos2unix -q $i
done
```

* `autoreconf -if 2>&1 | tee autoreconf_042216.log` # 生成configure，同时输出记录到autoreconf.log,只是为了方便找编译的错误
 
## 2. 编译安装
可参照官方教程进行`./configure --prefix=`, `make globus_gridftp_server | make install`等各类包的安装，以下是个示例(先设置环境变量`export GLOBUS_LOCATION=/usr/local/globus-6`)

```
[root@localhost globus-toolkit]# ./configure --prefix=$GLOBUS_LOCATION --enable-udt --enable-myproxy
[root@localhost globus-toolkit]# make udt myproxy gridftp
[root@localhost globus-toolkit]# make install
# 下面是一个打包示例，即在一台服务器上安装成功后，打包相应文件后另一台主机解压即可(如编译安装*globus_gridftp_server*)
[root@localhost globus-toolkit]# cd $GLOBUS_LOCATION
[root@localhost globus_6]# tar zcf globus_gridftp_server_04222100.tar.gz .
[root@localhost globus_6]# ls
bin  etc  globus_gridftp_server_04222100.tar.gz  include  lib  libexec  sbin  share  var
```

## 3. 错误处理
1. 若出现下列错误或者是有关**gsi_openssh**的，将`10.10.82.154:/home/project/863/GridFTP/source_code/globus_toolkit-6.0.1453307864/packaging/package-output/gsi_openssh-5.7-src.tar.gz`解压到gis_openssh/source下面就行
> === configuring in gsi_openssh/source (/home/gridftp01/globus-toolkit/gsi_openssh/source)
> configure: WARNING: no configuration information is in gsi_openssh/source

2. 若出现`../libtool: line 1128: g++: command not found`错误，请安装`gcc-c++`软件包或者直接`yum groupinstall 'Development Tools'`
3. 在进行了相应文件的拷贝后，如.a、.so等，若出现类似`.libs/globus_xio_udt_ref.o: could not read symbols: Bad value`错误，请进行 ** a fresh install!!** 


----
## 下面的不用看了(手动一步步编译的)
* 生成configure
1. `[root@share GT6.0-compile]# chmod a+x ./update-dirt.sh ./packaging/git-dirt-filter`
2. `[root@share GT6.0-compile]# dos2unix ./update-dirt.sh ./packaging/git-dirt-filter`
3. `[root@share GT6.0-compile]# touch globus-version.inc`
4. `[root@share GT6.0-compile]# aclocal`-->将configure.ac里所需要的M4宏复制到文件夹中，即生成aclocal.m4
5. `[root@share GT6.0-compile]# autoconf `-->通过congfigure.ac和aclocal.m4生成configure脚本 (`configure.ac:26: warning: AC_LANG_CONFTEST: no AC_LANG_SOURCE call detected in body`)

* 生成Makefile
1. `[root@share GT6.0-compile]# mkdir build-aux`
2. `[root@share GT6.0-compile]# libtoolize`
3. `[root@share GT6.0-compile]# automake --add-missing`-->通过Makefile.am生成Makefile.in
备注：
- 若出现`required file 'build-aux/ltmain.sh' not found`错误，需先运行`libtoolize`或者`autoheader`
- 若出现`.ibtoolize: AC_CONFIG_MACRO_DIR([m4]) conflicts with ACLOCAL_AMFLAGS=-I` 错误，是因为configure.ac和Makefile.am文件是dos格式导致的，通过dos2unix转换一下。
> 在windows上使用git时，建议不转换文件格式
> git config --global core.autocrlf false
> git config --global core.safecrlf true
> git config --global core.eol lf 或者手工直接编辑.gitconfig文件，该文件位于用户主目录下。

[root@share GT6.0-compile]# libtool --version
ltmain.sh (GNU libtool) 2.2.6b
Written by Gordon Matzigkeit <gord@gnu.ai.mit.edu>, 1996
Copyright (C) 2008 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.


  [1]: http://static.zybuluo.com/wuzhimang/cozaleudp9wcz30yjuqs2i6y/image_1ap22f3r0crg1hra1014t1qbu9.png
