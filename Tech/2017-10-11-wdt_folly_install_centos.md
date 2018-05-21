---
title: WDT (Folly) 安装指南 -- CentOS 7
layout: post
author: WenfengShi
category: 技术
tags: [network, tool]
---
博客链接: [http://codeshold.me/2017/10/wdt_folly_install_centos.html](http://codeshold.me/2017/10/wdt_folly_install_centos.html)

> 断断续续的摸索了三天，终于在 CentOS 7 上成功的安装了Facebook的 WDT！！！ 
很麻烦，有选择的话，还是建议直接在Ubuntu上安装，可以节省很多时间和精力……

## 0x01 Preface
> 下最新的源码、最新的源码、最新的源码

1. WDT 依赖 Facebook的 Folly库，故需要先验证Folly的编译和安装
2. 通过yum安装的glog-devel、gflags-devel、gtest-devel 版本比较低，编译Folly时会报错，需要下载最新源码编译安装
3. double-conversion 库自己是通过yum安装的，在**CentOS 7.2** 和 **CentOS7.3** 下未发现报错信息
4. WDT 务必直接`git clone`下载最新源码，最新的release版本也可能会出现编译错误（踩过的坑, git issue也有提及）
5. gcc一定要4.9或以上，自己并没有手动升级操作系统的gcc，用的是`scl`(centos-release-scl)
6. 注意设置`LD_LIBRARY_PATH`的路径，默认情况下，编译安装的库都在`/usr/local/lib`目录下
7. `PKG_CONFIG_PATH`可不用设置，自己只是设置了`LD_LIBRARY_PATH`, 当然在`pkg-config --variable pc_path pkg-config`路径中再添加一个`/usr/local/pkgconfig`也可以
8. 安装时注意文件的路径，wdt和folly要在同一目录下

## 0x02 Prepare
- glog: Google的一个C++语言的应用级日志记录框架，提供了C++风格的流操作和各种助手宏。
- gflags: Google的一个开源的处理命令行参数的库，使用c++开发，具备python接口，可以替代getopt。
- [double-conversion][1]: A library that performs fast, accurate conversion between double precision floating point and text.
- jemalloc: General-purpose scalable concurrent malloc implementation
- [boost][2]: Boost库是一个可移植、提供源代码的C++库，作为标准库的后备，是C++标准化进程的开发引擎之一, Boost库是为C++语言标准库提供扩展的一些C++程序库的总称。
- [libunwind][3]: a portable and efficient C programming interface (API) to determine the call-chain of a program. 
- [folly][4]: Folly contains a variety of core library components used extensively at Facebook. 

## 0x03 Installation Steps
先完成Folly的安装，再完成WDT的安装

### 1. Install Folly
- Ref: https://github.com/facebook/folly

``` bash
# Install gcc 4.9 devtoolset
[root@gf01 package]# gcc --version
gcc (GCC) 4.8.5 20150623 (Red Hat 4.8.5-11)
[root@gf01 package]# yum install epel-release -y 
[root@gf01 package]# yum install centos-release-scl -y
[root@gf01 package]# yum install devtoolset-3-toolchain -y 

# Switch to gcc 4.9 env
[root@gf01 package]# scl enable devtoolset-3 bash
[root@gf01 package]# gcc --version
gcc (GCC) 4.9.2 20150212 (Red Hat 4.9.2-6)

# Required -- Install dependent packages 
yum install \
gcc \
gcc-c++ \
autoconf \
autoconf-archive \
automake \
boost-devel \
libtool \
lz4-devel \
xz-devel \
snappy-devel \
zlib-devel \
scons \
double-conversion-devel \
openssl-devel \
libevent-devel \
git \
-y 

# Optional -- Install dependent packages
yum install \
libdwarf-devel \
elfutils-libelf-devel \
libunwind-devel.x86_64 \
-y

# Add  `/usr/local/lib` to LD_LIBRARY_PATH
export LD_LIBRARY_PATH="/usr/local/lib${LD_LIBRARY_PATH:+:}${LD_LIBRARY_PATH}"

# Download && Compile && Install gflags
# Current Directory /home/big_data
git clone https://github.com/schuhschuh/gflags.git
mkdir gflags/build && \
cd gflags/build && \
cmake3 -DGFLAGS_NAMESPACE=google -DBUILD_SHARED_LIBS=on .. && \
make -j && \
make install

# Download && Compile && Install glog
# Current Directory /home/big_data
git clone https://github.com/google/glog.git
cd glog && \
autoreconf -ivf && \
./configure --with-gflags=/usr/local/lib && \
make -j && \
make install

# Download folly and gtest
# Current Directory /home/big_data
git clone https://github.com/facebook/folly.git && \
cd folly/folly/test && \
rm -rf gtest && \
wget https://github.com/google/googletest/archive/release-1.8.0.tar.gz && \
tar zxf release-1.8.0.tar.gz && \
rm -f release-1.8.0.tar.gz && \
mv googletest-release-1.8.0 gtest

# Compile && Install folly
# Current Directory: /home/bigdata/folly/folly
autoreconf -ivf && \
./configure && \
make -j && \
make install 
```

### 2. Install wdt
- Ref: https://github.com/facebook/wdt
- `CTESET_OUTPUT_ON_FAILURE=1 make test`中若出现部分测试用例不过，可以直接`make install`，自己部署了多台服务器，但有一台出现了部分case失败（`CentOS Linux release 7.3.1611 (Core)`），原因还在排查，但`make install`之后也并不影响文件的传输！

```
# Required -- Install dependent packages 
yum install \
cmake3.x86_64 \
double-conversion-devel.x86_64 \
jemalloc-devel.x86_64 \
boost-devel.x86_64 \
openssl-devel.x86_64 \
libunwind-devel.x86_64 \
-y

# Optional -- Install dependent packages
yum install boost-system.x86_64 \
-y 

# Download && Compile && Install wdt
# Current Directory /home/big_data
git clone https://github.com/facebook/wdt.git
cd wdt && \
cmake3 . -DBUILD_TESTING=on && \
make -j && \
CTESET_OUTPUT_ON_FAILURE=1 make test && \
make install
```

### 3. Test wdt
- 使用说明参考 `wdt -helpfull | less`

```bash
# Server 指定端口范围，默认开启8个TCP流
wdt -directory /home/bigdata/testfiles/ -transfer_id 1 -start_port 22888

# Client 指定端口范围，指定加密方式，提高传输速度
wdt -directory /usr/bin/ -destination 10.10.88.172 -transfer_id 1 -start_port 22888 -encryption_type aes128ctr
```

## 0x04 Ref
- http://hackage.haskell.org/package/double-conversion
- http://www.nongnu.org/libunwind/
- https://github.com/facebook/folly
- https://github.com/facebook/wdt
- gcc 4.9 -- https://www.dwhd.org/20160724_085212.html
- https://askubuntu.com/questions/210210/pkg-config-path-environment-variable
- Other commands

``` bash
yum install libmpc-devel mpfr-devel gmp-devel

cmake3 . -DGFLAGS_INCLUDE_DIR=/usr/local/include/gflags  -DGFLAGS_LIBRARY=/usr/local/lib -DGLOG_INCLUDE_DIR=/usr/local/include  -DGLOG_LIBRARY=/usr/local/lib

DOUBLE_CONVERSION_HOME=/usr/include/double-conversion

./configure LDFLAGS=-L$DOUBLE_CONVERSION_HOME/ CPPFLAGS=-I$DOUBLE_CONVERSION_HOME/
LD_LIBRARY_PATH=$DOUBLE_CONVERSION_HOME/ make

pkg-config --variable pc_path pkg-config
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/lib64/pkgconfig:/usr/share/pkgconfig

export LD_LIBRARY_PATH=/usr/local/lib:/usr/local/lib64/:$LD_LIBRARY_PATH
export C_INCLUDE_PATH=/usr/local/include/:$C_INCLUDE_PATH
export CPLUS_INCLUDE_PATH=/usr/local/include/:$CPLUS_INCLUDE_PATH
```




  [1]: http://hackage.haskell.org/package/double-conversion
  [2]: https://baike.baidu.com/item/boost/69144?fr=aladdin
  [3]: http://www.nongnu.org/libunwind/
  [4]: https://github.com/facebook/folly
