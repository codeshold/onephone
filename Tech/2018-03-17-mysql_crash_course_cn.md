---
title: 《Mysql必知必会》读书笔记
layout: post
author: WenfengShi
category: 技术
tags: [database]
---
博客链接: [http://codeshold.me/2018/03/mysql_crash_course_cn.html](http://codeshold.me/2018/03/mysql_crash_course_cn.html)

> 《Mysql必知必会》(MySQL Crash Course)内容很丰富，mysql的各个方面都涉及到了，从基本的SQL增删改查到触发器、事务以及安全管理和性能提升，本书都做了精简的介绍。
相比于另外两本相关的初学者读物——[《SQL基础教程》MICK著](http://codeshold.me/2017/10/learning_mysql_mariadb_notes.html)和[《MySQL与MariaDB学习指南》](http://codeshold.me/2017/12/sql_databases.html)。这本书可能更适合想对mysql有全面了解的（比如对mysql的高级功能）或者想成为数据库管理员的人阅读。


## 简要介绍
> Ref: http://dev.mysql.com/

1. 本书的配套网站[MySQL Crash Course](http://forta.com/books/0672327120/)，原作者很厉害，毕竟他之前就出了一本堪称全世界用得最多的一本SQL教程-- `Sams Teach Yourself SQL in 10 Minutes`( 中文版《SQL必知必会》，人民邮电出版社出版)
2. 数据库(database) 是保存有组织的数据的容器(通常是一个文 件或一组文件，而数据库软件应称为**DBMS**（数据库管理系统）
3. 模式(`schema`) && 数据库(`database`)? —— 一般情况下，模式用作数据库的同义词，模式(schema) 关于数据库和表的布局及特性的信息
4. 记录(`record`) && 行(`row`)？—— 在很大程度上，这两个术语是可以互相 替代的，但从技术上说，行才是正确的术语
5. SQL(发音为字母S-Q-L或sequel)是结构化查询语言(Structured Query Language)的缩写。
6. DBMS可分为两类:`一类为基于共享文件系统的DBMS`，另一类为基于客户机—服务器的DBMS。
    - 前者如Microsoft Access和FileMaker等，用于桌面用途，通常不用于高端或更关键的应用
    - 后者如MySQL、Oracle以及Microsoft SQL Server等数据库是基于客户机—服 务器的数据库。
7. 写SQL语句的惯例——关键词都大写，表明列名小写

## 基本用法
> SQL基本用法可参考[笔记1](http://codeshold.me/2017/10/learning_mysql_mariadb_notes.html)和[笔记2](http://codeshold.me/2017/12/sql_databases.html)，这里仅就个别的点总结下

1. 多用SHOW, `HELP SHOW`, `SHOW GRANTS`, `SHOW ERRORS`, `SHOW WARNINGS`
    - `DESCRIBE customers;`是 `SHOW COLUMNS FROM customers;`的快捷方式
    - `INFORMATION_SCHEMA`
2. 在处理SQL语句时，其中所有空格都被忽略。
3. 查询结果默认是升序排序(从A到Z)
4. `!=`等同于`<>`操作符
5. SQL(像多数语言一样)在处理OR操作符前，优先处理AND操作符！！！
    - 最好使用圆括号明确地分组相应的操作符
    - `WHERE id=1002 OR id=1003 AND price>=10` 这个WHERE字句的计算次序呢？
6. MySQL支持使用NOT对`IN`、`BETWEEN`和 `EXISTS`子句取反，这与多数其他DBMS允许使用NOT对各种条件 取反有很大的差别。
7. 从技术上说，LIKE是谓词而不是操作符。
8. 虽然似乎%通配符可以匹配任何东西，但有一个例外，即NULL。 即使是`WHERE prod_name LIKE '%'`也不能匹配用值NULL作为产品名的行 
9. MySQL正则表达式
    - 用`REGEXP`代替`LIKE`
    - 为了匹配特殊字符，必须用`\\`为前导。`\\-`表示查找-，`\\.`表示查找`.`。如`WHERE name REGEXP '\\.'`
    -  `\` && `\\` ? 多数正则表达式实现使用单个反斜杠转义特殊字符， 以便能使用这些字符本身。但MySQL要求两个反斜杠(MySQL 自己解释一个，正则表达式库解释另一个)。
    - 常用的字符类(character class)， 如`[:alnum:]`匹配任意字母和数字(同[a-zA-Z0-9]), `[:alpha:]`匹配任意字符(同[a-zA-Z])
    - 定位元字符: `[[:<:]]`和`[[:>:]]`分别匹配词的开始和结尾
10. LIKE和REGEXP 的不同在于，LIKE匹配整个串而REGEXP匹配子串。利用定位 符，通过用`^`开始每个表达式，用`$`结束每个表达式，可以使 REGEXP的作用与LIKE一样。
11. 多数DBMS使用`+或||`来实现拼接， MySQL则使用`Concat()`函数来实现
12. `SUM(), MIN(), MAX()`会忽略列值为NULL的行。
13. `COUNT()`函数有两种使用方式。
    - 使用`COUNT(*)`对表中行的数目进行计数，不管表列中包含的是空 值(NULL)还是非空值。
    - 使用`COUNT(column)`对特定列中具有值的行进行计数，忽略NULL值，如果指定列名，则DISTINCT只能用于`COUNT()`。DISTINCT 不能用于`COUNT(*)`，因此不允许使用`COUNT(DISTINCT)`， 否则会产生错误。类似地，`DISTINCT`必须使用列名，不能用于计算或表达式。
14. 分组
    - 如果分组列中具有NULL值，则NULL将作为一个分组返回。如果列 中有多行NULL值，它们将分为一组。
    - 使用`WITHROLLUP`关键字，可以得到每个分组以 及每个分组汇总级别(针对每个分组)的值, `GROUP BY id WITH ROLLUP`
    - WHERE在数据 分组前进行过滤，HAVING在数据分组后进行过滤
15. ANSI SQL规范首选INNER JOIN语法。此外， 尽管使用WHERE子句定义联结的确比较简单，但是使用明确的 联结语法能够确保不会忘记联结条件，有时候这样做也能影响 性能。
16. UNION中的每个查询必须包含相同的列、表达式或聚集函数(不过各个列不需要以相同的次序列出)。
17. 在INSERT和INTO之间添加关键字`LOW_PRIORITY`，指示MySQL 降低INSERT语句的优先级, `INSERT LOW_PRIORITY INTO`
18. 如果用UPDATE语句更新多行，并且在更新这些行中的一行或多行时出一个现错误，则整个UPDATE操作被取消 (错误发生前更新的所有行被恢复到它们原来的值)。为即使是发
生错误，也继续进行更新，可使用IGNORE关键字，`UPDATE IGNORE customers...`
19. 如果仅想在一个表不存在时创建它，应该在表名后给出`IF NOT EXISTS`
20. `last_insert_id()`函数可以获取`AUTO_INCREMENT`对应的值
21. 需要知道的引擎
    - `InnoDB`是一个可靠的事务处理引擎，它不支持全文本搜索;
    - `MEMORY`在功能等同于MyISAM，但由于数据存储在内存(不是磁盘)中，速度很快(特别适合于临时表);
    - `MyISAM`是一个性能极高的引擎，它支持全文本搜索， 但不支持事务处理。
22. `RENAME TABKE xx TO yy;`
23. `CREATE OR REPLACE VIEW  xxx`, 视图可以嵌套，但不能索引，也不能有关联的触发器


## 高级用法
### 1. 全文本搜索
1. 两个最常使用的引擎为MyISAM和InnoDB， 前者支持全文本搜索，而后者不支持
2. 全文本搜索在性能、明确控制和**智能化的结果**(例如，一个特殊词的搜索将会返回包含该词的所有行，而不区分 包含单个匹配的行和包含多个匹配的行)方面很有优势
3. 为了进行全文本搜索，必须索引被搜索的列，而且要随着数据的改 变不断地重新索引, `FULLTEXT(note_text)`的表示对`note_text`进行索引
4. 使用两个函数`Match()`和`Against()`执行全文本搜索， 其中`Match()`指定被搜索的列，`Against()`指定要使用的搜索表达式
5. 除非使用`BINARY`方式， 否则全文本搜索不区分大小写。
6. 全文本搜索的一 个重要部分就是对结果排序。具有较高等级的行先返回(因为这些行很 可能是你真正想要的行)。
7. Match()和Against() 用来建立一个计算列(别名为rank)，此列包含全文本搜索计算出的等级值。
8. 文本中词靠前的行的等级值比词靠后的 行的等级值高。
9. 查询扩展——利用查询扩展，能找出可能相关的结果，即使它们并不精确包含所 查找的词。
    - `WHERE Match(note_text) Against('anvils' WITH QUERY EXPANSION)`
    - `WHERE Match(note_text) Against('anvils')`
10. 布尔文本搜索
    - 即使没有FULLTEXT索引也可以使用, 但这是一种非常缓慢的操作
    - `WHERE Match(note_text) Against('heavy' IN BOLLEAN MODE)`
    - `WHERE Match(note_text) Against('heavy -rope*' IN BOLLEAN MODE)`匹配包含heavy但不包含任意以rope开始的词的行
    - 全文本布尔操作符`-`排除一个词，而`*`是截断操作符(可想象为用于词尾的一个通配符)
    - 在布尔方式中，不按等级值降序排序返回的行。
11. 在索引全文本数据时，短词被忽略且从索引中排除。短词定义为 那些具有3个或3个以下字符的词(如果需要，这个数目可以更改)
12.  MySQL带有一个内建的非用词(`stopword`)列表，这些词在索引全文本数据时总是被忽略。
13. MySQL规定了一条50%规则，如果一个词出现在50%以上 的行中，则将它作为一个非用词忽略。50%规则不用于IN BOOLEAN MODE。
14. 忽略词中的单引号。例如，don't索引为dont。

### 2. 存储过程
1. 存储过程简单来说，就是为以后的使用而保存 的一条或多条MySQL语句的集合
2. MySQL称存储过程的执行为调用，因此MySQL执行存储过程的语句为`CALL`。
3. **mysql命令行客户机的分隔符**
    - 默认的MySQL语句分隔符为;
    - `DELIMITER //`告诉命令行实用程序使用`//`作为新的语句结束分隔符
    - 除`\`符号外，任何字符都可以用作语句分隔符
4. `SHOW PROCEDURE STATUS`, `SHOW PROCEDURE STATUS LIKE 'xxx'`, `SHOW CREATE PROCEDURE xxx`
5. 所有MySQL变量都必须以`@`开始, `set total=1; select @total;`
6. MySQL支持IN(传递给存储过程)、OUT(从存 储过程传出，如这里所用)和INOUT(对存储过程传入和传出)类型的参 数。 
7. 简单范例，调用存储过程则键入`call productpricing;`即可

```mysql
DELIMITER //
CREATE PROCEDURE productpricing() COMMENT 'xxxx'
BEGIN
    SELECT Avg(xx) AS yy INTO zz
    FROM aa;
    -- comment
    DECLAR total DECIMAL(8,2);
    IF taxable THEN
        SELECT xx INTO yy;
    END IF;
END //
DELIMITER ;
```

### 3. 游标
1. 游标(cursor)是一个存储在MySQL服务器上的数据库查询， 它不是一条SELECT语句，而是被该语句检索出来的结果集。
2. SELECT -- MySQL检索操作返回一组称为结果集的行
3. 不像多数DBMS，MySQL游标只能用于存储过程(和函数)。
4. 使用游标
    - 声明（定义）--> 打开使用 --> 取出数据 --> 关闭
5. 如果你不明确关闭游标，MySQL将会在到达END语 句时自动关闭它
6. DECLARE语句的发布存在特定的次序。 用DECLARE语句定义的局部变量必须在定义任意游标或句柄 之前定义，而句柄必须在游标之后定义。不遵守此顺序将产 生错误消息。
7. 通常REPEAT语句的语法使它更适合于对游标进行循环
8. `DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET done=1;` 
    - 这条语句定义了一个CONTINUE HANDLER，它是在条件出现时被执行的代码。
    - 这里，它指出当SQLSTATE '02000'出现时，`SET done=1`。`SQLSTATE '02000'`是一个未找到条件，当REPEAT由于没有更多的行供循环而不能继 续时，出现这个条件。
8. 简单例子

```
CREATE PROCEDURE processorders()
BEGIN
    -- Declare local variable
    DECLARE done BOOLEAN DEFAULT 0;
    DECLARE o INT;
    DECLARE t DECIMAL(8,2);
    -- Declare the cursor
    DECLARE ordernumbers CURSOR FOR SELECT order_num FROM ordres;
    DECLARE CONINTUE HANDLER FOR SQLSTATE '02000' SET done=1;
    -- Create a table to store the results
    CREATE TABLE IF NOT EXISTS ordertotals 
    (order_num int, total decimal(8,2))
    -- Open the cursor
    OPEN ordernumbers;
    -- Loop through all rows
    REPEAT
        -- get order number
        FETCH ordernumbers INTO o;
        -- get the total for the order
        CALL ordertotal(o, 1, t);
        -- Insert order and total into ordertotals
        INSERT INTO ordertotals(order_num, total) VALUES(o, t);
        -- End of loop
    UNTIL DONE END REPEAT;
    -- Close the cursor
    CLOSE ordernumbers;
END;
```

### 4. 触发器
1. 触发器是MySQL响应以下任意语句而 自动执行的一条MySQL语句(或位于BEGIN和END语句之间的一组语句):
    - DELETE
    - INSERT
    - UPDATE
2. 每个表最多支持6个触发器(每条INSERT、UPDATE 和DELETE的之前和之后)。
3. 触发器名必 须在每个表中唯一，但不是在每个数据库中唯一。
4. `DROP TRIGGER`
2. `CREATE TRIGGER newproduct AFTER INSERT ON products FOR EACH ROW SELECT 'Product added'`
    - `FOR EACH ROW`对每个插入执行
3.  只有表才支持触发器，视图不支持(临时表也不 支持)。
6. INSERT
    - 在INSERT触发器代码内，可引用一个名为NEW的虚拟表，访问被 插入的行;
    - 对于AUTO_INCREMENT列，NEW在INSERT执行之前包含0, 在INSERT 执行之后包含新的自动生成值。
    - `CREATE TRIGGER neworder AFTER INSERT ON orders FOR EACH ROW SELECT NEW.order_num;`
7. DELETE
    - 在DELETE触发器代码内，你可以引用一个名为OLD的虚拟表，访 问被删除的行
    - OLD中的值全都是只读的，不能更新
8. UPDATE
    - 在UPDATE触发器代码中，你可以引用一个名为OLD的虚拟表访问 以前(UPDATE语句前)的值，引用一个名为NEW的虚拟表访问新 更新的值;
    - `CREATE TRIGGER updatevendeor BEFORE UPDATE ON vendors FOR EACH ROW SET NEW.vend_state=Upper(New.ven_state);`
9. 进一步介绍
    - MySQL触发器中不支持CALL语句。这表示不能从触发 器内调用存储过程。所需的存储过程代码需要复制到触发器内。
    - 使用触发器， 把更改(如果需要，甚至还有之前和之后的状态)记录到另一个 表非常容易。
    - 应该用触发器来保证数据的一致性(大小写、格式等)。
10. 简单举例
```sql
CREATE TRIGGER deleteorder BEFORE DELETE ON orders
FOR EACH ROW
BEGIN
    INSERT INTO archive_orders(order_num, order_date, cust_id)
    values(OLD.order_num, OLD.order-date, OLD.cust_id);
END;
```

### 5. 事务处理
1. 事务处理(transaction processing)可以用来维护数据库的完整性，它 保证成批的MySQL操作要么完全执行，要么完全不执行。
2. 术语
    - 事务(transaction)指一组SQL语句;
    - 回退(rollback)指撤销指定SQL语句的过程;
    - 提交(commit)指将未存储的SQL语句结果写入数据库表;
    - 保留点(savepoint)指事务处理中设置的临时占位符(placeholder)，你可以对它发布回退(与回退整个事务处理不同)。
3. 不能回退CREATE或DROP操作。事务处理块中可以使用这两条语句，但如果你执行回退，它们不会被撤销。
4. 一般的Mysql语句是隐含提交(implicit commit)，即提交(写或保存)操作是自动进行的。
```
START TRANSACTION;
DELETE FROM orderitems WHERE order_num=20120;
DELETE FROM orders WHERE order_num=2001;
COMMIT;
```
5. `SAVEPOINT delete1;`, `ROLLBACK TO delete1;`
    - 保留点在事务处理完成(执行一条ROLLBACK或 COMMIT)后自动释放
    - `RELEASE SAVEPOINT`可以明确地释放保留点。

6. `autocommit`标志决定是否自动提交更改, `SET autocommit=0` --> 指示Mysql不自动提交
    - autocommit标志是针对每个连接而不是服 务器的。

## 深入了解
1. 字符和校对
    - `字符集`为字母和符号的集合;
    - `编码`为某个字符集成员的内部表示; 
    - `校对`为规定字符如何比较的指令。
2. `SHOW CHARACTER SET;`, `SHOW COLLATION;`
    - `SHOW VARIABLES LIKE 'character%';`
    - `SHOW VARIABLES LIKE 'collation%';`
3. 使用`Cast()`或`Convert()`函数，可在字符集之间进行转化
4. `SHOW GRANTS FOR yourname;`
5. `SET PASSWORD=Password('hello');`
6. 为了保证所有数据被写到磁盘(包括索引 数据)，可能需要在进行备份前使用`FLUSH TABLES`语句。
7. 数据库维护
    - `ANALYZE TABLE tblname;` 用来检查表键是否正确
    - `CHECK TABLE tblname1, tblname2;` 可选`CHANGED`,`EXTENED`, `FAST`, `MEDIUM`, `QUICK`
    - CHECK TABLE支持一系列的用于MyISAM表的方式
        - CHANGED 检查自最后一次检查以来改动过的表
        - EXTENDED 执行最彻底的检查
        - FAST 只检查未正常关闭的表
        - MEDIUM 检查所有被删 除的链接并进行键检验
        - QUICK 只进行快速扫描
    - `REPAIR TABLE tblname3;` 这条语句不应该经常使用，如果 需要经常使用，可能会有更大的问题要解决
    - `OPTIMIZE TABLE tblname4;` 可用来在删除大量数据后回收所用空间
8. mysqld 的`--safe-mode` 装载减去某些最佳配置的服务器
9. MySQL的主要日志文件：错误日志、查询日志、二进制日志、缓慢查询日志
10. `SHOW PROCESSLIST`可以显示所有活动的进程(以及它们的线程ID和执行时间)。
11. 使用EXPLAIN语句让MySQL解释它将如何执行一条SELECT语句
12. 有的操作(包括INSERT)支持一个可选的DELAYED关键字，如果使用它，将把控制立即返回给调用程序，并且一旦有可能就实际 执行该操
13. LIKE很慢，一般来说，最好是使用FULLTEXT而不是LIKE。
