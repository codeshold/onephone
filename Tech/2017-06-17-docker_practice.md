---
title: “Docker Practice”读书笔记
layout: post
author: WenfengShi
category: 技术
tags: [docker, network]
---
博客链接: [http://codeshold.me/2017/06/docker_practice.html](http://codeshold.me/2017/06/docker_practice.html)


> 一本很不错的Docker入门书籍,[github地址](https://github.com/yeasy/docker_practice), 自己仔细看完了前14章, 提了一个pull request, 修改了3个issue！  
关键字：docker, Union FS(AUFS), cgroups, namespace  

### 使用镜像

- `brew cast install docker`
- `docker --version`, `docker-compose --version`, `docker-machine --version`, `docker version`, `docker info`
- `docker run -d -p 80:80 -name webserver nginx`
- `docker stop webserver`, `docker rm webserver`
- `docker pull [选项] [Docker Registery地址] <仓库名>:<标签>`
    - Docker Registery地址格式: `<域名/IP>[:端口号]`
    - 仓库名: `<用户名>/<软件名>`
    - `docker pull ubuntu:14.04`, 即`docker pull library/ubuntu:14.04`
    - `docker run -it --rm ubuntu:14.04 bash`

- `docker images`, 多层次存储结构，Union FS
    - `docker images -f dangling=true`, dangling images!
    - `docker rmi $(docker images -q -f dangling=true)`
    - `docker images -a`, `docker images ubuntu`, `docker images ubuntu:16.04`
    - `docker images -f since=mongo:3.2`, `docker images -f before=mongo:3.2`
    - `docker images --filter label=com.example.version=0.1`
    - `docker images -q`, quiet
    - `docker images --format "\{\{.ID\}\}: \{\{.Repository\}\}"`(实际命令中`\`不需要), Go的模版语法
        - `docker images --format "table \{\{.ID\}\}\t\{\{.Repository\}\}\t\{\{.Tag\}\}"`(实际命令中`\`不需要)

- `docker commit`
    - 该命令除了学习之外,还有一些特殊的应用场合,比如被入侵后保存现场等
    - 该命令意味着所有对镜像的操作都是黑箱操作,生成的镜像也被称为黑箱镜像
    - `docker exec -it webserver bash`
    - `docker diff webserver`
    - `docker commit --author "Wenfeng Shi" --message "change the default page\!" webserver nginx:v2`
    - `docker history nginx:v2`
    - `docker run --name web2 -d -p 81:80 nginx:v2`

- Dockerfile
    - `FROM scratch`
    - RUN指令有shell和exec格式,即`RUN ["可执行文件", "参数1", "参数2"] `
    - `docker build -t nginx:v3 .`, `.`是上下文路径, 即`docker build [选项] <上下文路径/URL/->`
    - `.dockerignore`文件
    - `docker build https://github.com/twang2218/gitlab-ce-zh.git#:8.16`
    - `docker build http://server/context.tar.gz`
    - `docker bulid - < Dockerfile` 或`cat Dockerfile | docker build -`
    - `docker build - < context.tar.gz`
    - Dockerfile指令：[Dockerfile官方文档](https://docs.docker.com/engine/reference/builder/), [Dockerfile最佳实践文档](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/#run)

- 其他
    - 从rootfs压缩包导入，`docker import http://download.openvz.org/template/precreated/ubuntu-14.04-x86_64-minimal.tar.gz openvz/ubuntu:14.04`
    - `docker save nginx:v3 | gzip > nginx.v3.tar.gz`
    - `docker load -i nginx.v3.tar.gz`
    - 高级命令`docker save <镜像名> | bzip2 | pv | ssh <用户名>@<主机名> 'cat | docker load'`

- 删除
    - `docker rmi [选项] <镜像1> [<镜像2> ...]`
        - `docker rmi 501`, `docker rmi centos`
    - `docker rm [选项] <容器1>`
    - `docker images --digests`
    - 并非所有的 docker rmi 都会产生删除镜像的行为
    - `docker rmi $(docker images -q -f dangling=true)`
    - `docker rmi $(docker images -q nginx)`
    - `docker rmi $(docker images -q -f before=nginx:v2)`

```bash
FROM nginx
RUN echo '<h1>Hello, Docker!</h1>' > /usr/share/nginx/html/index.html
```

- 对于 CentOS/RHEL 的用户来说,在没有办法使用 UnionFS 的情况下,一定 要配置 direct-lvm 给 devicemapper ,无论是为了性能、稳定性还是空间利用率


### 使用容器
- 启动
    - `docker run ubuntu:14.04 /bin/echo 'hello world'`, `docker run -t -i ubuntu:14.04 /bin/bash`
    - `docker start`
    - `docker run -d ubuntu:14.04 /bin/sh -c "while true; do ech o hello world; sleep 1; done"`
        - `docker ps`
        - `docker logs [container ID or NAMES]`
        - `docker stop f07`
    - 当Docker容器中指定的应用终结时,容器也自动终止, `docker ps -a`
        - `docker start f07`, `docker restart f07`
    - `docker run -idt nginx /bin/bash`, `docker attach f07`
    - nsenter
        - `PID=$(docker-pid 243c32535da7)`
        - `sudo nsenter --target 10981 --mount --uts --ipc --net --pid`

- 导入导出
    - `docker export 7691a814370e > ubuntu.tar` 导出容器快照
    - `cat ubuntu.tar | docker import - test/ubuntu:v1.0` 导入镜像, 不同于 `docker load`(包含元数据信息和历史数据)
    - `docker import http://example.com/exampleimage.tgz example/imagerepo`

- 删除
    - `docker rm 3fd`, `docker rm -f 3fd`
    - `docker rm $(docker ps -a -q)`

### 访问仓库
- DockerHub
    - `docker login`, `docker search node`
    - `docker search node --filter=stars=38`, `docker search node --filter=stars=38`
    - 可实现自动创建功能(Automated Builds), Dokcer Hub && GitHub && BitBucket
- 私有仓库
    - 仓库会被创建在容器的`/tmp/registry`, `-v`参数可将镜像文件存放在本地的指定路径。
        - `docker run -d -p 5000:5000 -v /opt/data/registry:/tmp/registry registry`
    - `docker tag ba58 192.168.7.26:5000/test`
    - `docker push 192.168.7.26:5000/test`
    - config_sample.yml 配置文件 

### 数据管理
- `docker run -d -P -v /webapp --name web training/webapp python app.py`, `-v`参数用来创建data volume
- Dockerfile中的VOLUME也可以进行设置
- `docker rm -v ef4` 删除容器时，附带删除volume
- `docker run -d -P -v /src/webapp:/opt/webapp/ --name web training/webapp python app.py`，挂载主机目录为数据卷
    - `docker run -d -P -v /src/webapp:/opt/webapp/:ro --name web trainging/webapp python app.py` 只读权限
- `docker inspect web`
- `docker run --rm -it -v ~/.bash_history:/.bash_history ubuntu /bin/bash` 挂载本地文件
    - 最简单的办法就直接挂载文件的父目录
- data volumes container
    - `docker run -d -v /dbdata --name dbdata training/postgres echo Data-only container for postgres`
    - `docker run -d --volumes-from dbdata --name db1 training/postgres`
    - `docker run -d --volumes-from dbdata --name db2 training/postgres`
    - `docker run -d --name db3 --volumes-from db1 training/postgres`
    - `docker run --volumes-from dbdata -v $(pwd):/backup ubuntu tar cvf /backup/backup.tar /dbdata` 备份
    - `docker run -v /dbdata --name dbdata2 ubuntu /bin/bash` 恢复, 创建一个带有空数据卷的容器
    - `docker run --volumes-from dbdata2 -v $(pwd):/backup busybox tar xvf /backup/backup.tar` 恢复， 解压到挂载的数据卷容器中
    - `docker run --volumes-from dbdata2 busybox /bin/ls /dbdata` 恢复，测试

### 网络
- 外部访问容器
    - `docker run -d -P nginx`, `docker ps -l` 
    - `docker logs -f 6ed`
    - 参数`-p`支持的格式有，IP:HostPort:ContainerPort, IP::ContainerPort, HostPort:ContainerPort
    - `docker run -d -p 5000:5000 training/webapp python app.py` 默认绑定所有接口上的所有地址
    - `docker run -d -p 127.0.0.1:5000:5000/udp training/webapp python app.py`
    - `docker port 6ed`, `docker port 6ed 80` 查看端口映射
    - `docker run -d -p 5000:5000  -p 3000:80 training/webapp python app.py` 映射多个端口
- 容器互联
    - `docker run -d -P --name web training/webapp python app.py`
    - `docker inspect -f "\{\{ .Name \}\}" aed`(实际命令中`\`不需要) 查看容器名字
    - `docker run -d --name db training/postgres` 容器互联
    - `docker run -d -P --name web --link db:db training/webapp python app.py`, `--link`参数实现容器互联
        - `--link name:alias`, 其中 name 是要链接的容器的名称, 是这个连接的别名
        - Docker通过2种方式为容器公开连接信息，即环境变量、`/etc/hosts`文件
        - `env`, `cat /etc/hosts`, `ping db`
- 高级网络配置
    - **待详细介绍**
    - `sysctl -w net.ipv4.ip_forward=1`
    - `iptables -nL`, `iptables -t nat -nL`, `brctl show`, `ip addr show eth0`, `brctl addbr bridge0`
    - `docker run -i -t --rm --net=none base /bin/bash`
    - `docker inspect -f '\{\{.State.Pid\}\}' 1f1f4c1f931a`(实际命令中`\`不需要)
    - 点到点连接
        - `ip link add A type veth peer name B`
        - `ip link set A netns 2989`
        - `ip link set B netns 3004`

### 安全
- 内核的命名空间, 在容器中运行的进程不会被运行在主机上的进程和其它容器发现和作用。（拥有独立的网络栈）
- 控制组机制, 实现资源的审计和限制
- 服务端防护
    - 使用本地的 Unix 套接字机制替代了原先绑定在 127.0.0.1 上的 TCP 套接字
    - 终极目标
        - 将容器的 root 用户映射到本地主机上的非 root 用户,减轻容器和主机之间因权限提升而引起的安全问题
        - 允许 Docker 服务端在非 root 权限下运行,利用安全可靠的子进程来代理执行需要特权权限的操作
- 内核能力机制(capability)， 提供细粒度的权限访问控制。
    - 容器可以禁用一些没必要的权限:
        - 完全禁止任何 mount 操作
        - 禁止直接访问本地主机的套接字
        - 禁止访问一些文件系统的操作,比如创建新的设备、修改文件属性等
        - 禁止模块加载
- 其他安全特性：TOMOYO, AppArmor, SELinux, GRSEC

### 底层实现
- Docker 底层的核心技术包括 Linux 上的命名空间(Namespaces)、控制组 (Control groups)、Union 文件系统(Union file systems)和容器格式 (Container format)
- namespace: pid命名空间、net命名空间、ipc命名空间、mnt命名空间、UTS("UNIX Time-sharing System") 命名空间、user 命名空间
- cgroups: 对共享资源进行隔离、限 制、审计等
- UnionFS: 联合文件系统是一种分层、轻量级并且高性能的文件系统
    - 目前支持的联合文件系统种类包括 AUFS, btrfs, vfs 和 DeviceMapper。
- libcontainer: 容器格式 https://github.com/docker/libcontainer
- Docker 的网络实现其实就是利用了 Linux 上的网络命名空间和虚拟网络设备(特别是 veth pair)


