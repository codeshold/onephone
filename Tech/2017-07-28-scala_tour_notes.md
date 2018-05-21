---
title: Scala Tour 学习总结
layout: post
author: WenfengShi
category: 技术
tags: [scala]
---
博客链接: [http://codeshold.me/2017/07/scala_tour_note.html](http://codeshold.me/2017/07/scala_tour_note.html)


> 因实习，需要了解数据分析方面的知识，需要学习Spark、Scala，花了一天的时间过了一下scala教程（总结即是本文），但个人推荐先从《快学Scala+中文版》这本书开始看（正在看...）这个更适合入门…… 无奈自己后知后觉了……
Tour 学习链接（自己主要是看中文）：
1. [TOUR OF SCALA (scala-lang.org)](http://docs.scala-lang.org/tour/tour-of-scala.html)
2. [Scala教程 (runoob.com)](http://www.runoob.com/scala/scala-tutorial.html) 



## 基本语法
- Scala 的命名规则采用和 Java 类似的 camel 命名规则，首字符小写，比如 toString。类名的首字符还是使用大写。
- 区分大小写 -  Scala是大小写敏感的
- 程序文件的名称应该与对象名称完全匹配（运行文件的名字及其内部的object的名字）
- `def main(args: Array[String])`, Scala程序从main()方法开始处理
- Scala是面向行的语言，可有分号或者无分号
- Scala 使用 package 关键字定义包, 将代码定义到某个包中有两种方式

    ```scala
    package com.swf
    class HelloWorld
    ------------------------
    package com.swf {
        class HelloWorld
    }
    ```
- Scala 使用 import 关键字引用包。默认情况下，Scala 总会引入 `java.lang._` 、 `scala._` 和 `Predef._`，这里也能解释，为什么以scala开头的包，在使用时都是省去scala。
 
    ```scala
    import java.awt.Color // import Color 
    import java.awt._ // import all the members
    import java.awt.{Font, Color} // import members via selector 选择器
    import java.until.{HashMap => JavaHashMap}  // rename members
    import java.util.{HashMap => _, _}  // 引入util包的所有成员，但是HashMap被隐藏
    
    def handle(evt: event.ActionEvent) {
        Color.
    }
    ```

## 数据类型 & 变量
 1. `Unit` 表示无值，和其他语言中void等同。用作不返回任何结果的方法的结果类型。Unit只有一个实例值，写成`()`
 2. `Nothing` 类型在Scala的类层级的最低端；它是任何其他类型的**子类型**。
 3. `Any` 是所有其他类的**超类**
 4. `AnyRef` 类是Scala里所有**引用类(reference class)的基类**
 5. Byte, Short, Int 等上述的数据类型都是对象，也就是说scala没有java中的原生类型。在scala是可以对数字等基础类型调用方法的。
 6. 字面量 [进一步了解](https://my.oschina.net/fhd/blog/274019)
     - 浮点型字面量 `0.0, 0f, 1.0e100`
     - 布尔型字面量 `true, false`
     - 符号字面量被写成：`'<标识符>`这种字面量被映射成预定义类`scala.Symbol`的实例, 符号字面量除了显示名字之外，什么都不能做
     - `'\n', "hello", """hello"""` 字符、字符串、多行字符
7. 空值是 `scala.Null` 类型。
    - `scala.Null`和`scala.Nothing`是用统一的方式处理Scala面向对象类型系统的某些**"边界情况"**的特殊类型。
    - `Null类`是null引用对象的类型，它是每个引用类（继承自AnyRef的类）的子类。Null不兼容值类型。

    ```scala
    val myVal : String = "Foo" // 申明常量，值不能修改
    var myVar : String = "Foo"  // 申请变量，值可以修改
    
    // 变量类型申明
    var VariableName : DataType [= Initial Value]
    val VariableName : DataType [= Initial Value]
    
    // 变量类型引用
    var myVar = 10
    val myVal = "hello, scala!"
    
    // 多变量申明
    val xmax, ymax = 100
    val pa = (40, "Foo")
    --------
    scala> val x, y = 1, 2  // 和python不同 !!!!!!
    <console>:1: error: ';' expected but ',' found.
    val x, y = 1, 2
                ^
    scala> val x, y = (1, 2)
    x: (Int, Int) = (1,2)
    y: (Int, Int) = (1,2)
    
    scala> val x, y = 1
    x: Int = 1
    y: Int = 1
    ```

## 访问修饰符 & 运算符 & 控制语句
1. Scala 访问修饰符基本和Java的一样，分别有：private，protected，public
    - 用private关键字修饰，带有此标记的成员仅在包含了成员定义的类或对象内部可见，同样的规则还适用内部类。
    - 在 scala 中，对保护（Protected）成员的访问比 java 更严格一些。因为它**只允许保护成员在定义了该成员的的类的子类中被访问**。而在java中，用protected关键字修饰的成员，除了定义了该成员的类的子类可以访问，**同一个包里的其他类也可以进行访问**。
    - 作用域保护：`private[x], protected[x]` 这里的x指代某个所属的包、类或单例对象。如果写成private[x],读作`"这个成员除了对[…]中的类(或[…]中的包中的类)及它们的伴生对象可见外，对其它所有类都是private`。
 
    ```scala
    package bobsrockets{
        package navigation{
            private[bobsrockets] class Navigator{   // 对bobsrockets中的对象都可见，其他则是private
                protected[navigation] def useStarChart(){
                    class LegOfJourney{
                        private[Navigator] val distance = 100
                    }
                    private[this] var speed = 200
                }
                package launch{
                    import navigation._     // import all members
                    object Vehicle{
                        private[launch] val guide = new Navigator
                    }
                }
            }
        }
    }
    ```

2. 运算符
    ```
    scala> -8 >>> 1  // 无符号右移!!! 多了个这个
    res6: Int = 2147483644
    
    scala> 8 >>> 1
    res7: Int = 4
    ```

3. 控制语句
    - `if(...){...}else if(){...}else{...}`
    - `while(...){...};`,  `do{...}while(...);`, `for(...){...}`
    - **for** 中的 `<-` 用于为变量赋值, `to, until, if, yield`
 
    ```
    object Test {
        def main(args: Array[String]) {
            var a = 0;
            val numList = List(1, 2, 3, 4, 5, 6, 7)
            for ( a <- 1 to 10 ) {
            }
            for ( a <- 1 to 3; b <- 1 to 3) {
            }
            for ( a <- 1 until 10 ) { //不包含10
            }
            for ( a <- numList ) {  // 循环集合
            }
            for ( a <- numList if a != 3; if a < 8 ) { // 循环中的过滤
                println("Value of a :" + a)
            }
            // 可以将for循环中的返回值作为一个变量存储
            var retVal = for{ a <- numList if a != 3; if a < 8 } yield a
            for( a <- retVal ) {
                println("!!!value of a :" + a)
            }
        }
    }
    ```

## 函数 & 高阶函数 & currying & 偏应用函数
1.  基本概念
    - `def functionName([para list]) : [return type] = { function body; return [expr] }` ,  如果不写`=`和方法的主体，则方法会被隐世的声明为抽象，包含它的类型于是也是一个抽象类型
        ```scala
        object add {
            def addInt( a:Int, b:Int ) : Int = {
                var sum:Int = 0
                sum = a + b
                return sum
            }
        
            def printMe() : Unit = {
                println("hello world!")
            }
        }
        ```

2. **函数概念解析** [runnob.com](http://www.runoob.com/scala/scala-functions.html)
    - 传名调用(call-by-name): Scala解释器支持两种--`call-by-value`和`call-by-name`

        ```scala
        object Test {
            def main(args: Array[String]) {
                println(delay(time()))
            }
            def time() = {
                println("richie")
            }
            def delay(t: => Long) = {   // => 设置传名调用 (放在变量名和变量类型中间)
                println("wfshi")
                t
            }
        ```
        
    - 指定函数参数名, 可变参数， 默认参数， 递归， 嵌套
        ```scala
        object Test {
            def main(args: Array[String]) {
                printInt(b=5, a=3)  // 制定参数名
                printStrings("richie", "wf", "shi")
                println("F(5)" + factorial(5))
                println("addInt" + addInt())
            }

            def printInt(a: Int, b: Int) {
                println("Value of a :" + a)
            }

            // 可变参数
            def printStrings(args: Sting*) = {
                var i: Int = 0
                for(arg <- args) {
                    println("Arg value" + i + arg)
                    i += 1
                }
            }

            // 递归
            def factorial(n: BigInt): BigInt = {
                if (n <= 1)
                    1   // 无return
                else
                    n * factorial(n-1)
            }

            // 默认参数值
            def addInt(a:Int = 5, b:Int = 7) : Int = {
                var sum:Int = 0
                sum = a + b
                return sum
            }
            
            // 函数嵌套
            def factorial(i: Int) {
                def fact(i: Int, accumulator: Int): Int = {
                    if (i <= 1)
                        accumulator // 无return
                    else
                        fact(i-1, i*accumulator)
                    }
                fact(i, 1)
            }
        ```

5. 匿名函数 
    ```scala
        // 匿名函数
        var inc = (x:Int) => x+1 // 下面的简写
        def add2 = new Function1[Int,Int] {
            def apply(x:Int):Int = x+1
        }

        var x = inc(7)-1

        // 可定义多个函数
        var mul = (x: Int, y: Int) => x*y

        // 可以不设置参数
        var userDir = () => {System.getProperty("user.dir")}
    ```

6. **高阶函数**: higher-order function 操作其他函数的函数； 匿名函数
    ```scala
    object Test{
        def main(args: Array[String]){
            println(apply(layout, 10))
        }

        // 函数 f 和 值 v 作为参数，而函数 f 又调用了参数 v 
        def apply(f: Int => String, v: Int) = f(v)

        def layout[A](x: A) = "[" + x.toString() + "]"
    ```

5. **偏应用函数**: 一种表达式，不需要提供函数需要的所有参数，只需要提供部分，或不提供所需参数。
    ```scala
    import java.util.Date

    object Test{
        def main(args: Array[String]) {
            val date = new Date
            
            // 下划线替换缺失的参数列表, 并把这新的函数值的索引赋值给变量
            val logWriteDataBound = log(date, _: String)    

            logWithDateBound("message1")
            logWithDateBound("message2")
        }
        def log(data: Date, message: String) = {
            println(date + "----" + mesage)
        }
    ```

6. **currying** 函数科里化: 将原来接受两个参数的函数变成新的接受一个参数的函数的过程
    ```scala
        def add(x:Int, y:Int) = x+y
        def add(x:Int)(y:Int) = x+y // currying, (y:Int)=>1+y
    ```
    
        
        

## 闭包 closure
- 在计算机科学中，闭包（英语：Closure），又称词法闭包（Lexical Closure）或函数闭包（function closures），是引用了**自由变量**的函数。这个被引用的**自由变量**将和这个函数一同存在，即使已经离开了创造它的环境也不例外。所以，有另一种说法认为闭包是由函数和与其相关的引用环境组合而成的实体。**闭包**在运行时可以有多个实例，不同的引用环境和相同的函数组合可以产生不同的实例。 [wiki链接](https://zh.wikipedia.org/wiki/%E9%97%AD%E5%8C%85)
- **惰性求值**（调用时才执行）, 可以通过环境变量进行交流，可以实现对象系统
- 使用函数调用栈的语言实现闭包比较困难，因而这也说明了为什么大多数实现闭包的语言是基于**垃圾收集机制**——当然，不使用垃圾收集也可以做到
- **闭包是一个函数**，返回值依赖于声明在函数外部的一个或多个变量。
- 闭包通常来讲可以简单的认为是**可以访问一个函数里面局部变量的另外一个函数**。

    ```
    object Test {
        def main(args: Array:[String]) {
            println("muliplier(1) value = " + multiplier(1))
            println("muliplier(2) value = " + multiplier(2))
        }

        var factor = 3
        val multiplier = (i:Int) => i * factor // 定义了一个匿名函数，并赋值给multiplier
    ```


## 字符串 & 数组 & 集合操作 & 迭代器

1. 字符串 [String常用方法 runoob.com](http://www.runoob.com/scala/scala-strings.html)

    ```scala
    val greeting:String = "Hello World!";       // 不可变
    val buf = new StringBuilder; buf += 'a';    // 可变
    
    "a".length
    "a".length()
    "a".concat("b")
    "a" + "b"
    
    printf("%s %d"...)    // 格式化输出
    ```

2. 数组 [常用方法](http://www.runoob.com/scala/scala-arrays.html)

    ```
    var z:Array[String] = new Array[String](3)
    var z = new Array[String](3)
    z(0) = "richiewfshi"; z(1) = "richie"; z(2) = "wfshi"
    
    var z = Array("richie", "wf", "shi")
    z.length
    
    // 多维数组
    var richieMatrix = ofDim[Int](3,3)
    richieMatrix(i)(j) = "xx"
    
    var my = concat(mylist1, mylist2)
    
    import Array._
    var mylist3 = range(1, 100, 50)
    
    // 使用数组方式之前需要 import Array._
    ```
    
4. 集合操作
    针对不可变集合类的每次操作都会返回一个新的集合，同时使原来的集合不发生改变

    ```scala
    val x = List(1, 2, 3, 4)
    val x = Set(1, 3, 5, 7)
    val x = Map("one" -> 1, "two" -> 2, "three" -> 3)  // !!! 
    
    scala> val mymap = {"key1" -> 1; "key2" -> 2}
    mymap: (String, Int) = (key2,2)
    
    val t = new Tuple3(1, 3.14, "richie")   //Tuple3[Int, Int, String]类型，支持的元组最大长度为22
    val t = (1, 3, "wfs")
    // Tuple.productIterator() 迭代输出元组的所有元素
    t.productIterator.foreach(i => println("Value = " + i)
    (1, 2, "swf").toString // Tuple.toString() 将元素组合成一个字符串
    (1, 2).swap
    
    val sum = x._1 + x._2
    
    val x:Option[Int] = Some(5)     // 定义Option, Option[T] 表示有可能包含值的容器，也可能不包含值。
    ```

6. **迭代器**
    Iterator（迭代器）不是一个集合，它是一种用于访问集合的方法。[常用方法](http://www.runoob.com/scala/scala-iterators.html)

    ```
    val it = Iterator("richie", "wf", "shi")    // 用于检测集合中是否还有元素。
    while(it.hasNext) {
        println(it.next())  // 返回迭代器的下一个元素，并且更新迭代器的状态。
    }
    val itmax = it.max
    val itmin = it.min
    val itlen = it.length
    val itsize = it.size
    ```

5. **Option**
    Scala Option(选项)类型用来表示一个值是可选的（有值或无值)。
    `Option[T]` **是一个类型为 T 的可选值的容器**： 如果值存在， Option[T] 就是一个 `Some[T]` ，如果不存在， Option[T] 就是对象 `None` 。[常用方法](http://www.runoob.com/scala/scala-options.html)

    ```
    val myMap: Map[String, String] = Map("key1" -> "value")
    val value1: Option[String] = myMap.get("key1")  // Some("value")
    val value2: Option[String] = myMap.get("key2")  // None
    
    // 通过模式匹配来输出匹配值
    val res = show(myMap.get("key1"))
    def show(x: Option[String]) = x match {
        case Some(s) => s
        case None => "?"
    }
    
    val a:Option[Int] = Some(5)
    val b:Option[Int] = None 
    b.getOrElse(0); b.getOrElse(5) // 都返回默认值5
    
    a.isEmpty
    ```

## 类和对象 & Trait
1. 类和对象
    - Scala继承一个基类跟Java很相似, 但我们需要注意以下几点：
        1. 重写一个非抽象方法必须使用 **override** 修饰符。
        2. 只有主构造函数才可以往基类的构造函数里写参数。
        3. 在子类中重写超类的抽象方法时，你不需要使用override关键字。

        ```
        class Location(override val xc: Int, override val yc: Int,
            val zc: Int) extends Point(xc, yc) {
                ...
            }
        
        // Scala重写一个非抽象方法，必须用override修饰符
        class Employee extends Person {
            var salary = 0.0
            override def toString = super.toString + "[salary=" + salary + "]"
        }
        
        ```
    - 当单例对象与某个类共享同一个名称时，他被称作是这个类的伴生对象：companion object。必须在同一个源文件里定义类和它的伴生对象。类被称为是这个单例对象的伴生类：companion class。类和它的伴生对象可以互相访问其私有成员。
2. Trait(特征)
    - Scala Trait(特征) 相当于 Java 的接口，实际上它比接口还功能强大，与接口不同的是，它还可以定义属性和方法的实现
    - Scala的类只能够继承单一父类，但是如果是 Trait(特征) 的话就可以继承多个，从结果来看就是实现了多重继承

        ```
        trait Equal {
            def isEqual(x: Any): Boolean
            def isNotEqual(x: Any): Boolean = !isEqual(x)
        }
    
        class Point(xc: Int, yc: Int) extends Equal {
            var x: Int = xc
            var y: Int = yc
            def isEqual(obj: Any) = 
                obj.isInstanceOf[Point] &&
                obj.asInstanceOf[Point].x == x
        }
    
        object Test {
            def main(args: Array[String]) {
                val p1 = new Point(2, 3)
                val p2 = new Point(2, 4)
                println(p1.isNotEqual(p2))
            }
        }
        ```
    - 特征也可以有构造器，由字段的初始化和其他特征体中的语句构成。这些语句在任何混入该特征的对象在构造是都会被执行。
    - 构造器的执行顺序：
        1. 调用超类的构造器；
        2. 特征构造器在超类构造器之后、类构造器之前执行；
        3. 特征由左到右被构造；
        4. 每个特征当中，父特征先被构造；
        5. 如果多个特征共有一个父特征，父特征不会被重复构造
       6. 所有特征被构造完毕，子类被构造。

3. 提取器是从传递给它的对象中提取出构造该对象的参数。
    - Scala 提取器是一个带有unapply方法的对象。unapply方法算是apply方法的反向操作：unapply接受一个对象，然后从对象中提取值，提取的值通常是用来构造该对象的值。 [链接](http://www.runoob.com/scala/scala-extractors.html)

## 模式匹配 & 正则表达式
- 一个模式匹配包含了一系列备选项，每个都开始于关键字 case。每个备选项都包含了一个模式及一到多个表达式。箭头符号 `=>` 隔开了模式和表达式。
- 使用了case关键字的类定义就是就是样例类(case classes)，样例类是种特殊的类，经过优化以用于模式匹配

    ```scala
    def matchT（x: Int): Int = x match {
        case 1 => "one"
        case 2 => "two"
    }

    def matchTest(x: Any): Any = x match {
        case 1 => "one"
        case "two" => 2
        case y: Int => "scala.Int"
        case _ => "many"
    }

    val alice = new Person("Alice", 25)
    for(person <- List(alice, bob, charlie)) {
        person match {
            case Person("Alice", 25) => println("Hi Alice")
            case Person("Bob", 25) => println("Hi Bob")
        }
    }
    // 样例类
    case class Person(name: String, age: Int)
    ```
- 正则表达式 [实例参考](http://www.runoob.com/scala/scala-regular-expressions.html)

    ```
    import scala.util.matching.Regex

    object Test{
        def main(args: Array[String]) {
            // val pattern = "scala".r
            val pattern = new Regex("(S|s)cala")
            val str = "scala is Scalable and Cool"

            println((pattern findFirstIn str).mkString(","))    //使用逗号，连接返回结果
    ```



## 文件I/O & 异常处理 
- 文件写操作，直接使用java中的I/O类

    ```
    import java.io._
    
    object Test {
        def main(args: Array[String]) {
            val writer = new PrintWriter(new File("test.txt"))
            writer.write("richiewfshi")
            writer.close()
        }
    }
    ```

- 屏幕上读取用户输入

    ```
    object Test {
        def mian(args: Array[String]) {
            val line = Console.readLine
            println("richie" + line)
    ```

- 文件读操作

    ```
    import scala.io.Source
    
    object Test {
        def main(args: Array[String]) {
            Source.fromFile("richie").foreach{
                print
            }
        }
    }
    ```

- `throw new IllegalArgumentException` 抛出异常
-  在Scala里，借用了模式匹配的思想来做异常的匹配，因此，在`catch`的代码里，是一系列case字句

    ```scala
    import java.io.FileReader
    import java.io.FileNotFoundException
    import java.io.IOException

    object Test {
        def main(args: Array[String]) {
            try {
                val f = new FileReader("input.txt")
            } catch {
                case ex: FileNotFoundException => {
                    println("Missing file execption")
                }
                case ex: IOException => {
                    println("IO Exception")
                }
            } finally {     // 都需要执行
                println("Existing finally...")
            }
    ```
