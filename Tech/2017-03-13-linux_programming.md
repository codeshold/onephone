---
title: “Linux程序设计”小结（进程间通信）
layout: post
author: WenfengShi
category: 技术
tags: [linux]
---
> 原文链接: [http://codeshold.me/2017/03/linux_programming.html](http://codeshold.me/2017/03/linux_programming.html)  


> 最近在面试腾讯时，被着重问了进程间的各种通信方式。面试结束后，借着机会，自己便把《Linux程序设计（第4版）》这本书整本过了一遍。针对该书的主要知识要点, 自己做了总结和适当的补充，同时也标明了书中的一些错误


## 知识点
1. `/proc`(P107)
    - Linux提供了一个特殊的文件系统`procfs`，其以`/proc`目录的形式展现。该目录中包含了许多特殊文件用来对驱动程序和内核信息进行更高层次的访问。
    - `cat /proc/cpuinfo` 查看cpu信息
    - `cat /proc/sys/fs/file-max` 查看系统能同时使打开的文件总数， `cat /proc/sys/fs/file-nr` 可查看具体的详细信息
    - `cat /proc/net/sockstat` 获取网络套接字信息
    - `ls /proc/193/` 查看进程信息（PID为193）， `od -c /proc/193/cmdline` 查看启动该进程的命令
    - 在权限允许的范围内也可对部分内容进行修改（如可打开文件总数、网络内核参数等），但该修改在系统重启后便会失效
    - **原书109页表述的“进程号在1~32000的数字，这是错误的！**，具体值可通过`cat /proc/sys/kernel/pid_max`查看，且就算在32位的系统下，PID的取值范围应该是`0~32767`(short int类型)， 0用于idle进程, 1用于init进程或systemd进程
2. 文件锁定(P222)
    - 可以锁定整个文件，也可锁定文件的一部分
    - Linux通常会在`/var/spool`目录下创建一个锁文件
    - 锁文件是**建议锁**，不是**强制锁**
    - 文件中每个字节在任意时刻只能拥有一种类型的锁，即共享锁（`F_RDLCK`，读锁）、独占锁（`F_WRLCK`，写锁）或解锁(`F_UNLCK`)
    - 文件锁的使用，很多时候相当于一个**二进制信号量**的使用
    - `fcntl.h` 中的`open()`， 也可通过`unistd.h`中的`lockf()`进行设置
    - 预防死锁
2. `fcntl系统调用`(P110)
    - 其对底层文件描述符提供了很多的操作方式
    - 复制、获取和设置**文件描述符标志**，获取**文件状态标志**，管理建议性**文件锁**
    - `#include <fcntl.h>`

3. `mmap函数`(P111)
    - 即内存映射，其可以建立一段被两个或多个程序读写的内存，允许程序间共享内存（Linux内核2.0版本开始包含该功能）
    - mmap创建一个指向一段内存区域的指针，该内存区域的指针与**可以通过一个打开的文件描述符访问的文件的内容**关联。
    - `# include <sys/mman.h> `, `mmap, msync, munmap`
    - 这是一种内存共享机制，还有另外一种**System V**共享内存的方式！

4. 资源和限制(P139)
    - `sys/resource.h`中包括对程序长度、执行优先级和文件资源等方面限制进行查询和设置的函数
    - `limits.h`中定义了许多代表操作系统方面限制的显示常量，如`NAME_MAX`, `CHAR_BIT`, `CHAR_MAX`, `INT_MAX`
    - 也可通过shell内建`ulimit`命令为某一特定shell中运行的程序设置限制
    - 通过`/proc`，`/etc/security/limits.conf`等方式进行设置
    - `nice`可修改程序的运行优先级

5. dbm数据库(P237)
    - dbm数据库适合于存储相对比较静态的索引化数据，其也可以看做是一个索引化的文件存储系统
    - `locate`和`updatedb` 也使用到一个系统数据库（但和dbm有些不同）

6. 进程和信号(P388)
    - UNIX中的定义“一个其中运行着一个或多个线程的地址空间和这些线程所需要的系统资源”
    - 进程是系统资源分配的最小单位，线程是系统调度的最小单位， 线程是进程中的一个执行路径
    - 正在运行的程序由程序代码、数据、变量、打开的文件和环境组成
    - 进程被启动后，系统会按顺序选择一个未被使用的数字作为其PID
    - 进程状态代码（STAT），如`s`表示进程是会话期首进程 （P391）
    - 进程表就是一个数据结构，它会把加载到内存中所有进程的有关信息保存在一个表中 `ps -ef`
    - 进程根据`nice`值来决定其优先级，默认为0， 随着其不间断的运行，其值会不断变化（往往降低）
    - `system()` 是通过shell来启动要执行的程序
    - `exec`系列函数，是通过替换进程映像来启动新进程（把当前进程替换为一个新进程，原来的程序就不存在了），但PID， PPID和nice值和以前完全一样。实质就是“运行中的程序开始执行exec调用中指定的可执行文件中的代码” (P398)
    - `sys/wait.h`, `sys/types.h`, `unistd.h`, `fork()`, `wait()`, `waitpid()`
    - 僵尸进程：子进程虽然不再运行，但其仍然存在于系统中，因为它的退出码还需要保存，已备父进程今后的wait调用使用。同时它将成为一个死(defunct)进程或僵尸(zombie)进程
    - 核心转储文件core，是进程在内存中的镜像，其对调试很有帮助
    - 新程序中应该使用`sigaction`函数（很好的支持信号集），少用`signal` (P413)
    - `SIGKILL`是不可捕获的
    - `fork()`函数的返回值可理解为指向当前进程的子进程链表（第一个号）

7. POSIX线程(P416)
    - 准确定义：“线程是一个进程内部的一个控制序列”
    - 新的线程有自己的栈，但与它的创建者共享**全局变量、文件描述符、信号处理函数、当前目录状态**
    - 线程库使用“本地POSIX线程库”（Native POSIX Thread Library, 即NPTL）
    - 可重入历程（代码被调用多次仍能正常工作，调用可以来自不同的线程，也可以是某种形式的嵌套调用）
    - 编写多线程程序时，需要动过定义`_REENTRANT`来高速编译器我们需要可重入功能，且其定义必须位于`#include`之前
        - 它会对部分函数重新定义他们的可安全重入版本，如`gethostbyname`将变为`gethostbyname_r`
        - `stdio.h`中原来以宏的形式实现的一些函数将变成可安全重入的函数
        - `errno.h`中定义的变量errno将成为一个函数调用，即以线程安全的方式来获取真正的errno
        - 如编译命令 `cc -D_REENTRANT thread1.c -o thread1 -lpthread`
    - `pthread_creat`, `pthread_join`, `pthread_exit`
    - 同步（P423）
        - 信号量 （二进制信号量、计数信号量）， `#include <semaphore.h>`, `sem_init`, `sem_wait`(信号量值-1), `sem_post`(信号量值+1), `sem_destory` 
        - 互斥量（互斥访问）,`#include <pthread.h>`, `pthread_mutex_init`, `pthread_mutex_lock`, `pthread_mutex_unlock`, `pthread_mutex_destroy`
    - 线程的属性
        - 脱离线程(detach thread)，通过修改线程的属性或调用`pthread_detach`的方式来创建
        - `pthread_attr_init`, `pthread_attr_setdetachstate`, `pthread_attr_getdetachstate`等
        - 取消线程 `pthread_cancel`

## 进程间的通信
1. 管道 (P443)
    - popen调用
        - `stdio.h`中的`FILE *popen(const char *command, const char *type)`, `int pclose(FILE *stream)`
        - popen调用运行的一个程序时，首先启动Shell，即系统中的sh命令，再将command字符串作为一个参数传递个它，即每个popen将多启动两个进程！
    - pipe调用
        - `unistd.h`中的`int pipe(int pipefd[2])`, `int pipe2(int pipefd[2], int flags);`
        - 写到`pipefd[1]`中的所有数据都可以从`pipefd[0]`中读回来
        - 如果在原先的进程中创建一个管道，然后再调用fork创建新的进程，即可通过管道在两个进程之间传递数据！
    
    - dup调用
        - `unistd.h`中`int dup(int oldfd)`, ` int dup2(int oldfd, int newfd)`, `int dup3(int oldfd, int newfd, int flags);`
        - 可把管道用作标准输入和标准输出
    - 命名管道（有名管道）FIFO （P456）
        - 可在**不相关的进程**之间交换数据
        - named pipe 是一种特殊的文件类型， 在文件系统中以文件名的方式存在
        - `mknod filename p` 或者 `mkfifo filename p` 可创建一个FIFO文件
        - 在程序中可使用`#include <sys/types.h>`, `#include <sys/stat.h>`中` int mkfifo(const char *pathname, mode_t mode)`或者`int mknod(const char *path, mode_t mode, dev_t dev)`
        - 同pipe创建的管道不同，FIFO以文件名的方式存在，在进行读写之前需要必须先`open`打开
2. 信号量(P489)
    - 这个信号量函数比线程中的信号量函数更常用！
    - 用于管理对资源的访问，它是一个特殊的变量，只能对它进行等待(wait)和发送信号(signal)操作
    - PV操作：P用于等待；V用于发送信号
    - 假设有一个信号量sv， 则`P(sv)`, `V(sv)`的意思？ (P489)
    - ` #include <sys/sem.h>`, `semctl()`用于直接控制信号量的信息,  `semget()` 创建一个新信号量或者获取一个已有的信号量, `semop()`用于改变信号量的值
    - 信号量都会对应到一个`key_t`(应用程序提供，有效地为信号量命名)
3. 共享内存（P496）
    - 用于程序之间**高效**的共享数据，允许两个不相关的进程访问同一个逻辑单元
    - `#include <sys/shm.h>` 中 `shmget`创建或者获取一个已有的，`shmat`(第一次创建共享内存段时，其不能被任何进程访问，要想启动对该共享内存的访问，必须将其连接到一个进程的地址空间中，shmat成功则返回共享内存第一个字节的指针), `shmdt`将共享内存从当前进程中分离
    - 共享内存会对应到一个`key_t`（应用程序提供，有效地为共享内存命名）
    - `mmap`也是实现内存共享的一种方式
4. 套接字(P513)
    - 本地套接字的名字是Linux文件系统中的文件名，一般放在`/tmp`或`/usr/tmp`目录中， `AF_UNIX`
        - 通过`socket(AF_UNIX, SOCK_STREAM, 0)`(UNIX文件系统域)建立的本地套接字会在当前目录下（默认）以文件的形式存在，`ls -lF socketname`查看
    - 网络套接字， `AF_INET`, `AF_INET6` 等
        - 流套接字 `SOCK_STREAM`, 数据包套接字 `SOCK_DGRAM`
    - 套接字的特性由3个属性确定：域(domain)、类型(type)、协议(protocol)， 地址格式随域（又名协议族， protocol family)
    - 主机字节序、网络字节序：对于一个数字，高位（数字的位）在前(低地址空间)的是big endian, 低位在(低地址空间)前的是little endian， x86是little endian [记忆图][1]
    - 因特网守护进程 （xinetd/inetd）：UNIX以超级服务器的方式来提供多项网路服务，而特定的网络服务往往在需要的时候才会启动！
    - `setsockopt()`可用来控制套接字的行为
    - `select()系统调用`允许程序同时在多个底层文件描述符或套接字上等待输入或处处活动的的到来；其可用于测试**文件描述符集**，但每次都得遍历全部的，通过其可同时处理多个客户端而无需再依赖子进程了
    - IO多路复用机制：`select`, `poll`, `epoll`之间的[区别][2]
    - [关于同步、异步与阻塞、非阻塞的理解][3]
5. 信号
    - signal
6. 文件
    - Linux将一切事物看做文件



  [1]: http://codeshold.me/2017/03/c_programming_specification.html
  [2]: http://www.cnblogs.com/Anker/p/3265058.html
  [3]: http://www.cnblogs.com/Anker/p/5965654.html

