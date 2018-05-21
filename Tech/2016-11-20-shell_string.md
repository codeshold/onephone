---
title: shell内置字符串处理
layout: post
author: WenfengShi
category: 技术
tags: [shell]
---

> 总结了shell中内置的字符串处理功能，包括`> ${} # % :- :+ ?` 等的使用
> 使用内置操作符处理字符串时，性能较好

## 赋值处理
1. `${string-word}` : 如果string没设定，则使用word作为返回值(空值和非空值不做处理)
2. `${string:-word}`: 如果string没设定或为空值，则使用word作为返回值(非空值时不做处理) **经常使用**
3. `${string+word}` : 如果string设定了(空值或非空值)，则使用word作为返回值(没有设定不做处理)
4. `${string:+word}`: 如果string为非空值，则使用word作为返回值(没设定或空值时不做处理)
5. `${string=word}` : 如果string没设定，则使用word作为返回值，同时将word值赋值给string
6. `${string:=word}`: 如果string没设定或为空值，则使用word作为返回值，同时将word复制给string
7. `${string?word}` : 如果string没有设定，则将word输出到STDERR(空值及非空值不做处理)
8. `${string:?word}`: 如果string没设定或为空值，则将word输出到STDERR(非空值不做处理)

## 获取字符串长度
`${#string}`(`＃`号也称为为number sign)

## 字符串删除
设定`string='http://www.codeshold.me/2016/11/mac_skills.html'`
1. `${string#*/}` : 删掉第一个`/`及其左边的字符串，返回:`/www.codeshold.me/2016/11/mac_skills.html`
2. `${string##*/}`: 删掉最后一个`/`及其左边的字符串， 返回`mac_skills.html`
3. `${string%/*`} : 删掉最后一个`/`及其右边的字符串，返回`http://www.codeshold.me/2016/11`
4. `${string%%/*}`: 删除第一个`/`及其右边的字符串，返回`http:`
5. 类似的有`${string#*.}`删掉第一个`.`及其左边的字符串，`${string%.*}`删掉最后一个`.`及其右边的字符串

> 记忆方法：
> `#` 表示从左往右匹配（键盘上 `#` 在 `$` 的左边）
> `%` 表示从右往左匹配（键盘上 `%` 在 `$` 的右边）
> 单一符号是最小匹配(非贪婪)；两个符号是最大匹配(贪婪匹配)
> `${变量名#substring正则表达式}`从字符串开头开始配备substring,删除匹配上的表达式
> `${变量名%substring正则表达式}`从字符串结尾开始配备substring,删除匹配上的表达式

## 字符串截取
设定`string=abcdefg`，字符串的下标从0开始
1. `${string:2}`    : 返回string中从第3个到结束的所有字符，即cdefg
2. `${string:0}`    : 返回string中从第1个到结束的所有字符，即abcdefg
3. `${string:0:5}`  : 返回string中从第1个开始的5个字符，即abcde
4. `${string:0-1}`  : 返回string中最后一个字符, 即g
4. `${string:0-3}`  : 返回string中从倒数第3个字符到结束的所有字符, 即efg
5. `${string:0-3:2}`: 返回string中从倒数第3个字符开始的2个字符，即ef

> 记忆方法：
> `${string:开始:长度}`

## 字符串替换
设定`string=/dir1/dir2/dir3`
1. `${string/dir/swf}`  : 将第一个dir替换成swf，返回`/swf1/dir2/dir3`
2. `${string//dir/swf}` : 将全部的dir替换成swf，返回`/swf1/swf2/swf3`

> 记忆方法：
> 两个符号`//`表示贪婪匹配(全部替换)
> `${变量/查找/替换值}`查找中出现了”/”要加转义符”\/”表示

