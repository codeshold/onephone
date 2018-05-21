---
title: 你懂C，所以C++不在话下
layout: post
author: WenfengShi
category: 技术
tags: [c/c++]
---
博客链接: [http://codeshold.me/2017/02/c_and_cplusplus.html](http://codeshold.me/2017/02/c_and_cplusplus.html)

> 标题源自《C专家编程》，内容总结也参考该书

## 面向对象C++

> OOP: object-oriented paradiam

1. 面向对象编程的特点就是继承和动态绑定。C++通过类的派生支持继承，通过虚拟函数支持动态绑定。虚拟函数提供了一种封装`类体系实现细节`的方法。

2. 概念
    - 抽象（abstraction）
        - 提取事物的本质，隐藏不相关的细节，向外部提供一个“黑盒子”
        - C语言也允许抽象（通过`struct, enum`来支持），但C不允许重定义操作符，但C存在操作符重载（如`*`）
    - 类（class）
        - 类就是用户类型加上所有对该类进行的操作
    - 对象（object）
    - 封装（encapsulation）
        - 把相关的类型、数据、函数组合在一起，组成一个类
        - 非OOP语言没有完备的机制来实现封装
        - 即类把代码和相关数据封装在一起
        - C语言是强类型（不会进行潜在的类型转化）
    - 继承（inheritance）
        - `C语言无继承概念，也无法模拟这个特性`
        - 复用已经定义的操作


3. 访问控制
    - 后面可以跟一大堆声明
        - public：属于public的声明在类的外部可见，且可进行设置、调用和操作
        - protected： 属于protected的声明只能由该类本身的函数以及从该类派生出的类的函数是使用
        - private：属于private的声明只能被该类的成员函数使用，但`private的声明在外部可见的，这是不能访问`
    - 每次只能用于一条声明
        - virtual
        - friend
            - 属于friend的函数不属于类的成员函数
            - 但可以像成员函数一样访问类的private和protected成员
            - friend可以是一个函数，也可以是一个类

4. 成员函数的形式，`::`为全局范围分解符

        返回值 类名::函数名（参数泪飙）{/*实现*/}

5. 构造函数和析构函数很重要，因为类的任何外部函数都不能访问类的private函数，因此需要一些特权函数来负责对象的创建、初始化等工作
    - 构造函数的名字总和类的名字相同
    - 析构函数的名字以`~`开头


## C & C++

1. C语言的哲学`一切工作自己负责`，即语言中的任何部分都不应该通过隐藏的运行程序来实现

2. C语言中所有的类型，要不是`组合类型`(数组、结构等)，要不是`标量类型`（每个值都是原子值）

3. C++嵌套
    - 把一个类嵌入到另一类的内部，它并不具有特殊的权限
    - 嵌套通常被用来实现容器类（链表、散列表、队列等）
    - C++的模版特性(template)也被用于容器的实现

4. C++重载
    - 作用于不同类型的同一个操作具有相同的名字， C语言中也存在
    - C语言只有传值调用，而C++有传值和传址(`&`)两种形式

5. C++输入／输出
    - C++用`<<`, `>>`来分别表示C语言中的`putchar()`, `getchar()`等函数
    - C++对`<<`, `>>`也进行了重载，如果左边操作数是一个stream，则该操作符被解释为I/O操作
    - 可以在C++中使用`stdio.h`操作

6. C++多态(polymorphism)
    - 支持相关的对象具有不同的成员函数（但原型相同）
    - 允许对象和适当的成员函数进行运行时绑定（即由运行时系统进行解析调用哪一个函数）
    - 虚函数实现
    - 多态和interposing都允许一个用标识符来命令多个函数
    - interposing，它在编译时把所有用该标识符命令的函数绑定到一个函数中
    - 多态，在运行时根据对象的类属关系来决定调用哪一个函数

## 其他要点

1. 异常(exception)，类似于C中的`setjmp()`, `longjmp()`
2. 模版(template)，支持参数化类型

    template<class T> T min(T, a, b) { return (a < b) ? a :b; }

3. 内联函数(inline)，规定某个函数以指令流的形式展开而不是函数调用的方式
4. new和delete，能够自动完成sizeof工作，并自动调用合适的构造函数、解析函数
5. 传引用调用(call-by-reference，即传地址调用)，C语言中只有传值调用
6. `char[3]="bob"`在C语言中是合法的，C++中会报错
7. C++中字符常量是char，C中是int, `sizeof('A')`


> 语言中的正交性(orthogonality)：不同的特性遵循同一个基本原则的程度


## 启发

> 详细解说《C专家编程》P269
 
1. protect abstract vitrual base pure virtual private destructor是什么？
    - protect abstract virtual base 派生而来的pure virtual private destructor
    - private destructor 就是一个对象离开其生存范围时所调用的函数
    - pure virtual 函数本身没有代码，但它可以通过继承作为派生类虚拟函数实现的指导准则
    - pure virtual destructor 只有被派生类覆盖之后才有意义（析构函数能自动进行缺省的清理操作）
    - abstract virtual base 表示基类是被多个多重继承的类共享（即虚基类）
    - protected abstract virtual base 类是以protected的形式继承的。该类的后序类可以访问父类的信息，但其他的不行
2. protect abstract vitrual base pure virtual private destructor就是一个析构函数
    - 只能被该类的成员函数或友元函数调用
    - 在声明它的基类中没有定义，但它将在派生类中定义
    - 它（指派生类的）共享一个多重继承的积累
    - 它（指基类的）以protected方式继承


