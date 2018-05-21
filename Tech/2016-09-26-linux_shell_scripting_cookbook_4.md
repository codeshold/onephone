---
title: linux shell 学习摘记（4）
layout: post
author: WenfengShi
category: 技术
tags: [shell]
---

>《linux shell 脚本编程攻略 （第2版）》 第四章 “让文本飞起来” 笔记  
  
> 主要命令: `正则表达式`, `grep/egrep`, `sed`, `awk`, `cut`, `find`, `xargs`, `tr`, `变量切片`  
  
- 正则表达式 [详细参考](http://opensourceforu.com/2011/04/sed-explained-part-1/)  
    1. `ma(tri)?x` 匹配max或matrix  
    2. `Oct (1st|2nd)` 匹配 Oct 1st 或者 Oct 2nd  
    3. [将正则表达式可视化](https://regexper.com/)  
  
- **grep**  
    1. `grep -E "[a-z]+" filename` 和 `egrep "[a-z]+" filename`;  
    2. `echo this is a line. | egrep -o "[a-z]+\." 只输出文件中匹配到的文本部分,`-v`打印出匹配行之外的所有行  
    3. `grep -c "text" filename` 统计匹配行的数量，并不是匹配数目; `echo -e "1 2 3 4 \nhello\n 6" | egrep -o "[0-9]" | wc -l`  
    4. `grep linux -n XXX`包含匹配字符串的行号；`grep -b -o "not" XXX` 打印模式匹配所位于的字符或字节偏移  
    5. `grep -l linux sample1.txt sample2.txt` 搜索多个文件并找出文本位于哪一个文件中  
    6. `grep "text" . -R -n` 递归搜索， `-i`忽略大小写  
    7. `grep -e "pattern" -e "pattern"`匹配多个样式  
    8. `grep -f pattern_filesource_filename` 匹配模式文件， `--include *.{c, cpp}`, `--exclude "README"`  
    9. `grep "test" file* -lz | xargs -0 rm` 以0值字节作为终结符的文件(\0)  
    10. 可打匹配结果前后的内容, 如`seq 10 | grep 5 -A 3` 匹配某结果之后的3行， `-B`匹配某个结果之前的几行， `-C` 匹配某个结果之前和之后的几行  
  
- `cut -f3 --complement student_data.txt` 打印出第3列之外的所有列  
  
- cut还可将一串指定的字符作为列来显示 `cut fields.txt -c1-3,6-9 --output-delimiter "," 提取第1-3字符为第一列6-9字符为第二列， 以`,`为区分， 还可更换参数为`-b` 按字节， `-f`用于自定义字段  
  
- **sed**  
    1. sed: Stream Editor 默认情况下sed只会打印替换后的文本，若要同时保存到源文件需要`-i`选项， `/`在sed为定界符，同样也可以使用`:`,`|`  
    2. 移除空白行 `sed -i "/^$/d" file`  
    3. `sed -i 's/\b[0-9]\{3\}\b/NUMBER/g` file.txt `\b`表示文件边界  
    4. `sed -i .bak 's/abc/def/' file` sed执行替换时，会穿件一个名为file.bak的原始文件副本  
    5. 已匹配字符串标记`$`, `echo this is an example | sed 's/\w\+/[&]/g'  
    6. 子串匹配标记`(\1)`  
    7. 组合多个表达式 `sed 'expression' | sed 'expression'`或`sed 'expression;expression'`或`sed -e 'expression' -e 'expression'`  
    8. sed 表达式通常用单引号引用，不过也可以用双引号（有变量时会很有用）。其会先对表达式求职然后在进行应用。 `sed "s/$text/HELLO/"`  
  
- **awk**  
    1. `awk`脚本被包含在单引号或双引号之间  
    2. 在awk中`print`的参数是以逗号进行分隔的，打印时以空格为定界符，而双引号被作为拼接符  
  
```shell  
awk 'BEGIN { begin statements } pattern {　commands } END { end statements }'  
  
awk '{ print 1 "-" 2 "-" 3;}'  
awk '{ print 1,2,3; }'  
```  
  
- 压缩或解压JavaScript **下面是列子，并不能实际用** 请依赖专业的工具  
    1. 压缩 `cat sample.js | tr -d '\t\n' | tr -s ' ' | sed 's:/\*.*\*/::g' | sed "s/ \?\([{}();,:]\) \?/\1/g'`  
    2. 解压 `cat obfuscated.txt | sed 's/;/;\n/g' | sed 's/{/{\n\n/g' | sed 's/}/\n\n/g' `  
  
- 按列合并多个文件 `paste file1.txt file2.txt -d ","`  
  
- 打印文件中的第五列 `awk '{ print $5 }' filename`， 打印当前目录下各个文件的权限`ls -l | awk '{ print $1 " : " $8 } filename`  
  
- 对目录中所有的文本进行替换  
    1. `find . -name *.cpp -print0 | xargs -I{} -0 | sed -i 's/Copyright/Copyleft/g' {}`  
    2. `find . -name *.cpp -exec sed -i 's/Copyright/Copyleft/g' \{\} \;` 为每一个超找到的文件调用一次sed  
    3. `find . -name *.cpp -exec sed -i 's/Copyright/Copyleft/g' \{\} \+` 将多个文件名一并传给sed  
  
- 切片  


```  
[root@share ~]# var=shiwenfeng  
[root@share ~]# echo ${var/shi/yes/}  
yes/wenfeng  
[root@share ~]# echo ${var:4}  
enfeng  
[root@share ~]# echo ${var:4:2}  
en  
[root@share ~]# echo ${var:(-1)}  
g  
[root@share ~]# echo ${var:(-2):2}  
ng  
[root@share ~]#   
```  
