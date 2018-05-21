---
title: 一篇特别长的总结(C专家编程)
layout: post
author: WenfengShi
category: 技术
tags: [读书笔记, c/c++]
---
博客链接: [http://codeshold.me/2017/02/expert_c_programming.html](http://codeshold.me/2017/02/expert_c_programming.html)

> 读一本书必输出一篇笔记或者总结！！！
> 《C专家编程》这本书很早看完了，但整理笔记却断断续续的花了三天时间，这从侧面更说明了这本书的经典了（尽管不到300页）！
> 至此C经典著作《C Traps and Pitfalls》《Expert C Programming》《POINTER ON C》已经算完整的看完了……


## 典型

1. `typedef struct bar {int bar;} bar;` 中`bar`的含义
2. 为什么`extern char *p`和另一个文件中的`char p[100]`不能匹配？
3. 什是总线错误（bus error）？什么是段违规/段错误（segmentation violation）？
4. `char *foo[]`和`char (*foo)[]`有何不同？


## 迷雾

1. 计算机日期
- UNIX的系统时间是从1970年1月1日(UTC)起按秒算的
- timestamp是从1970年开始的
- 先有UNIX，再有C
- 关于`time_t`什么时候会重新回到开始？即达到尽头，运行如下代码可查询（2038年）

            #include <stdio.h>
            #include <time.h>

            int main(){
                // time_t 是 long 的typedef形式（有符号）
                time_t biggest = 0x7FFFFFFF;
                // ctime 把时间转化为当地时间（含时区）
                printf("biggest = %s \n", ctime(&biggest));
                // gmtime 获取对应的UTC时间，但返回的不是一个可打印的字符串，故使用asctime
                printf("biggest = %s \n", asctime(gmtime(&biggest)));
                return 0;
            }

2. C语言排斥强类型，即其是弱类型

3. C语言的许多特性是为了方便编译器设计者而建立的:
- 数组下表从0开始
- 基本数据类型直接和底层硬件相关
- auto 关键字是摆设（它是缺省的内存分配模式，其只对创建符号表入口的编译器设计者有用）
- float被自动扩展为double（但在ANSI C中不在这样）
- 不允许嵌套，即函数内部包含另外一个函数

4. C和shell
- Steve Bourne编写的UNIX shell时，创立了一个C语言的变型， 其使用了很多“显示的结束语句”，如`if...fi`，且shell不用malloc，而使用`sbrk`自行负责堆存储管理，提高字符串处理效率。
- Broune 事实上促成了国际C语言混乱代码大赛（The International Obfuscated C Code Competition）

5. 应使用ANSI C 而不是 K&R C

6. ANSI C 对编译器的部分要求如下
- 在函数定义中形参个数的上限至少可以达到31个
- 在函数调用中实参个数的上限至少可以达到31个

7. ANSI C 与 K&R C 的不同
    1. 新的、非常不同，且重要的(仅一个)
        - ANSI C 把函数原型作为函数声明的一部分，原型的形式，其两者也有了很大的变化
    2. 新增的关键字
        - ANSI C 增加了 enum, const, volatile, signed, void等关键字
        - 弃掉了K&R C中的entry等关键字
    3. “安静的改变”
        - 相邻字符串的面值会被自动连接在一起
        - 寻常算数转换（usual arithmetic conversation）
        - K&R C 采用的是无符号保留（unsigned preserving）原则，即当一个无符号类型与int或更小的整型混合使用时，结果类型是无符号类型。
        - ANSI C 采用的是值保留（value preserving）原则，即当执行算数运算时，如果类型不同，就会发生转换。数据类型朝着浮点精度更高、长度更长的方向转换，整形数如果转换为signed不会丢失信息，就转换为signed，否则转换为unsigned —— 即包括整型升级和寻常算数转换

                main(){
                    if(-1 < (unsigned char)1)
                        printf("-1 is less than (unsigned char)1: ANSI semantics");
                    else
                        printf("-1 NOT less than (unsigned char)1: K&R C semantics");
                }

    4. 除上面之外的其他区别
        - 符号粘贴（token-pasting）
        - 三字母词（trigraph），即用3个字符表示一个单独的字符，如两字母词`\t`表示“tab”， 三字母词`??<`表示“开放的花括号”

8. 实参、形参的匹配
- 如下代码会报一条warning，“argument #1 is imcompatible with prototype...”，为什么？

            foo(const char **p) {}

            main(int argc, char **argv) {
                foo(argv);
            }

- 原因分析(摘自ANSI C标准):
    - 每个实参都应该具有自己的类型，这样它的值就可以复制给与它所对应的形参类型的对象（该对象的类型不能含有限定符）
    - 要使得上述赋值形式合法，必须满足下列条件之一：
        1. 两个操作数都是指向有限定符或无限定符的相容类型指针
        2. 左边指针所指向的类型必须具有右边指针所指向类型的全部限定符
    - 基于上述描述`故实参char *能和型参const char*匹配`
    - `const float *`类型并不是一个有限定符的指针类型，它的类型是“指向一个具有const限定符的float类型的指针，即`const修饰的是指针指向的类型而不是指针本身`
    - 基于上条描述`故char ** 和 const char ** 都是没有限定符的指针类型，但它们所指向的类型不一样，进而不相容， 所以报错`

9. `const`和`＊`通常只用于数组形式的参数中模拟传值调用！

10. `#pragma`用于向编译器提示一些信息，诸如希望把某个特定函数扩展为内敛函数，或者取消边界的检查。

11. 一个‘L’的 NUL 用于结束一个ACSII 字符串；两个‘LL’的 NULL 用于表示什么也不指向（空指针）


## 特性

1. 一个遵循标准的C编译器至少允许一条switch语句中有257个case标签

2. 使用`switch... case...break...`时，养成添加`/* fall through */`的习惯

3. 字符串数组初始化（枚举声明、单行多变量声明等），最后一个尾巴`,`，ANSI C rationel对其的解释是：它使得C语言在自动生成时更容易些！

4. 几乎没有人习惯在函数名前添加存储类型说明符，所以绝大多数函数都是全局可见

5. C语言的符号重载
- `static` 在函数内部时，表示该变量的值在各个调用间一直保持着连续性；……
- `void` 位于参数列表中，表示没有参数；……
- `()` 调用一个函数；定义带参数的宏；包围sizeof操作符的操作数（如果它是类型名）
    - 当sizeof操作数是个类型时，其必须加上`()`，若是变量则不必加括号（建议加）
6. `i = 1, 2;` 中 i 的结果是？（1）
    - 优先级
    - 结合性

7. `/`可对一些字符转义，包括newline（即回车键，表示连接）

8. 不充分的参数解析，shell参数解析
    - 找出目录中的链接文件
        - `ls -l | grep ->`，`ls -l | grep "->"` 均不行
        - `ls -AF | grep "@"` 或者 `file -h | grep link`

9. `ratio = *x/*y;` 会报错??

10. 错误检查程序，lint程序


## 声明
1. 存储类型说明符(storage-class)：extern static register auto typedef

2. 类型限定符(type-qualifier): const volatile

3. “在函数调用时，参数按照从右到左的次序压到堆栈里”这种说法过于简单，参数在传递时首先尽可能地存放到寄存器中（追求速度）

4. 结构体
- 一般形式

            struct 结构标签 (可选) {
                类型1 标志符1；
                类型2 标志符2；
                ……
            } 变量定义(可选);

- 结构中允许存在位段、无名字段以及字对齐所需的填充字段

            struct pid_tag {
                unsigned int inactive : 1;
                unsigned int : 1; // 1个位的填充
                unsigned int refcount : 6;
                unsigned int : 0; //填充到下一个字边界
                short pid_id;
                struct pid_tag *link;
            }

- 位段的类型必须是int，unsigned int 或 signed int（或加上限定词）

5. 联合
- 一般形式

            union 结构标签 (可选) {
                类型1 标志符1；
                类型2 标志符2；
                ……
            } 变量定义(可选);

- 节省存储空间 && 提取单独的字节字段（联合不需要额外的赋值和强制类型转换，同一个数据可解释为两个不一样的东西）
- 如下`value.byte.c0`

            union bits32_tag {
                int whole;  /* 一个32位的值 */
                struct {char c0, c1, c2, c3;} byte;  /* 4个8位的字节 */
            } value;

6. 枚举
- 把一串名字和一串整型值联系在一起

7. 如果const（或）volatile关键字的后面紧跟着类型说明符（如int，long等），它作用于类型说明符。在其他情况下，const和（或）volatil 关键字作用于它左边紧邻的指针星号

8. 分析以下声明：
- `char * const *(*next)();`
- `char *(* c[10])(int **p);`

9. typedef关键字并不是创建一个变量，而是宣称“这个名字是指定类型的同义词”

10. `typedef struct foo{...foo;}`的含义
- C语言中存在多种名字空间：
    - 标签名（label name)
    - 标签（tag）
    - 成员名
    - 其他
- 对于`typedef struct baz {int baz;} baz;` 即相当于 `typedef struct baz {int baz;} baz_type;` 
    - typedef声明引入了baz_type作为`struct baz {int baz;}`的简写形式
    - `struct baz xxxxx; `使用的是结构标签
    - `baz yyyyy;` 使用的是结构类型

11. 编写C语言声明解释程序cdecl


## 指针和数组

### 1. 不同的
1. 数组和指针并不相同
- 对编译器而言，一个数组就是一个地址，一个指针就是一个地址的地址。
    - `char *p = "abcdefgh"; ...p[3]` 先取符号表中p的地址；提取存储于此处的指针；把偏移量和指针相加，产生一个地址；访问这个地址，取得内容
    - `char a[] = "abcdefgh"; ....a[3]` 先取符号表中a的地址；把偏移量和这个地址相加，产生一个地址；访问这个地址，取得内容
- 初始化指针时所创建的字符串常量被定义为只读！

2. `extern int *x;`和`extern int x[]` 区别？

3. 声明和定义
- 声明相当于普通的声明：它所说明的并非本身，而是描述其他地方的创建的对象
- 定义相当于特殊的声明：它为对象分配内存
- 定义是声明的特殊情况，它分配内存空间，并可能提供一个初始值

5. 左值：可修改的左值（允许出现在复制语句左边）和不可修改的左值
- 数组名是左值，但不能作为赋值的对象（左值即为可取地址的值），编译器为每隔对象分配一个地址（左值）
回文！


### 2. 相同的
1. 表达式中数组名（与声明不同）被编译器当作一个指向该数组第一个元素的指针
    - “表达式中的数组”就是指针
    - `a[6] = ...; 6[a] = ...;` 两种形式都正确
    
            fun1(int arr[]) {
                int tmp[] = {1, 2, 3};

                printf("%#x\n", &arr);
                printf("%#x\n", arr);
                printf("%#x\n", &(arr[0]));

                printf("%#x\n", &tmp);
                printf("%#x\n", tmp);
                printf("%#x\n", &(tmp[0]));
            }

2. 下标总是与指针的偏移量相同
    - C语言把数组下标作为指针的偏移量
    - 处理以一维数组时，指针并不见的比数组快

3. 在函数参数的声明中，数组名被编译器当作指向该数组第一个元素的指针
    - “作为函数参数的数组名”等同于指针
    - 下面代码运行正常

            fun2(int arr[]) {
                arr[1] = 3;
                *arr = 3;
                arr = array2;
            }

### 3. 其他的

1. 在C语言中，所有非数组形式的数据均以传值形式调用

2. 指针就是指针，只是可以通过下表的形式对其进行访问

3. 用a[i]这样的形式对数组进行访问总是被编译器“改写”或解释为像`*(a+1)`这样的指针访问

4. 多维数组初始化时，可省略最左边下标的长度（也只能是最左边），如`int rhubarb[][3] = { {0, 0, 0}, {1, 1, 1},};`

5. sizeof(数组名)返回的是数组总的字节数
- 下面代码，运算结果如下 `sizeof(str):15 func sizeof(str):8`

            #include <stdio.h>

            int func(char str[]) {
                return sizeof(str);
            }
            int main(){
                char str[] = "abcdefghijklmn";

                printf("sizeof(str):%lu\n", sizeof(str));
                printf("func sizeof(str):%d\n", func(str));
            }

6. 指针数组就是Iliffe向量, `char *pea[4]`
7. 指针数组必须用指向为字符串而分配的内存的指针进行初始化
8. “数组名被改写成一个指针参数”规则并不是递归定义的。数组的数组会被改写成为“数组的指针”，而不是“指针的指针”
- 对应列表

        |实参|所匹配的形式参数|
        |:-----:|-------:|
        |数组的数组`char c[8][10];`| `char (*)[10]` 数组指针|
        |指针数组`char *c[15]`| `char **c` 指针的指针|
        |数组指针（行指针）`char (*c)[64]`| `char (*c)[64]` 不改变|
        |指针的指针 `char **c`| `char **c` 不改变|
- 代码

            func1(int fruit[2][3][4]) { ; }
            func2(int fruit[][3][4]) { ; }
            func3(int (*fruit)[3][4]) { ; }

9. 向函数传递一个一位数组：增加一个额外的参数或者赋予数组最后一个元素一个特殊的值

10. 向函数传递一个普通的多维数组：必须提供除了最左边一维以外多有维的长度。即多维数组最主要的一维长度不必显式书写。


## 链接
1. strings实用程序可帮助从二进制文件内部查看程序可能产生的错误。

3. `cc -S -Xc banana.c`, `-S`选项使编译器停在汇编阶段，`-Xc`选项告诉编译器拒绝任何不符合ANSI C的代码结构
链接

4. 链接器（linker）
- 编译器中单独分离出来的程序包括：预处理器（preprocessor）、语法和语义检查器（syntactic and semantic checker）、代码生成器（code generator）、汇编程序（assembler）、优化器（optimizer）、链接器（linker）等。
- `-#`选项查看编译过程的各个独立阶段
- 通过给编译器驱动器一个特殊的`-W`选项（表示传递这个选项到那个阶段）向各个阶段传递选项信息，如`cc -W1, -m mainc > main.linker.map`，其中`-m`选项是传递给链接-载入器的，要求其产生连接器映像

5. 动态链接的主要目的就是把程序与它们使用的特定函数库版本中分离出来。这种介于应用程序和函数库二进制可执行文件所提供的服务之间的接口，称之为二进制接口（Application Binary Interface, ABI）
- 动态链接库，可由`ld`创建，后缀名约定以`.so`结尾，表示shared object，简单的可以通过cc的`-G`选项来创建
- 动态链接必须保证4个特定的函数库：libc（C运行时库）, libsys（其他系统函数）, libX（X Windowing), libnsl（网络服务）


7. 静态库称作为archive，通过`ar`来创建和更新，后缀名约定以`.a`结尾
    - 生成示例
        `cc -o libfruit.so -G tomoto.c`
    - 使用示例
        `cc test.c -L/home/swf -R/home/swf -lfruit`, `-L`, `-R` 分别告诉链接器在链接和运行时从哪个目录找需要链接的函数库

8. `-lthread`选项告诉编译链接到libthread.so，即`libname.so`对应于`-lname`

9. 编译器希望在确定的目录下找到库，链接时一般使用`-Lpathname`，`-Rpathname`，默认读取系统变量`LD_LIBRARY_PATH`和`LD_RUN_PATH`等

10. 文件名通常不与其所对应的函数库名相似

    |`#include`文件名|库路径名|所用的编译器选项|
    |:---------------:|------:|--------------:|
    |math.h|/usr/lib/libm.so|`-lm`|
    |math.h|/usr/lib/libm.a|`-dn -lm`|
    |stdio.oh|/usr/lib/libc.so|自动链接|
    |/usr/openwin/include/X11.h|/usr/openwin/lib/libX11.so|`-L/usr/openwin/lib -lX11`|
    |thread.h|/usr/lib/libthread.so|`-lthread`|
    |curses.h|/usr/lib/curses.a|`-lcurses`|
    |sys/socker.h|/usr/lib/libsocket.so|`-lsocket`|

11. `nm`工具可列出函数库中包含的函数, `nm libc.so | grep xdr_reference `

12. 始终将`-l`函数库选项放在编译命令的最右边，很多人习惯<命令><选项><文件>，但链接器采用这个容易引起混淆

13. Interpositioning就是通过编写与库函数同名的函数来取代该库函数的行为。

14. 准则：不要让程序中的任何符号成为全局的，除非有意将其作为程序的接口之一。很多头文件中的函数有存储类型符static

15. 避免使用的标识符（P104）

16. ANSI C 标准规定，对于外部标识符，编译器可以自行定义，使其不区分字母大小写。同时，外部标识符的前六个字符必须与其他标识符不同。

17. `a.out` 是 assemble output （汇编程序输出）的缩写

18. UNIX中可执行文件是以一种特殊的方式加上标签的，这样系统就能够确认它的属性。
    - 为重要的数字定义标签，用独特的数字唯一地标识数据，是一种普遍采用的编程技。
    - 标签所定义的数字通常被称为“神奇”数字

19. ELF （Executable and Linking Format）可执行文件和链接格式。UNIX中可`man a.out` 查看有关UNIX系统所使用的格式的信息。

## 运行

### 1. 概念
1. 段 segments
- unix中，段表示一个二进制文件相关的内容块
- Intel x86的内存模型中，段表示一个设计的结果，其中地址空间并非一个整体，而是分成了一些64K大小的区域，称之为段。

2. `size a.out` 可查看可执行文件中的三个段（文本段、数据段、bss段）

3. 查看可执行文件的内容，`nm`和`dump`工具也可以

4. BSS段这个名字是“Block Started by Symble” 由符号开始的块的缩写，其不保存在目标文件中（除了记录BSS段在运行时所需要的大小）。

5. a.out
- 数据段保存在目标文件中，存储初始化的全局和静态变量以及它们的值
- BSS段不保存在目标文件中（除了记录BSS段在运行时所需要的大小）
- 文本段是最容易受优化措施影响的段，存储可执行文件的指令
- a.out文件的大小受调试状态下编译的影响，但段不受影响

6. 在操作系统中段就是一片连续的虚拟地址

7. 函数调用：过程活动记录 （可参考CSAPP）
- 头文件`/usr/include/sys/frame.h`描述了过程活动记录在unix系统中的样子

8. 悬挂指针 dangling pointer

9. 存储类型关键字：
- static 可保证数据存在数据段中而不是堆栈中
- auto 通常由编译器设计者使用，用于标记符号表的条目——它表示“在进入该块之后，自动分配存储”（与编译时静态分配或在堆上动态分配不同）

            register int filbert;
            auto     int almond;
            static   int hazel;

10. 控制
- `setjmp()`和`longjmp()`是通过操作过程活动记录来完成的，其在C++中变异为更普通的异常处理机制`catch`和`throw` （P128）
- goto语言不能跳出C语言当前的函数
- longjmp()可以跳回到曾经到过的地方
- setjmp()/longjmp()最大的用途是错误恢复

            #inlcude <setjmp.h>
            jump_buf buf;

            banna(){
                printf("in banna() \n");
                longjmp(buf, 1);
                /*以下代码不会被执行*/
                printf("you'll never see this, because i longjmp'd ");
            }

            main()
            {
                if(setjmp(buf)) 
                    printf("back in main\n");
                else {
                    printf("first time through\n");
                    banana();
                }
            }

11. 有用的C语言工具
- 检查源码的工具：indent(C程序美化器，和cb类似), cflow(打印程序中调用者／被调用着的关系) cscope(一个基于ASCII码C程序的交互式浏览器), ctags(创建一个标签文件), lint(C程序检查器), vgrind(格式器，用于打印漂亮的C列表) 
- 检查可执行文件的工具：dis(目标代码反汇编工具), `dump -Lv`(打印动态链接信息), ldd(打印文件所需的动态)， nm(打印目标文件的符号列表)， strings(查看嵌入二进制文件中的字符串), sum(打印文件的校验和与程序块计数)
- 帮助调试工具：truss(打印可执行文件所进行的系统调用), ps, ctrace(修改你的源文件，文件执行时按行打印), debugger(交互式调试器), file
- 性能优化工具：tcov(显示每条语句执行次数的计数), time(实际时间和CPU时间), prof(每隔程序所消耗时间的百分比), gprof(调用图配置数据)

12. 标准的代码优化技巧：消除循环；函数代码就地扩展；公共子表达式消除、改进寄存器分配、省略运行时对数组边界的检查、循环不变量代码移动（loop-invariant code motion）、操作符长度削减（指针操作符转变为乘法操作，把乘法操作转变为位移操作或假发操作）

13. 8086中有代码寄存器CS，数据寄存器DS，堆栈寄存器SS

14. 磁盘制造商都是采用十进制数而不是二进制数来表示磁盘的容量

15. billion和trillion在美语和英语中的意义不一样，美语中分别是十亿和一万亿，英语中是一万亿和100亿亿

16. `/usr/ucb/pagesize`可查看系统中页面大小，页就是操作系统在磁盘和内存之间移来移去或进行保护的单位。

17. 用于管理内存的调用是：
- malloc 和 free —— 从堆中获取内存以及把内存返回给堆
- brk 和 sbrk —— 调用数据段的大小至一个绝对值


### 2. 运行错误

1. 堆经常出现的问题：
- 释放或改写仍在使用的内存（称为“内存损坏”）
- 未释放不再使用的内存（称为“内存泄漏”）

2. 检测内存泄漏：
- `netstat`, `vmstat`查看
- `swap -s`查看交换空间大小
- `ps -lu 用户名` 显示所有进程大小，其中SZ表示的是进程页面数
- 使用第三方的malloc库

3. 程序运行时的常见错误：
- bus error (core dumped) 总线错误（信息已转储）
    - 总线错误基本是由于未对齐的读或写操作引起的。（出现未对齐的内存访问请求时，被堵塞的组件是地址总线）
    - 对齐， alignment, 数据项只能存储在地址是数据项大小的整数倍的内存位置上
    - 只要对齐了，就能保证一个原子数据想不会跨越一个页或Cache块的边界

                union { char a[10];
                        int i;
                    } u;
                int *p = (int *)&(u.a[1]);
                *p = 17; // p中未对齐的地址会引起一个总线错误！

- segmentation fault (coure dumped) 段错误
    - 段错误或段违规(segmentation violation)是由于内存管理单元的异常导致，而该异常通常是由于解除引用一个未初始化或非法值的指针引起的
    - 如果未初始化的指针恰好有未对齐的值，它将产生总线错误而不是段错误
    - 导致段错误的直接原因
        1. 解除引用一个包含非法值的指针
        2. 解除引用一个空指针
        3. 未得到正确的权限时进行访问。如往只读的文本段存储值就会引起段错误
        4. 用完了堆栈或栈空间
    - 导致段错误的常见编程错误
        1. 坏指针值错误（指针赋值前就被引用了；向库函数传递一个坏指针；对指针进行释放后再访问其内容），`free(p); p = NULL;` 这样，在指针释放后继续使用该指针，至少程序能在终止前进行core dump
        2. 改写错误(overwrite) ：越过数组边界谢姑数据，在动态分配的内存两端写入数据，改写一些堆管理数据结构
        3. 指针释放引起的错误：释放一个内存块两次，释放一块未曾使用malloc分配的内存，释放仍在使用的内存; 循环释放链表就容易出现这种情况

4. 缺省情况下，会进行信息转储，当然也可以这是特定的信号处理程序（signal handler）
- 系统不支持在信号处理程序内部调用库函数（除非严格符合标准所限制的条件）

5. “core dump” 来源于，以前所有的内存是用铁氧化物圆环（也就是core，指磁芯）制造的。

6. `limit stacksize 10` 可在C-shell中调整堆栈的大小

7. `dbx`工具可用来查看段错误等信息

### 3. 其他

1. 根据位模式构筑图形
一个优雅的`#define`定义

        #define X )*2+1
        #define _ )*2
        #define s ((((((((((((((((0 /*用于构建16位宽的图形*/
        
        static unsigned short stopwatch[] = 
        {
            s _ _ _ _ X X X X X X _ _ _ X X _,
            s _ _ _ X X X X X X X X X _ X X X,
            ....
            ....
        }

2. 类型提升：char, bit-filed, enum , unsigned char, short, unsigned short 在表达式中，其会提升为int（前提是int能完整地容纳原先的数据）；参数也会被提升

3. 如果使用了原型，缺省参数提升就不会发生；如果参数声明为char，则实际传入的也是char
- ANSI C 函数原型的目的就是使C语言称为一种更加可靠的语言，消除型参和实参之间类型不匹配的问题。（但其并没有排他的使用K&R C 函数原型）
- 参数提升是为了简化编译器，老式的编译器仅接受int, double 和指针类型的参数

4. 不需要按回车就能得到一个字符
- C编译器中的`getch()`, `getche()`
- 操作系统发送“字符已经就绪”的信号后，需要捕捉的信号是SIGPOLL

5. 调用库函数之后检查errno是个好的习惯

> C 语言实现有限状态机 FSM



## 秘密题

0. 不使用临时变量交换两个值(两种方法)

        a ^= b;
        b ^= a;
        a ^= b;

1. 怎样检测到链表中存在循环

2. C语言中不同增值语句的区别（考虑变量和指针等多种情况）

        x = x + 1;
        ++x;
        x++;
        x += 1;

3. 库函数调用和系统调用的区别
    - 典型的C函数库：system, fprintf, malloc
    - 典型的系统调用：fork, chdir, write, brk
    - 函数库调用：在所有ANSI C编译器版本中，C函数库是相同的；语言或应用程序的一部分；用户地址空间执行；调用函数库中的一个程序；运行时间属于用户时间；属于过程调用，开销较小；C函数库libc中大约300个程序；记录于unix手册第三节
    - 系统调用：各个操作系统的系统调用不相同；操作系统的一部分；内核地址空间执行；调用系统内核的服务；运行时间属于系统时间；需要内核上下文切换，开销较大；在UNIX中大约有90个系统调用

4. 文件描述符和文件指针有何不同
    - 文件描述符（用于索引开放文件的每个进程表 per-process table-of-open-files）就是开放文件的每个进程表的一个偏移量（如3），其用于unix系统调用中，用于标识文件
    - FILE 指针保存了一个FILE结构的地址。FILE结构用于表示开放的I/O流。它用于ANSI C标准I/O库中，用于标识文件 (stdio.h)，结构内容依平台而不一样，在unix中通常是开放文件的每个进程表的一个条目！

5. 编写代码，确定一个变量是有符号数还是无符号数
    - 如下代码能适用于K&R C，但由于类型提升无法适用于ANSI C

            #define ISUNSIGNED(a) (a >= 0 && ~a >= 0)
            或
            #define ISUNSIGNED(type) ((type)0 - 1 > 0)

6. 打印一颗二叉树的时间复杂度是多少？
    - 如果execvc 系统调用成功，它将返回什么？（失败才会返回）

7. 从文件中随机提取一个字符串
    - 对字符串进行计数，并记录每个字符串的偏移位置
    - 如果只能顺序遍历文件一次，且不能实用表格来存储字符串的偏移位置，怎么计算？（提示：应用概率）

8. 如何用气压计测量建筑物的高度


## 你懂C，所以C++不在话下


