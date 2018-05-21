---
title: MySQL与MariaDB学习笔记
layout: post
author: WenfengShi
category: 技术
tags: [database]
---
博客链接: [http://codeshold.me/2017/10/learning_mysql_mariadb_notes.html](http://codeshold.me/2017/10/learning_mysql_mariadb_notes.html)


> 本文是《MySQL与MariaDB学习指南》的简要学习笔记，方便日后查询和回忆！
原书容较为基础，但够用了，尤其常用函数和数据导入导出写的很不错! 适合初学者以及对mysql了解不用很深的人(仅会用)！ 原书不涉及任何sql的优化！
发现了书中两处错误，已提交勘误!
进阶读物[《深入理解MariaDB和MySQL》](http://www.ituring.com.cn/book/1467)。
作者网站[mysqlresources.com](http://mysqlresources.com/)有很多资料。


## 0x01 准备
- 自己没有安装相关工具，使用了docker mariadb 镜像
- 相关命令如下
    - `docker run -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root --name mariadb -d mariadb:latest`
    - `docker exec -it mariadb bash`
    - `docker start mariadb`
- 登陆说明

    ```bash
    root@b2659b21f321:/# mysql -uroot -proot  # 默认用户名和密码为root

    Welcome to the MariaDB monitor.  Commands end with ; or \g.  # 命令要以分号(;) 或斜线 +g(\g)结尾
    Your MariaDB connection id is 10    # 本次连接标识符
    Server version: 10.2.7-MariaDB-10.2.7+maria~jessie mariadb.org binary distribution

    Copyright (c) 2000, 2017, Oracle, MariaDB Corporation Ab and others.

    Type 'help;' or '\h' for help. Type '\c' to clear the current input statement. # 可清除之前缓存的输入一半的mysql命令

    MariaDB [(none)]> 
    ```

- help 帮助命令, 最有用的 `help contents`
    - `help`
    - `help Data Manipulation`
    - `help SHOW DATABASES`
- `prompt` 可修改提示符
- 大小写区别
    - MySQL 不区分关键字(如 SHOW)的大小写,所以可以 用 show 甚至 sHoW
    - 数据库、表和列的名字却**可能**是区分大小写的,尤其是在那些大小写敏感的操作系统上,如Mac OS X或Linux
- 用户自定义变量, 以 @ 开头的名字,再用 = 连接上一个值,或者一个表达式,又或者一条返回单个 值的 SQL 语句, 即`SET @fav_site_total =`
- `show tables from msyql;` 显示mysql数据库中的所有表
- `describe mysql.user;`
- 创建数据库和表
    - `CREATE SCHEMA swf` == `CREATE DATABASE swf`
    - `CREATE DATABASE swf2 CHARACTER SET latin1 COLLATE latin1_bin;` # MySQL 数据的存储方式是二进制拉丁字符
    - 表名可以是 SQL 保留字以外的任何东西。事实上,用保留字也可以,但需要加上引号以作区分
    - AUTO_INCREMENT 选项告诉 MySQL 此列的值是自增的
    - TEXT类型,即长度可变,但最多65 535字节
    - 如果你能确定某列内容的长度,那就用 CHAR,否则用 VARCHAR
    - UNIQUE, 会截短显示为 UNI
    - `ENGINE=MyISAM DEFAULT CHARSET=latin1 COLLATE=latin1_bin`, 首先是表类型,或者说是该表使用的存储引擎的类型; 剩下两个是表的默认字符集(latin1)和默认校对方式(latin1_bin)
    - 校对方式,则可选 latin5_turkish_ci,它会根据土耳其语的字母表来排序
    - BLOB 二进制大对象
- 备份数据库 `mysqldump --user='russell' -p rookery birds > /tmp/birds.sql`
- 导入数据库 `mysql --user='russell' -p rookery < rookery-ch2-end.sql`
- `CREATE TABLE test.birds_new LIKE birds;` 仅复制表结构
- `CREATE TABLE birds_new_alternative SELECT * FROM rookery.birds;` 复制表结构和表数据


## 0x02 相关操作

- `ALTER TABLE birds ADD COLUMN test INT`
- `ALTER TABLE birds_new ADD COLUMN wing_id CHAR(2);`
- `ALTER TABLE birds_new ADD COLUMN wing_id CHAR(2) AFTER family_id;` # 在特定的列之后加入一列
- `ALTER TABLE birds_new DROP COLUMN wing_id;`
- `ALTER TABLE birds_new ADD COLUMN bill_id CHAR(2) AFTER body_id, ADD COLUMN endangered BIT DEFAULT b'1' AFTER bill_id;`可同时添加多列
- `ALTER TABLE birds_new CHANGE COLUMN common_name common_name VARCHAR(255);` 在使用CHANGE COLUMN时,就算只想修改该列的某一方面, 也需要完整地声明整个新列。
- MODIFY COLUMN子句的语法只要求输入一次列名, MODIFY COLUMN是不能用来 改列名的

    ```sql
    ALTER TABLE birds_new
    MODIFY COLUMN endangered
    ENUM('Extinct',
         'Extinct in Wild',
         'Threatened - Critically Endangered',
         'Threatened - Endangered',
         'Threatened - Vulnerable',
         'Lower Risk - Conservation Dependent',
         'Lower Risk - Near Threatened',
         'Lower Risk - Least Concern')
    AFTER family_id;
    ```

- `SHOW COLUMNS FROM birds_new LIKE 'endangered' \G` 结果仅显示 endangered 列的设定
    - `SHOW FULL COLUMNS`显示更全的信息
- `ALTER TABLE birds_new ALTER conservation_status_id DROP DEFAULT;` 修改默认值的设定
- `SELECT auto_increment FROM information_schema.tables WHERE table_name = 'birds';`
- `ALTER TABLE birds AUTO_INCREMENT = 10;`
    - 这个命令虽说是更改 bird_orders 表,但实际修改的是服务器上保存 AUTO_INCREMENT 值的表 (information_schema数据库中的)
- 重命名一个表 `RENAME TABLE table1_altered TO table1;`
- 将一个表移动到另一个数据库中 `RENAME TABLE rookery.birds TO rookery.birds_old, test.birds_new TO rookery.birds;` 
- `SHOW TABLES FROM mysql LIKE 'plugin';` 或者 `SHOW TABLES IN rookery LIKE 'birds%';`
- `SHOW INDEX FROM birdwatchers.humans \G`
- `ALTER TABLE birdwatchers.humans ADD INDEX human_names (name_last, name_first);` 添加索引
- `EXPLAIN`语句返回的信息中， possible_keys域表示可能用到的键， key 域表示确实用到的键
- `ALTER TABLE conservation_status DROP PRIMARY KEY, CHANGE status_id conservation_status_id INT PRIMARY KEY AUTO_INCREMENT;`
- `SHOW WARNINGS \G`
- `DELETE FROM bird_families WHERE family_id = 101;`
- `INSERT INTO ...... VALUES ......`
- `INSERT IGNORE INTO ......` 指示服务器忽略所有错误,并插入那些没有产生错误的行, 接下来可以通过SHOW WARNINGS 显示那些有问题的行
- `UPDATE ....... SET ...... WHERE ...... `
- `REPLACE INTO ...... VALUES ......` 或 `REPLACE INTO ...... SELECT ......`
    - REPLACE 语句可用于替换含有重复键的整行数据,或新增原表中所没有的数据。
    - 整行替换
- `INSERT LOW_PRIORITY INTO bird_sightings`
    - InnoDB 引擎的表不支持 `LOW_PRIORITY` 和 `HIGH_ PRIORITY`,因为 InnoDB 只锁定相关的行而不锁定整个表,所以这两个选项对它没有意义。
- LIMIT 子句带了两个值:一个是开始位置,一个是行数
- 如果列的别名就是一个单词,那么没有必要加引号。否则,要加。另外,保留字(如 Order)也要加引号
- 在 ORDER BY 中不能使用列的别名,但表的别名则可以。
- REGEXP正则匹配 `WHERE common_name REGEXP 'Great|Least' AND common_name NOT REGEXP 'Hawk-Owl'`
- 别名关键字 AS 可以可无！
- `UPDATE humans SET formal_title = SUBSTRING(formal_title, 1, 2);`
- 在MySQL使用UPDATE的多表语法时,不能带有ORDER BY或LIMIT——但在 UPDATE 单表时就可以 

    ```sql
    UPDATE prize_winners, humans
         SET winner_date = CURDATE()
         WHERE winner_date IS NULL
         AND country_id = 'uk'
         AND prize_winners.human_id = humans.human_id
         ORDER BY RAND()  # 随机
         LIMIT 2;  # 只更新两行
     ```

- `INSERT...ON DUPLICATE KEY UPDATE... `

    ```sql
    INSERT INTO humans
    (formal_title, name_first, name_last, email_address, better_birders_site)
    VALUES('Mr','Barry','Pilson', 'barry@gomail.com', 1),
    ('Ms','Lexi','Hollar', 'alexandra@mysqlresources.com', 1),
    ('Mr','Ricky','Adams', 'ricky@gomail.com', 1)
    ON DUPLICATE KEY
    UPDATE better_birders_site = 2;  # 在重复的行上设置那个字段为2
    ```

- 多表删除操纵, `DELETE FROM table[, table] USING table[, . . . ] [WHERE condition];`

    ```sql
    DELETE FROM humans, prize_winners
    USING humans JOIN prize_winners
    WHERE name_first = 'Elena'
    AND name_last = 'Bokova'
         AND email_address LIKE '%yahoo.com'
         AND humans.human_id = prize_winners.human_id;
    ```

- 连接时在左表(humans)中找不到对应行,右表(prize_winners)的数据也会被删除

    ```sql
    DELETE FROM prize_winners
    USING humans RIGHT JOIN prize_winners
    ON humans.human_id = prize_winners.human_id
    WHERE humans.human_id IS NULL;
    ```

- 因为使用 UNION 时,MySQL 只会取第一个 SELECT 的域名作为最终结果集的 标题,而之后的 SELECT 的域名都会被忽略
- 编写SQL语句时，连接条件与筛选条件最好分开！
- 使用 USING 时,连接条件中的列必须是在两表中都 存在的
- 不要把 `USING...JOIN` 和 `JOIN...USING` 搞混了

    ```sql
    SELECT book_id, title, status_name
         FROM books
         JOIN status_names ON(status = status_id);
    SELECT book_id, title, status_name
         FROM books
         JOIN status_names USING(status_id);

    UPDATE birds
    LEFT JOIN conservation_status USING(conservation_status_id)
    JOIN bird_families USING(family_id)
    SET birds.conservation_status_id = 9
    WHERE bird_families.scientific_name = 'Ardeidae'
    AND conservation_status.conservation_status_id IS NULL;
    ```

- 动态列
- 子查询
    1. 标量子查询：只返回一个值
    2. 列子查询
    3. 行子查询
    4. 表子查询
    5. [自查询性能](https://dev.mysql.com/doc/refman/5.6/en/subqueries.html)



## 0x03 常用函数


>  文本作为参数时,需要使用引号。
 列作为参数时,不要用引号——否则列名会被当成文本。如果列名是保留字或含有 可能引起问题的字符,可用`反引号`标示列名。
 如果字符串函数返回的值过长(即返回了太多的字符串),超出了系统限制(`max_allowed_packet`选项),MySQL 就会返回 NULL。
 有些参数用于指定字符串中字符的位置。**字符串第一个字符的位置是1**,不是0。 当需要从后往前数时(有些函数允许这么做),最后一个字符的位置是 -1。
 有些参数用于表示字符串长度。如果用到小数,MySQL就会将其四舍五入为最接 近的整数。



1. 字符串函数
    - 拼接 `CONCAT()`, `CONCAT_WS('|', ...)`指定分隔符
        - `mysql -p --skip-column-names -e "" > tmp.txt`, --skip-column-names 隐藏列名
    - 大小写 `LCASE(common_name)` 同 `LOWER()`, `UCASE(bird_families.scientific_name)` 同 `UPPER()`
    - 引号 `QUOTE(common_name)` 接受字符串输入,然后将其用单引号包围, 会对某些字 符进行转换, 包括单引号、反斜杠、空(零)字节,以及 Ctrl-Z 字符
    - 修剪 `RTRIM(name_first)`, `LTRIM()`, `TRIM()`
    - 填充 `RPAD(common_name, 20, '.' )`, `LPAD()`, `SPACE()` 在 网页上显示的话,则要用 `&nbsp;`(不换行空格)来填充
    - 抽取字符 `LEFT(prospect_name, 2)`, `MID(prospect_name, 5, 25)`, `RIGHT(prospect_name, 25)`
        - `SUBSTRING(prospect_name, 1, 2)` 第三个参数表示个数
        - `SUBSTRING(prospect_name FROM 5 FOR 25)`, 其中25 代表抽取长度
        - `SUBSTRING(prospect_name, -25)`
    - 抽取元素 `SUBSTRING_INDEX(prospect_name, '|', 1)`, `SUBSTRING_INDEX(prospect_name, '|', -1)` 第三个参数表示抽取个数
    - 搜索 `LOCATE('Avocet', common_name) ` 返回Avocet子字符串第一次出现的地方

2. 日期和时间函数
    - 存储日期的 DATE,存储时间的 TIME,将日期和时 间一起存储的 DATETIME 和 TIMESTAMP,以及存储年份的 YEAR
    - `NOW()` 有几个同义词:`CURRENT_TIMESTAMP()`、`LOCALTIME()` 和 `LOCALTIMESTAMP()`
        - `NOW()` 所返回的日期和时间是它所在的 SQL 语句开始执行时的日期和时间
        - `SYSDATE()`,它返回的是自身被执行时的那个时间点(不是整条语句的结束时间)
        - `SELECT NOW(), SLEEP(4) AS 'Zzz', SYSDATE(), SLEEP(2) AS 'Zzz', SYSDATE();`
    - 获取时间 `CURDATE( ), CURTIME( ), UNIX_TIMESTAMP()`
    - 抽取时间
        - `HOUR(time_seen), MINUTE(time_seen), SECOND(time_seen)`
        - YEAR()、MONTH() 和 DAY()
        - MONTHNAME() 和 DAYNAME()
        - EXTRACT(), `EXTRACT(YEAR_MONTH FROM time_seen), EXTRACT(HOUR_MINUTE FROM time_seen), EXTRACT(MONTH FROM time_seen)`
    - 格式化时间
        - `DATE_FORMAT(time_seen, '%W, %M %e, %Y')`
        - `TIME_FORMAT(time_seen, '%l:%i %p')`
        - `SELECT GET_FORMAT(DATETIME, 'ISO'), GET_FORMAT(DATE, 'ISO')` 可以查看时间的标准格式
    - 时区
        - `SHOW VARIABLES LIKE 'time_zone';`
        - `CONVERT_TZ()` 接受三个参数:日期和时间,来自哪个时区,想转换成哪个时区
        - `mysql_tzinfo_to_sql /usr/share/zoneinfo | mysql -p -u root mysql` 安装时区文件
        - 设置时区 `SET GLOBAL time_zone = 'GMT';`, `default-time-zone='GMT'`
    - 时间加减
        - `DATE_ADD()` 和 `DATE_SUB()`, 语法一样:第一个参数是要修改的日期,第二个参数是时间量, 时间量的写法是:在 INTERVAL 关键字后接上数字和单位(例如INTERVAL 1 DAY)
        - `DATE_ADD(membership_expiration, INTERVAL 3 MONTH)`, `DATE_ADD(membership_expiration, INTERVAL -1 YEAR)`
        - `DATE_SUB(membership_expiration, INTERVAL 1 YEAR)`
        - 可以用组合时间,一天两小时之后 `DATE_ADD(time_seen, INTERVAL '1 2' DAY_HOUR)`
        - `TIME_TO_SEC()` 和 `SEC_TO_TIME()`
        - `PERIOD_ADD()`, 接受两个参数,第一个是日期,第二个是想要增加的月的数量, 它接受的参数不是日期类型,而是字符串类 型,同时,返回值也是字符串
        - `PERIOD_ADD( EXTRACT(YEAR_MONTH FROM CURDATE()), -3)`
        - `DATE_ADD()` 的别名 ADDDATE(), `DATE_SUB()` 的别名 SUBDATE())
    - 季度显示 `QUARTER(CURDATE())`
    - 比较日期 `DATEDIFF() 和 TIMEDIFF()`
3. 聚合函数和数值函数
    - `TIME_TO_SEC(), AVG(), MIN(avg_time), MAX(avg_time)`
    - `STDDEV() 和 VARIANCE()` 标准差、方差
    - 拼接同组的值, `GROUP_CONCAT()`, 可以把一个组所有的值拼接成一个以逗号分隔的串
    - 能以某种方式改变数字的函数叫作数值函数
        - 四舍五入 ` ROUND()`, 
        - 上舍入， 下舍入 `FLOOR()`, `CEILING()`
        - 截断, 只想去掉小数,那可以用 `TRUNCATE()`
        - 取绝对值 `ABS()`
        - 判断正负 `SIGN()`
        - `POWER(2, 8)` 会返回2的8次方,即256; `PI()` 会返回π,即3.141593

## 0x04 权限管理
> 用户账号: 用户名与主机的组合”

1. 用户账户
    - `SHOW GRANTS FOR 'lena_stankoska';`, `SHOW GRANTS FOR 'lena_stankoska'@localhost \G`
    - `GRANT ALL ON rookery.* TO 'lena_stankoska'@'localhost';`
    - `DROP USER 'lena_stankoska'@'localhost';`, `DROP USER 'lena_stankoska'@'%';`
    - 创建用户&赋予权限
        - `CREATE USER 'lena_stankoska'@'localhost' IDENTIFIED BY 'her_password_123';`
        - `GRANT USAGE ON *.* TO 'lena_stankoska'@'lena_stankoska_home' IDENTIFIED BY 'her_password_123';`
        - `SELECT PASSWORD('her_password_123');`, 从 MySQL 5.6 版本开始,包含 PASSWORD 的语句不会被记录
    - ** GRANT和REVOKE语句中可用的权限 -- P197 **
    -  **权限操作脚本 -- P201**
    - 限制访问特定的列 `GRANT SELECT (human_id, formal_title) ON birdwatchers.humans TO 'lena_stankoska'@'lena_stankoska_home';`

2. 备份和导入账号
    - 在插入数据时,还需要 LOCK TABLES 权限来锁住表。
    - 需要CREATE和INDEX权限来分别创建表和索引。
    - 因为dump文件可能包含设置校对集的语句,所以需要ALTER权限。
    - 基于Lena Stankoska用来恢复表的方法,她可能还想将数据恢复到临时表。这样的话,
    则需要 CREATE TEMPORARY TABLES 权限。(临时表会在连接关闭时被删掉。)
    - 如果数据库有视图或触发器,则需要 CREATE VIEW 和 TRIGGER 权限。
3. 批量导入的账号
    - `LOAD DATA INFILE` 语句需要 FILE 权限
    - FILE 权限存在安全风险,因为它可以读取服务器上 MySQL 能查看的任何文件, 但可以通过 secure_file_priv 变量来限制只能读取某个目录
    - FILE 权限不能指定用于某个库或某个组件,它是一个全局权限, 可以将数据导入任何数据库,并从任何数据库中导出数据, 其中包括 mysql 数据库。
4. 用于授权的账号
    - 使其能创建并授权其他用户账号,需要在 GRANT 中加上 GRANT OPTION 子句
    - `GRANT ALL PRIVILEGES ON rookery.* TO 'admin_granter'@'localhost' IDENTIFIED BY 'avocet_123' WITH GRANT OPTION;`
5. 回收权限
    - `REVOKE ALL PRIVILEGES ON rookery.* FROM 'michael_stone'@'localhost';`
    - `REVOKE ALTER ON rookery.* FROM 'admin_restore'@'localhost';`
    - 某个用户可能对应多个账号
        - MySQL没有SHOW USERS语句, 因此只能`SELECT User, Host FROM mysql.user WHERE User LIKE '%michael%' OR User LIKE '%stone%';`
    - 在删除账号时,如果该账号已登录,并且有活动中的会话,那么这些会话都不会被停止
        - 强制终止 ` SHOW PROCESSLIST;`获取会话标识符，如1482， 接着使用`KILL 1482;`
    - SHOW PROCESSLIST 和 KILL 分别需 要PROCESS和SUPER权限。
6. 更改用户密码
    - 使密码过期 `ALTER USER 'admin_granter'@'localhost' PASSWORD EXPIRE;`
    - 修改密码 `SET PASSWORD FOR 'admin_granter'@'localhost' = PASSWORD('some_pwd_123');`
    - 忘记root密码的方法 -- P208
        1. 新建一个文本文件,输入以下内容,注意一行写一条语句:
        2. `UPDATE mysql.user SET Password=PASSWORD('new_pwd') WHERE User='root';`
        3. `FLUSH PRIVILEGES;`
        4. 将该文件起名为`rt-reset.sql`,并放在受保护的目录中。然后用 `--init-file`, 启动 MySQL，如下
        5. `mysqld_safe --init-file=/root/rt-reset.sql &`
        6. 启动后,登录 MySQL,看看密码是否已经修改。可以使用这种方式多次修改密码。改完之后,删除 rt-reset.sql
7. 角色
    - `CREATE ROLE 'admin_import_role';`
    - `GRANT FILE ON *.* TO 'admin_import_role'@localhost;`
    - 启用角色 `SET ROLE 'admin_import_role';` ... , `SET ROLE NONE;`


## 0x04 备份和恢复
1. mysqldump --> P214
    - 备份所有数据库 `mysqldump --user=admin_backup  --password --lock-all-tables --all-databases > /data/backups/all-dbs.sql`
    - MySQL 的工具过去常常提供一些简短形式的选项,比如用 `-u` 代表 `--user` 但是这些简短形式现在已不被推荐,甚至在未来的版本中可能会被取消。
    - 用 mysqldump 给 InnoDB 表或其他事务型的表做备份时,最好加上 `--single- transaction` 选项。这能提高数据的一致性。
    - 加上 `--ignore-table=mysql.user, 可以忽略mysql.user数据库
    - `--skip-extended-insert` 将多个插入语句扩展成一个, P216 有详细字段说明
    - `/*!` 是 MySQL 和 MariaDB 的条件性语句
    - dump文件说明 P215
    - 备份脚本 P221
2. 恢复备份
    - `mysql --user=admin_restore --password < rookery.sql`
    - 恢复表
        - 修改dump文件
        - 用临时数据库来做恢复
        - 使用受限的用户账号: 该账户支队要回复的表有权限，但该方法比较危险
        - 只回复某些行或某些列: 借助临时表
3. 二进制日志
    - 时间点恢复的前提条件是,你开启了二进制日志, `SHOW BINARY LOGS;`
    - 开启二进制日志的方法
        - 修改 MySQL 配置文件(可能是 my.cnf 或 my.ini),在 [mysqld] 那一部分中,加入以下语句:
        - `log-bin`
        - `binlog-ignore-db=mysql`
        - 重启 MySQL,以使配置生效, ` SHOW MASTER STATUS`查看日志是否生效
    - mysqlbinlog 抽取当前二进制日志的内容并将其保存到文本文件
        - `SHOW VARIABLES WHERE Variable_Name LIKE 'datadir';` 查看日志文件存放目录
        - `mysqlbinlog --database=rookery  /data/mysql/mysqlresources-bin.000002 > recovery-research.txt`
        - 从二进制日志中抽取语句并执行 **P232**
        - 二进制文件中 BEGIN 和 COMMIT 是事务开始和结束的标志 
        - 所谓事务,通常就是指一组同时执行且彼此相关的 SQL 语句。它只在事务性表(比如 InnoDB)上可用,而在非事务性表(比如 MyISAM)上不可用
        - 按照position恢复 `mysqlbinlog --database=rookery --start-position="1284889" --to-last-log ... `
        - 按照时间点恢复 `mysqlbinlog --database=rookery --stop-datetime="140916 13:10:24" ...`
        - `mysqlbinlog --database=rookery --start-datetime="140916 13:10:29" --to-last-log `
        - 二进制日志也可用于做备份,即 MySQL 复制, **主从备份**即是！
4. 备份策略 **P234**


## 0x05 导入导出

- 导入 LOAD DATA INFILE 

    ```sql

    -- 统一导入
    LOAD DATA INFILE '/tmp/Clements-Checklist-6.9-final.csv'
    INTO TABLE rookery.clements_list_import
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'  -- 指定域用的是双引号
    IGNORE 1 LINES;  -- 忽略指定的行数


    -- 导入对应的域
    LOAD DATA INFILE '/tmp/Clements-Checklist-6.9-final.csv' INTO TABLE rookery.clements_list_import
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    IGNORE 1 LINES
         (id, change_type, @niente, @niente,
         @niente, bird_order, family, @niente,
     @niente, @niente, @niente, @niente);  -- 那些不想要的域则被导入了临时变量 @niente

    -- 设置列（family）
    LOAD DATA INFILE '/tmp/Clements-Checklist-6.9-final.csv' INTO TABLE rookery.clements_list_import
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
    IGNORE 1 LINES
         (id, change_type, @niente, @niente,
         @niente, bird_order, @family, @niente,
         @niente, @niente, @niente, @niente, @niente)
    SET family = SUBSTRING(@family, 1, LOCATE(' (', @family) );

    -- 比较全的 
    LOAD DATA INFILE '/tmp/birdwatcher-prospects.csv'
    INTO TABLE birdwatchers.birdwatcher_prospects_import 
    FIELDS TERMINATED BY '|' ENCLOSED BY '"' ESCAPED BY '\\'
    LINES STARTING BY '[' TERMINATED BY ']\r\n'  -- STARTING BY 行以左中括号开头; TERMINATED BY指定行由右中括号、回车和换行符结尾
    IGNORE 1 LINES
    (prospect_name, prospect_email, prospect_country);

    ```

- 忽略错误，`LOAD DATA INFILE ... IGNORE INTO TABLE ...`
- 替换，`LOAD DATA INFILE ... REPLACE INTO TABLE ...`
- 使用mysqlimport, 所有的选项与LOAD DATA INFILE的一样,只是变成了小写,并以两个横杠开头, 但是没有`--lines-starting-by`选项,所以支持不够

    ```sql
    mysqlimport –user='marie_dyer' --password='sevenangels' \
    --replace --low-priority --ignore-lines='1' \
    --fields-enclosed-by='"' --fields-terminated-by='|' --fields-escaped-by='\\' \ --lines-terminated-by=']\r\n' \
    --columns='prospect_name, prospect_email, prospect_country' \
    birdwatchers '/tmp/birdwatcher_prospects_import.csv'
    ```

- 没有FILE权限也能导入数据 P253


## 0x06 编程接口

> P258


1. pythoni 可使用 `mysql.connector`
2. sql注入 -- 推荐使用占位符`?`，而不是字符拼接,前者会对传入的参数转义

    ```sql
    my $sql_stmnt = "SELECT human_id,
                          CONCAT(name_first, SPACE(1), name_last) AS full_name,
                          membership_expiration
                          FROM humans
                          WHERE name_last LIKE ?";    -- 问号是占位符


    $sql_stmnt = "SELECT common_name, scientific_name
                       FROM birds
                       WHERE common_name LIKE '%$search_parameter%'"  -- 字符拼接
    ```
