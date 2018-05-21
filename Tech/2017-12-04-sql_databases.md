---
title: 《SQL基础教程》简要总结
layout: post
author: WenfengShi
category: 技术
tags: [database, 读书笔记]
---
博客链接: [http://codeshold.me/2017/12/sql_databases.html](http://codeshold.me/2017/12/sql_databases.html)

> 偶然间从朋友那看到了这本书（《SQL基础教程》MICK著），感觉还不错，于是花了4个小时认真的过了一遍，在这里简单的总结一下要点（个人观点）


## 基础知识点
1. SQL不区分关键字的大小写
    - 推荐参考[阿里的MySQL规约](http://blog.csdn.net/jiankunking/article/details/56279259)
2. SQL语句中表示字符串用单引号`'`将字符括起来
3. 修改表名
    - PostgreSQL: `ALTER TABLE oldname RENAME TO newname`
    - Mysql: `RENAME TABLE oldname TO newname`
4. SQL注释
    - `-- `：单行注释，即`--` 加上半角空格
    - `/*    */`：可进行多行注释
5. `NOT`运算符
    - 不建议用 `...... where not xxx>0`
6. `AND`运算符的优先级高于`OR`
7. SQL中的逻辑运算是`三值逻辑`，即真、假和不确定（NULL）
8. 聚合函数会默认将NULL值排除
    - `count(*)`：查找的是包含NULL在内的全部数据行数
    - `count(1)`或者`count(column_name)`：不包含NULL在内的数据行数
    - `sum(column_name)`：`column_name`为NULL或为零，其计算效果是一样的
    - `avg(column_name)`：NULL值和零值，其计算效果是不一样的（分母不一样）
    - 聚合函数可以在SELECT子句、HAVING子句和ORDER BY子句中使用
    - COUNT等函数对表中的数据进行聚合操作时，DBMS内部会先进行排序处理
    - `GROUP BY`子句的聚合结果是无序的
9. `ORDER BY`字句中可以使用SELECT字句中已定义的列的别名
    - 可使用SELECT子句中未出现的列或者**聚合函数**
    - ORDER BY 子句中不建议使用编号（将来会被编号会被取消）
10. 两个词：`INSERT INTO`, `DELETE FROM`, `UPDATE SET`, `DROP TABLE` 
    - `UPDATE tblname SET (name1, name2, name3) = (Name1, Name2, Name3) WHERE ......`
    - `UPDATE tblname SET name1 = Name11, name2 = Name12 WHERE ......`
11. 事务是需要在同一个处理单元中执行的一系列更新处理的集合
    - `BEGIN TRANSCATION`, `START TRANSCATION`(mysql), `COMMIT;`
12. ACID
    - Atomicity
    - Consistency：满足约束
    - Isolation: 不同事务间不相干扰
    - Durability 
13. 视图的定义中不能包含`ORDER BY`子句
14. 标量子查询就是返回单一值的子查询
    - scalar subquery，即返回一行一列的结果
    - 标量子查询的位置可以是在SELECT子句、GROUP BY子句、HAVING子句、ORDER BY子句、WHERE字句等地方
1. 字符串拼接函数`||`在SQL和MySQL中无法使用，等价的函数是`CONCAT(str1, str2, str3)`
    - `LENGTH(str1)`
    - `SUBSTRING(str1 FROM 3 FOR 2)`：截取字符串str1中第三位和第四位字符（字符位置从1开始）
2. `EXTRACT(日期元素 FROM 日期)`
    - `EXTRACT(YEAR FROM CURRENT_TIMESTAMP)`
2. 类型转换函数：`CAST(xx AS yy)`
3. NULL值转换函数：`COALESCE(str1, str2, str3)` 会返回可变参数中左侧开始第一个不是NULL的值
4. 谓词
    - `LIKE`: `%`, `_`
    - `EXIST`, `NOT EXIST`
5. CASE表达式
    - 简单的CASE表达式：`CASE 表达式 WHEN ... THEN ... END`
    - 搜索CASE表达式：`CASE WHEN ... THEN ... WHEN THEN ... END`
6. 集合运算
    - `UNION`：可以使用任何一个select语句，但order by字句只能在最后使用 `UNION ALL` 不会消除重复行
    - `INTERSET`：求交集
    - `EXCEPT`：求差集
7. JOIN
    - 内连接：`INNER JOIN`
    - 外连接：`OUTER JOIN` 选择主表
    - 交叉连接：`CROSS JOIN`  --  笛卡尔积


## 窗口函数
> 窗口函数：OLAP（OnLine Analytical Processing）函数，对数据库数据进行实时分析处理，如市场分析、财务报表、创建计划等；
可以进行排序、生成序列等一般的聚合函数无法实现的高级操作

1. 语法 `<窗口函数> OVER ([PARTITION BY <列清单>] ORDER BY <排序清单>)`
    - PARTITION BY 对表的横向进行分组
    - ORDER BY 决定纵向的排序规则
    - PARTITION BY 分组后的记录集合成为“窗口”
3. 专用窗口函数
    - `RANK`: 计算排序时，如果存在相同位次的记录，则会跳过之后的位次
    - `DENSE_RANK`: 即使存在相同的位次记录，也不回跳过之后的位次
    - `ROW_NUMBER`: 赋予唯一的连续位次
    - 专用窗口函数无序参数，故括号都是空的
4. 聚合函数作为窗口函数使用
    - SUM, AVG, COUNT, MIN, MAX等 都是进行`累计`统计的，和GROUP BY 不同
5. 指定框架（统计范围）
    - `AVG(col1) OVER (ORDER BY col2 ROWS 2 PRECEDING)`
    - 使用了`ROWS`和`PRECEDING`关键字制定了框架，即统计对象先定位“截止到之前2行”
    - `AVG(col1) OVER (ORDER BY col2 ROWS 2 FOLLOWING)` “截止到之后～行”
6. OVER 字句中的 ORDER BY 只是用来决定窗口函数按照什么顺序进行计算的，对最后结果的排序没有影响！


## GROUPING 运算符
1. GROUPING运算符可以同时计算出`小计值`、`合计值`
2. `ROLL UP`同时计算出合计值和小计值
    - `GROUP BY ROLL UP(col1, col2)`, 在MySQL中要改写为`GROUP BY col1 with ROLLUP`
    - 上述语句即相当于`GROUP BY ()`（超级分组记录）和`GROUP BY (col1)`和`GROUP BY (col1, col2)`的结果
3. `GROUPING`函数 可判断超级分组记录中的NULL值
    - `GROUPING(col1)` 如果col1是超级分组记录所产生的NULL值时返回1， 其他返回0
4. `CUBE`即将GROUP BY子句中`聚合键`的所有“可能组织”的聚合结果集中到一个结果中
5. `GROUPING SETS` 可以从 ROLLUP或者CUBE的记过中取出部分记录
    - 不想得到`合计记录和使用多个聚合键的记录`时可以使用
    - `GROUP BY GROUPING SETS(col1, col2)` 结果集中的每个记录只包含col1（或col2）的单个合计







