---
title: 半小时搭建电子商务网站--opencart
layout: post
author: WenfengShi
category: 技术
tags: [web]
---
原文链接: [http://codeshold.me/2017/01/opencart_installation.html](http://codeshold.me/2017/01/opencart_installation.html)  


## 前言

> 朋友在亚马逊（美国）上开了一家网点且注册了自己的品牌，amazon需要品牌商提供自己的网站，于是乎朋友找到了我，并给了我一个品牌商网站的参考（他的一位朋友在淘宝上买的电子商务网站--**三四百块**），然后我点开了，接着我留意了网站底下的`Powered By OpenCart`，最后我发现这压根可以不要钱啊啊啊啊（尽管自己不搞前端）！


> 自己仔细看了朋友的朋友买的电子商务网站，它用的就是一个开源的opencart（类似 wordpress），而且也没有什么定制化的内容，更没有开通支付功能（开通支付功能貌似还要加一千块），也就是一个纯正的开源的东西！

> 于是自己花了一个小时免费帮朋友弄了下，好在他自己注册且备案了一个域名，而我正好也有个vps，下文是自己部署OpenCart的记录！



## 安装OpenCart

### 1. 准备

1. [opencart是干吗的？][1]
2. vps用的是DigitalOcean（自己用来翻墙的）
3. 域名是在阿里云上注册和备案的
4. 服务器操作系统 CentOS 7

### 2. 部署

- 安装并配置httpd

        ```bash
        ## 1. 安装软件包
        [root@ss ~]# yum install httpd php-y
        ## 2. 启动httpd服务
        ##    httpd启动后，浏览器输入服务器ip即可浏览默认的apache web页面
        [root@ss ~]# systemctl start httpd
        ## 3. 设置httpd和mariadb开机启动
        [root@ss ~]# systemctl enable httpd
        ```

- 安装并配置mariadb(mysql)

        ```
        ## 1. 安装软件包
        [root@ss ~] yum install mariadb mariadb-server -y

        ## 2. 启动自动安装&配置
        [root@ss html]# mysql_secure_installation 
        ......

        ## 3. 登陆mysql
        ##    创建数据库opencartdb
        ##    新建用户opencart（密码opencart）并赋予权限
        [root@ss html]# mysql -u root -p
        ......
        ## 3.1 创建数据库opencartdb
        MariaDB [(none)]> create database opencartdb;
        Query OK, 1 row affected (0.00 sec)
        ## 3.2 新建用户opencart（密码opencart）并赋予权限
        MariaDB [(none)]> grant all privileges on opencartdb.* to opencart@localhost identified by 'opencart';

        ## 3. 设置mariadb开机启动
        [root@ss ~]# systemctl enable httpd mariadb
        ```

- 安装php及相关扩展包
可跳过扩展包的安装，根据后面opencart检测的结果再安装也行

        ```bash
        ## 1. 安装php
        [root@ss ~]# yum install php -y

        ## 2. 安装扩展包(可跳过此步骤，后面根据opencart检测的结果再安装)
        [root@ss ~]# yum install php-mysql php-mcrypt php-gd php-cli php-pdo -y

        ## 3. 查询结果如下
        [root@ss opencart]# rpm -qa | grep php
        php-common-5.4.16-42.el7.x86_64
        php-5.4.16-42.el7.x86_64
        php-mysql-5.4.16-42.el7.x86_64
        php-mcrypt-5.4.16-7.el7.x86_64
        php-gd-5.4.16-42.el7.x86_64
        php-cli-5.4.16-42.el7.x86_64
        php-pdo-5.4.16-42.el7.x86_64

        ```

- 安装和配置opencart
安装包可从[官网][2]或[github][3]上下载最新版本

```bash
[root@ss ~]# mkdir opencart && cd opencart

## 1. 从github上下载最新版本的compiled包
[root@ss opencart]# wget https://github.com/opencart/opencart/releases/download/2.3.0.2/2.3.0.2-compiled.zip

## 2. 解压
[root@ss opencart]# unzip -q 2.3.0.2-compiled.zip

## 3. 拷贝upload目录下的文件到/var/www/html/下
[root@ss opencart]# cd /var/www/html/
[root@ss html]# cp ~/opencart/upload/* . -rf

## 3. 根据目录下的`install.txt`文件即可完成配置和安装）
## 3.1 修改config.php 文件名
[root@ss html]# mv config-dist.php config.php
[root@ss html]# mv admin/config-dist.php admin/config.php
## 3.2 添加可写权限
[root@ss html]# chmod a+w config.php admin/config.php 
[root@ss html]# chmod a+w /var/www/html/image/ -R
[root@ss html]# chmod a+w /var/www/html/system/ -R
```


- 进入安装页面

浏览器输入服务器ip地址进入页面安装  
可能会需要`systemctl restart httpd`重启httpd服务
![QQ截图20170117153441.png-52.2kB][4]


- 进入pre-installation检测页面
请根据检测的结果，安装相应的软件包、php扩展包或者设置文件权限
如下图显示缺少了php扩展（修改请参考前面步骤，如`yum install php-mcrypt -y`，修改后重启httpd服务`systemctl restart httpd`，再刷新页面）！  
![QQ截图20170117153535.png-73.6kB][5]
如下图显示缺少对应文件或目录的可写权限（修改请参考前面步骤，如`chmod a+w config.php admin/config.php`，修改后重启httpd服务`systemctl restart httpd`，再刷新页面）！
![image_1b6lm4dep1ndo1qs41jh41slg1pm318.png-92.3kB][6]
修改后的
![image_1b6lmii5g12pkpk21fh81gb2nmp1l.png-42.9kB][7]

- 进入配置页面 
填写前面设置的数据库名opencartdb，以及用户名和密码（opencart/opencart）  
如果一开始已经配置好了域名解析，hostname一栏填写域名即可！

![image_1b6ln2cspq6m1pusaud7v01vic22.png-72.1kB][8]

- 完成安装后
参考`install.txt`

```bash
## 删除安装目录
[root@ss html]# rm -rf install/
## 由于安装的是github上的compiled包，所以要拷贝vendor
[root@ss ~]# cp -rf  ~/opencart/vendor/ /var/www/
[root@ss www]# cd /var/www/ && ls 
cgi-bin  html  vendor
```

- 输入IP测试

![image_1b6lnoorg1mjc1br31s8e1nlh17md2f.png-220.3kB][9]

## 其他配置（防火墙，ftp）
- 防火墙配置
自己取消了CentOS7的firewalls，使用的是iptables,如下

```
## 1. 取消firewalld服务
[root@ss ~]# systemctl stop firewalld && systemctl disable firewalld
## 2. 安装iptables-services
[root@ss ~]# yum install iptables-services -y 
## 3. 添加防火墙设置
[root@ss ~]# vim /etc/sysconfig/iptables
## 3.1 添加如下规则
-A INPUT -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT
## 3.2 启动防火墙并设置开机启动
[root@ss ~]# systemctl start iptables && systemctl enable iptables
```


- ftp配置
安装vsftp, `yum install vsftpd -y `, 配置好后，浏览器进入管理页面(http://域名/admin/)进行设置，如下

![image_1b6m9vfu2gn4hjf1tk61qr2cve3m.png-30.2kB][10]

## 域名设置
- 在阿里云**云解析DNS**上添加记录，如下（假设域名为[codeshold.me][11]）

|记录类型|主机记录|记录值|解析线路|TTL（秒）|说明|
|:------:|:------:|:----:|:------:|:-------:|----|
|A|@|XX.XX.XX.XX|默认|600|@表示将**codeshole.me**解析为该IP, 600表示DNS缓存生存时间为10分钟|
|A|www|XX.XX.XX.XX|默认|600|@表示将**www.codeshole.me**解析为该IP, 600表示DNS缓存生存时间为10分钟|


- 修改config文件
在配置好自己的域名后，如果出现`在浏览器输入域名登录网站后，在点击页面链接，域名显示为了IP地址` 这个问题(见问题1)，如下，则需修改config文件，如下

```
[root@ss ~]# systemctl restart httpd
[root@ss ~]# vim /var/www/html/admin/config.php 
......
[root@ss ~]# vim /var/www/html/config.php 
......
```

![image_1b6m9h0ue12li11ll1j2r74n1ioq39.png-10.1kB][12]

## 问题

### 1. 地址栏域名变成了IP

解决方法见上

![image_1b6m9fv5a163g13f983r12j15kq2s.png-32.2kB][13]

### 2. 访问不了页面

请确保防火墙的设置


  [1]: https://www.opencart.com/
  [2]: https://www.opencart.com/
  [3]: https://github.com/opencart/opencart/releases/download/
  [4]: http://static.zybuluo.com/wuzhimang/cma1g144mc4z30dayuggeqi8/QQ%E6%88%AA%E5%9B%BE20170117153441.png
  [5]: http://static.zybuluo.com/wuzhimang/nsisvfuabzn780ce0o5ya35w/QQ%E6%88%AA%E5%9B%BE20170117153535.png
  [6]: http://static.zybuluo.com/wuzhimang/c4cv7mffg2b7jsydikp2ht7h/image_1b6lm4dep1ndo1qs41jh41slg1pm318.png
  [7]: http://static.zybuluo.com/wuzhimang/b9ozbi8kcmgq51rjoey3fo3d/image_1b6lmii5g12pkpk21fh81gb2nmp1l.png
  [8]: http://static.zybuluo.com/wuzhimang/5bh6zmkvcbo696w482vgt14t/image_1b6ln2cspq6m1pusaud7v01vic22.png
  [9]: http://static.zybuluo.com/wuzhimang/6x4yzgckm8qhihwng1llns6e/image_1b6lnoorg1mjc1br31s8e1nlh17md2f.png
  [10]: http://static.zybuluo.com/wuzhimang/y52eu99nu78qqewdtj8zp2jn/image_1b6m9vfu2gn4hjf1tk61qr2cve3m.png
  [11]: http://codeshold.me/
  [12]: http://static.zybuluo.com/wuzhimang/nebcut87qu5sl67i8gm68mot/image_1b6m9h0ue12li11ll1j2r74n1ioq39.png
  [13]: http://static.zybuluo.com/wuzhimang/hlp1pc2ej3q1e6koqpcbzh2d/image_1b6m9fv5a163g13f983r12j15kq2s.png
