---
title: C陷阱与缺陷--笔记
layout: post
author: WenfengShi
category: 技术
tags: [c/c++, 读书笔记]
---
原文链接:[http://codeshold.me/2017/01/c_trapsandpitfalls.html](http://codeshold.me/2017/01/c_trapsandpitfalls.html)


> FORTAN: formula translator 公式翻译程式语言
> Fibonacci: 斐波那契


## 词法陷阱

> 为什么`n-->`的含义是`n-- > 0`, 而不是`n- ->0`?  
> `a+++++b`的含义是?  


1. 赋值操作符为什么是`=`而不是`==`?
- 程序中的赋值操作相对于比较操作更多，所以用`=`来表示

2. ASCII码
- [参考](http://baike.baidu.com/link?url=RSC7ubRdPIXfUmnt3uxlJwKP9LbNpYlaRDxYdeA-yz1DX8tITg8m9OUR4yqRQvuwFONRI3sqIF09J1XicH5j7Bs6mjnIQDJhYN46cMZ4hiOOpSPtjpaDYAB5FKdQwV7NxwXIzXpxlkuOCjnjfjdHD_)
- 空格(32/0x20, 对应于`^@`), 0(48/0x30), A(65/0x41), a(97/0x61)
- 换行LF(0x0A), 回车CR(0x0D, 对应于`^M`)
- vim下的normal模式下`ga`可查看ascii码

3. 贪心原则?
- 每个符号(token)应包含尽可能多的字符
- "如果输入流截止至某个字符之前都已经被分解为一个个符号，那么下一个符号将包括从该字符之后可能组成的一个符号的最长字符串"
- `y = x/*p`, `y = x / *p`, `y = x/(*p)`?
- `a---b`?

4. `10`是否能表示成`010`?
- 一个表示十进制，一个表示八进制

5. 单引号括起来的一个字符表示一个整数，双引号括起来的一个字符代表一个指针

6. C语言的定义并不允许嵌套注释，但C编译器可以支持

7. `a++`的结果不能作为左值(见**补充知识点**)

8. C语言允许初始化列表中出现多余的逗号：能让自动化的程序设计工具方便地处理很大的初始化列表（每行的格式一样）

## 语法陷阱

> C语言允许初始化列表中多余的逗号，例如 `int days[] = {1, 2, 3, 4,};` 为什么有这种特性？


1. 函数声明
- 两部分组成：类型 ＋ 一组类似表达式的声明符(declarator), 后者的求值应返回一个给定类型的结果！
- `float f, f;` 等同于 `float ((f)), (g);`
- `float *g(), (*h)()` 后者是一个函数指针
- 类型转换符：`float (*h)()`(h是一个指向返回值类型为浮点类型的函数的指针) 声明对应的类型转换符为`(float (*)())`
- `typedef void (*funcptr)(); (*(funcptr)0)();` 等同于 `(*(void(*)())0)();` 显示调用开机子例程
- signal.h 中的`typedef void (*HANDLER)(int); HANDLER singal(int, HANDLER)`

2. 运算符优先级，结合性
- 任何一个逻辑运算符的优先级低于任何一个关系运算符（有关系的人排在前面）
- 移位运算符的优先级比算术运算符要低，但比关系运算符要高
- 关系运算符的优先级并不相同，`!=`和`==`要低于其他的
- 任何两个逻辑运算符都有不同的优先级， 按位运算符比**顺序运算符**要高
- 结合性为自右向左的有：单目运算；三目运算；assignments
- [详细参考](http://baike.baidu.com/link?url=neAScCNzgKjoeqTSAZ_wlzGRyGJkbQzPYo-OWpQFC_Ltd9qWWHtEPfDosHLPZ7Wwp9nMSIk28mOg7NeDxMRgsJCphSJJ99LjBCosSb8NqGjdLFRA63vsan6KtH-7akNt0XnhIXs0cwaTr-M6BOheZq)，前置和后置`++`, `--`的区别见文末**补充知识点**

3. switch语句中的case和break(C的特色)
- 在没有break的地方加上注释！

4. 函数调用要包括函数列表
- 即使函数不带参数，但调用时也得包括函数列表， `f()`是一个调用语句，而`f`仅计算函数f的地址却不调用该函数

5. "悬挂"else
- else 始终与同一对括号内最近的未匹配的if结合(所以if后面加`{}`)
- 一些程序设计语言在if中使用**收尾定界符**来显示地说明，如shell中的`if...fi`

``` c
if (x == 0)
        if (y == 0) error();
else{
        z = z + y;
        f(&z);
    }

```

## 语义陷阱


> 写出`void memcpy(char *dest, const char *source, int k)`函数， 写一个函数` void bufwrite(char *p, int n)`来一次转移一批字符到缓冲区，必要时通过函数flushbuffer()刷新缓存。
> 程序按一定顺序生成一些整数，并将这些整数按列出输出，程序的输出可能包括若干页的整数，每页包括NCOLS列，每列又包括NROWS个元素，每个元素就是一个待输出的整数，写出输出程序(printnum(), printnl(), printpage()分别是打印对应的内容)
> 

1. 数组和指针
- C语言中只有一维数组，对于一个数组只能做两件事：确定数组的大小（C99标准允许变长数组VLA）；获取指向数组下标为0的元素的指针

2. 作为参数的数组声明
- C语言中，我们无法将一个数组作为函数参数直接传递
- C语言会自动地将作为参数的数组声明转换为相应的指针声明

3. 避免"提喻法"synecdoche
- ANSI C 标准中禁止对string literal 做出修改
- K&R C 中对这一问题的说明是，试图修改字符串常量的行为是为定义的

4. 空指针不能解除引用
- 编译器保证由0转换而来的指针不等于任何有效的指针，即NULL
- 当常数0被转化为指针使用时，其绝不能被解除引用(dereference)，即`if (p == (char *) 0)`是合法的，但`if (strcmp(p, (char *)0) == 0)...`非法
- p是空指针，则`printf(p)`和`printf("%s", p)`的行为均为未定义

5. 不对称边界
- "off-by-one error" 差一错误
- 左闭右开, `for (i = 0; i < 10; i++)`, 而不写成`for (i = 0; i <= 9 ; i++)`
- 入界点（可用序列中的第一个元素为0），出界点（不可用序列中的第一个元素）为10
- `--n >= 0`至少要与等效的`n-- >0`一样快或更快，第一个结果先将n减1，再将结果与0比较；第二个表达式则先保存n，从n中减1，然后比较保存值与0的大小()
- 坚持“不对称原则”
- **数组中实际不存在的“溢界”元素的地址位于数组所占内存之后，这个地址可以用于赋值和比较，但如果引用该元素，则非法**

6. 求值顺序
- 分隔函数参数的逗号并非逗号运算符
- 涉及求值顺序的仅有 `&&  ||  ?:  ,`, 其中`,`特殊，其先丢弃再求值

7. 整数溢出
- 无符号运算没有溢出一说
- 如果算数运算中一个操作数是有符号整数，另一个无符号整数，则均会转换为无符号整数
- 如果两个都是有符号整数，则溢出结果未定义
- 正确检测溢出的方法`if ((unsigned)a +(unsigned)b < INT_MAX)` 或 `if (a < INT_MAX - b)`, INT_MAX在`<limits.h>`中


## 连接

1. 外部对象
- 外部对象(external object)，每个外部代表着机器内存中的某个部分，并通过一个外部名称来识别。
- `extern int a;` 显示的说明a的存储空间是在程序的其他的地方分配

2. static 修饰符能够减少命名冲突

3. 形参、实参与返回值
- 任何C函数都含有一个形参列表，该变量在函数调用时被初始化
- 任何C函数都有返回类型，要么是void，要么是函数生成结果的类型
- C语言中的形参和实参匹配的规则有些复杂，ANSI C允许程序在声明时指定函数的参数类型
- 如果一个函数没有float、short、char类型的参数，在其声明中可以省略参数类型说明
- 对于类似的声明`double square()`，float类型的参数会自动转化为double类型，short和char类型的参数会自动转换为int类型

4. 检查外部类型
- `char filename[] = "/etc/passwd";`, `extern char* filename;`，前者中filename的类型为“字符数组”，后者的类型为“字符指针”，这两个对filename的声明使用存储空间的方式不同(图不一样)
- 应修改为`char filename[] = "/etc/passwd";`, `extern char filename[];` 或者 `char* filename = "/etc/passwd";`(文件一), `extern char* filename;`(文件二)

5. Endian的意思是“数据在内存中的字节排列顺序”， 表示一个字在内存中或传送过程中的字节顺序。(Little endian 将低序字节存储在起始地址, Big endian 则相反)


## 库函数

> 当一个程序异常终止时，程序输出的最后几行常常会丢失，原因？如何解决这个问题？

1. 缓冲输出与内存分配
- `setbuf()`

2. 使用errno检测错误
- 建议使用`if(返回的错误值){检查 errno}`的方式
- 并未强制要求库函数实现errno机制，同时errno的值是前一个执行失败的库函数设置的值

3. signal
- signal也不总是安全的
- 让signal处理函数尽可能的简单，一般是打印出一条错误消息(设置一个标志)再返回

4. getchar(putchar)经常被实现为宏

## 预处理器

> “表达式” `(x) ((x)-1)` 能否成为一个合法的C表达式？
> 使用宏实现max的一个版本，其中max的参数都是整数，要求在宏max的定义中这些整型参数只被求值一次

1. 显示常量 manifest constant 

2. 宏定义
- 宏这是对程序的文本起作用
- `#define f(x) ((x)-1)` 注意空格, `#define FOOTYPE struct foo`
- 宏不是类型定义
- 宏不是语句

3. `do {...} while(0)`
- 帮助定义复杂的宏以避免错误，同时使用宏可添加`;`，符合代码习惯
- 避免使用goto控制流程(break)
- 避免由宏引起的警告, `#define EMPTYMICRO do{}while(0)`


## 可移植性缺陷

> 实现atol

1. 对应C语言的标准

2. 标识符名称的限制
- ANSI C 标准所能保证的是， **C实现必须能够区别出前6个字符不同的外部名称**(并未区分大小写)


3. 字符是有符号整数还是无符号
- 错误认识：`(unsigned)c`，其在将字符c转化为无符号整数时，c将首先被转化为int型整数，可能会达到非预期的结果
- 正确的使用: `(unsigned char)c`

4. 移位运算
- 空位用什么填充？

5. 大小写转化
- `#define toupper(c) ((c)+'A'-'a')` 和 `#define tolower(c) ((c)+'a'-'A')`

6. 并非所有的C实现在某块内存被释放后还能较长时间的保留之

7. `"0123456789"[n % 10]`


## 附录

1. printf
- %之后的称为格式码(指明了格式转换的类型)
- 修饰符， %和格式码之间 `%3.1g`（宽度修饰符、精度修饰符等）
- 标志， %和域宽修饰符之间，如`%-14s`(左对齐), `%+d` 
- `#`对数值的输出格式进行微调,`0%o`和`%#o`，针对数值0，其分别打印00和0；`%#x`和`%#X`打印出的16进制数前加上0x或0X；#用在浮点数中则其要求小数点必须打印出来（即使小数点后没有数字），如果用于%g或%G格式项，打印出的数值尾缀的0 将不会被去掉
- printf允许间接指定域宽，只需用`*`替换域宽修饰符或精度修饰符或两者，`printf("%*.*s", 12, 5, str);`
- `printf("%*%\n", n)` 打印出n-1个空白字符，后面再跟一个%符号
- 新增格式码：%p 打印出该指针所指向的地址； %n 指出已经打印的字符数，这个数被存储在对应参数所指向的整数中（一个整型指针），如下`int n; printf("hello\n%n", &n)`

2. varargs, stdarg
- varargs.h 中的 `va_alist, va_dcl, va_list, va_start, va_arg, va_end`
- stdarg.h 处理可变参数列表
- `void error(char *, ...);`

``` c
#include <stdio.h>
#include <stdarg.h>

void error(char *format, ...)
{
    va_list ap;
    va_start(ap, format);
    fprintf(stderr, "error: ");
    vfprintf(stderr, format, ap);
    va_end(ap);
    fprintf(stderr, "\n");
    exit(1);
}

```

``` c
#include <stdarg.h>

int
printf(char *format, ...)
{
    va_list ap;
    int n;

    va_start(ap, format);
    n = vprintf(format, ap);
    va_end(ap);
    return n;
}

```

## 补充知识点

### 1. i++ 和 ++i

1. 区别
  - i++ 返回原来的值；++i 返回加一之后的值
  - i++ 不能当作左值，而i++可以

2. 左值&右值
  - 左值是对应内存中有确定存储地址的对象的表达式的值，而右值是所有不是左值的表达式的值。
  - 一般的可以和赋值联系起来，但左值和右值的根本区别在于**是否允许取地址运算符&**获得对应的内存地址

3. 简单的实现(C++)

``` c++
// 前缀形式
int& int::operator++() //返回值是一个引用，就是说函数返回值也可以作为一个左值使用
{//函数本身无参，意味着是在自身空间内增加1的
  *this += 1;  // 增加
  return *this;  // 取回值
}

//后缀形式:
const int int::operator++(int) //返回值是一个非左值型的，与前缀形式的差别所在
{//函数带参，说明有另外的空间开辟
  int oldValue = *this;  // 取回值
  ++(*this);  // 增加
  return oldValue;  // 返回被取回的值
}
```
