---
title: C语言编程规范（华为软件精英挑战赛）
layout: post
author: WenfengShi
category: 技术
tags: []
---
> 原文链接: [http://codeshold.me/2017/03/c_programming_specification.html](http://codeshold.me/2017/03/c_programming_specification.html)  


> 参加华为软件精英挑战赛，复习了下基本的C语言编程规范，并做了小结！


## C语言编程规范

1. 头文件
    - 编译过程
        ![QQ截图20170312103751.png-312.8kB][1]
    - 头文件职责单一：头文件插入不简单，会占用不少的时间
        - VC预编译头的选项？？？
            - 防止一些重复编译来达到加快编译速度的一个技术
            - 在编译时，头文件不会直接参与编译，而是在预处理时与cpp文件合并后再参与编译。有些头文件几乎是所有cpp文件都需要包含的，如`<stdio.h>`,`<windows.h>`等，这样这些文件就需要在每个包含它的cpp文件中重复编译。早些时候，这些头文件不大，重复编译也浪费不了多少时间。然而到了MFC(Microsoft Foundation Classes)出现的时候，其头文件变得超级大，如就一个<afxwin.h>就长达6000多行，这样重复编译这些长的头文件就会造成更长的编译时间。为了解决这个问题，VC++编译器**把这些公共头文件事先单独编译，然后在编译包含它的cpp文件时，就直接使用头文件编译结果参与cpp文件的后续编译任务**。这种“一次编译，多次使用”的方法，确实能减少编译时间。(`stdafx.h`, `stdafx.cpp`)
    - 禁止包含用不到的头文件
    - 放置接口声明、不适合放实现
    - **禁止在头文件中定义变量**：可能出现重定义错误
    - **头文件应向稳定方向包含**：一个头文件的变化，会导致所有包含该头文件代码的重新编译
    - 禁止头文件循环依赖: 减少“依赖深度过深的错误”
    - 总是编写内部的`#ifndef`保护符：`#ifndef A_H_ ...`
    - 头文件应当**自包含**
    - 禁止`extern "C"`中包含头文件!
        - `extern "C"`的主要作用就是为了能够正确实现C++代码调用其他C语言代码。加上extern "C"后，会指示编译器这部分代码按C语言的进行编译，而不是C++的。由于**C++支持函数重载**，因此编译器编译函数的过程中会将函数的参数类型也加到编译后的代码中，而不仅仅是函数名；而C语言并不支持函数重载，因此编译C语言代码的函数时不会带上函数的参数类型，一般之包括函数名。
        - 比如说你用C 开发了一个DLL 库，为了能够让C ++语言也能够调用你的DLL输出(Export)的函数，你需要用`extern "C"`来强制编译器不要修改你的函数名。
        - [extern "C"用法解析][2]：`extern "C" `用来修饰变量和函数的！
        - [C、C++接口间的相互调用举例][3]
    - 每个c文件应有一个同名h文件
    - 设计文档写出来的时候就过时了！头文件才是王道！
    ![QQ截图20170312104621.png-309.8kB][4]
    
1. 函数编程规范
    - **圈复杂度**小于7：一个函数可以执行的路径条数
    - 函数要短小（推荐小于50行， 每行80个）
    - 嵌套层数小于5
    - 职责单一
    - 抽象层单一：同一层的抽象在同一层
    - **参数不超过3个**
    - 避免重复
    - 避免**重入**问题: 锁机制
    - 不要返回局部变量
2. 语法规范
    - 命令、注释、格式、效率、安全
        - 效率和可维护性冲突时，往往选择后者
    - 安全：通过指针访问内存（优点也是缺点）
        - 地址&内存空间：Data(常量区、全局变量区、静态变量区、堆、栈）+Code（代码区）
3. C语言常见问题
    - 堆管理
        - 申请粒度不易过细，过细的建议使用栈空间（建议大于8字节）
    - 栈管理
        - 不要返回栈空间地址，进程间通信不要传递或返回栈变量
    - 强制类型转换（用来欺骗编译器）
    - 整数溢出
    - 字节对齐（取自身长度和对齐长度的最小值）
        - **将数据结构**设置为与字节无关的（或者添加字节预留符）
        - [字节对齐说明][5]
    - 字节序
        ![image_1bb0dep2n1a077e0tlp1q0qfi211.png-180.4kB][6]
    - 编译器眼中的指针
        - 编译器就是这个脾气!
            ![image_1bb0dl4ce12i817mqih49cqm4i1e.png-515.8kB][7]
        - 代码：小心取地址符号`&`，小心`sizeof`, 指针加减（按指针所指向的元素的大小移动），将数组名或字符串名的值即是其第一个元素的地址！

                    [gridftp02@gf02 ~]$ cat pointer.c 
#include <stdio.h>
                    int main(int argc, char *argv[])
                    {
                        char name_array[] = "test";
                        char *name = "test";
                        
                        printf("name address:%#x\n", name_array);
                        printf("name address:%#x\n", &name_array[0]);
                        printf("name address:%#x\n", &name_array);
                        printf("name address:%#x\n", name_array+1);
                        printf("name address:%#x\n", &name_array+1);
                        printf("name address:%#d\n", sizeof(name_array));
                        printf("==============\n");
                        
                        printf("name address:%#x\n", name);
                        printf("name address:%#x\n", &name[0]);
                        printf("name address:%#x\n", &name);
                        printf("name address:%#x\n", name+1);
                        printf("name address:%#x\n", &name+1);
                        printf("name address:%#d\n", sizeof(name));
                        
                        return 0;
                    }
                    [gridftp02@gf02 ~]$ gcc pointer.c 
                    [gridftp02@gf02 ~]$ ./a.out 
                    name address:0x50ec0a40
                    name address:0x50ec0a40
                    name address:0x50ec0a40
                    name address:0x50ec0a41
                    name address:0x50ec0a45
                    name address:5
                    ==============
                    name address:0x400760
                    name address:0x400760
                    name address:0x50ec0a38
                    name address:0x400761
                    name address:0x50ec0a40
                    name address:8


3. 相关
- 《代码简洁之道》
- 《重构》
- `Good code is not bad code!`
- 代码检视、单元测试、集成测试、系统测试


## 说明
0. [华为软件精英挑战赛，C语言规范视频][8]
1. [华为C语言编程规范, pdf下载链接][9]


  [1]: http://static.zybuluo.com/wuzhimang/780vktvfr3omvf1umwucgh8e/QQ%E6%88%AA%E5%9B%BE20170312103751.png
  [2]: http://www.jianshu.com/p/5d2eeeb93590
  [3]: http://blog.csdn.net/lincoln_2012/article/details/50801080
  [4]: http://static.zybuluo.com/wuzhimang/ksd8eakge47kwrrav0vohtl9/QQ%E6%88%AA%E5%9B%BE20170312104621.png
  [5]: http://blog.csdn.net/21aspnet/article/details/6729724#comments
  [6]: http://static.zybuluo.com/wuzhimang/7zy52n1xml94txde8s7b2lc4/image_1bb0dep2n1a077e0tlp1q0qfi211.png
  [7]: http://static.zybuluo.com/wuzhimang/4c1ab263agvswn13vry0t90c/image_1bb0dl4ce12i817mqih49cqm4i1e.png
  [8]: http://codecraft.huawei.com/home/SoftBooks
  [9]: http://download.csdn.net/download/r77683962/5065107
