---
title: linux shell 学习摘记（2） 
layout: post
author: WenfengShi
category: 技术
tags: [shell]
---

> 《linux shell 脚本编程攻略 （第2版）》 第二章 “命令之乐” 笔记

>  **主要命令**: `cat`, `script`, `scriptreplay`, `find -exec`, `xargs`, `tr`, `md5sum`, `sha1sum`, `md5dep`, `crypt`, `gpg`, `base64`, `opensslpasswd`, `sort`, `uniq`, `mktemp`, `split`, `csplit`, `${URL%*.}`, `${URL##*.}`, `rename`, `look`, `echo -e`, `grep -q`, `PIDARRAY+=("$!")`, `expect`等

- `-`被作为stdin文本的文件名，如`echo "hello" | cat - file.txt`

- `cat -s file.txt` 可压缩相邻的空白行; `cat -T file.py` 能将制表符标记成`^|`(**对python等文件很有用**); `cat -n` 显示行号（其也会为空白行添加行号，加`-b`可跳过空白符）

- **录制并回放终端会话**
    1. 开始录制会话`script -t 2> timing.log -a output.session`，录制完后键入`exit`退出，最后通过`scriptreplay timing.log output.session`回放
    2. timing.log 用来存在时序信息（`-t`参数表示将时序信息重定向到stderr） output.session 存储命令输出信息

- **find**
    1. `find . -name "*.txt"`， `find . -iname "example*"`忽略大小写
    2. `find . \( -name "*.txt" -o -name "*.sh" \)` 打印出所有的.txt和.sh文件
    3. `find /home/swf -path "*/hello/*"` 使用`-path`来匹配文件路径；`find . -iregex ".*\(\.py\|\.sh\)$"` 通过正则表达式来匹配.py和.sh文件，且忽略`find . -iregex ".*\(\.py\|\.sh\)$"`忽略大小写
    4. `find . ! -name "*.txt"` 否定查询
    5. `find . -maxdepth 3 -mindepth 1 -name "f*"` 基于目录深度的搜索
    6. `find . -type d` 查找目录(f/l/c/b/s/p)，s表示套接字设备，p表示FIFO
    7. `-atime -mtime -ctime` 访问时间、文件内容修改时间、文件元数据修改时间(权限、所有权)；`-atime -7`表示最近7天内，`-atime 7`恰好在七天前， `-atime +7` 超过七天, 如`find . -type f -atime +7`; 类似的有`-amin -mmin -cmin`（基于分钟的参数） 
    8. `-size +2k`, `-size 2k`, `-size -2k`按文件大小（大于，等于，小于）
    9. 删除当前目录下的.swp文件，`find . -type f -perm 644 -name "*.swp" -delete`
    10. `find . -name "*.c" -exec cat {} \; > all_c_files.txt` find同命令结合 
    11. `find . \( -name ".git" -prune \) -o \( -type f -print \)` 不包含在.git目录中的所有文件名（若前者为真则后者不执行）

- **xargs**能把从stdin接收到的数据重新格式化，再将其作为参数提供给其他命令
    1. `cat example.txt | xargs -d X -n 3` 以X为定界符, 每行2个参数
    2. `cat args.txt | xargs -n 1 ./cecho.sh`, `cat args.txt | xargs -I {} ./cecho.sh -p {} -l`，其中{}会进行扩充
    3. 删除特定系列文件`find . -type f -name "*.txt" -print0 | xargs -0 rm -rf"`
    4. 统计每个文件的行数和总行数 `find . -type -f -name "*.md" -print0 | xargs -0 wc -l`

- `cat files.txt | ( while read arg; do cat $arg; done; )`相当于`cat files.txt | xargs -I {} cat {}`

- `echo file.txt | tr 'a-zA-Z' 'n-za-mN-ZA-M'`，`tr -d '0-9'`删除指定集合中的字符, `tr -d -c '0-9 \n'将不在集合中的所有字符删除, `tr -s ' '`将连续空格压缩为一个空格
    1. 将文件中的数字叠加 `cat sum.txt | echo $[ $( tr '\n' '+' ) 0]`
    2. 支持字符类 `tr [:lower:] [:upper:]`

- 加密和散列
    1. `md5sum -c *.md5`, `sha1sum -c *.sha1` 检查校验和
    2. 对目录进行校验 `md5dep -rl . > dircetory.md5`(-r 递归方式， -l 相对路径); `find . -type f -print0 | xargs -0 md5sum >> directory.md`
    3. `crypt <input_file >output_file`加密， `crypt PASSPARSE -d <encryptedfile >outputfile`解密；`gpg -c filename`加密，`gpg filename.gpg`解密; `base64 -d file > outputfile`
    4. shadow-like散列, salt --> `opensslpasswd -1 -salt SALTSTRING PASSWORD`(类似`/etc/shadow`)[维基参考](http://en.wikipedia.org/wiki/Salt_(cryptography))

- `sort -nrk 1 data.txt` -nr表明按照数字，采用逆序排列（默认是按照字母表排序), `-k 1`表示按照第一列排序；`sort -z data.txt | xargs -0`; `sort -bd unsorted.txt` -b忽略文件中的前导空白行，-d表明用字典排序

- `uniq -u sorted.txt`只显示第一行，`-c`统计各行出现的次数， `-d` 找出重复的行；`sort data.txt | uniq -s 2 -w 2` -s指定可以跳过前2个字符；-w指定用于比较的最大字符数；`uniq -z file.txt | xargs -o rm`

- `mktemp -d`, `mktemp test.XXX`根据模版创建临时文件，（保证至少有3个X）

- `split -b 10k data.file -d -a 4 splitfile` -d 表示以数字为后缀， -a 表示后缀长度；`-l`可以通过行来进行切分。**但split只能通过文件大小和行来进行切分**

- `csplit server.log /SERVER/ -n 2 -s {*} -f server -b "%02d.log" ; rm server00.log` 按日志文件中的某个单词或内容进行切割。
    1. `/[REGEX]/`表示文本样式，用来匹配某一行
    2. `{*}` 表示匹配重复的次数，中间数字若为`*`则表示匹配直到文件结尾
    3. `-s`静态模式， `-n` 分割后的文件名后缀的数字数， `-f` 分割后的文件名前缀， `-b` 指定后缀格式（同fprint）

- 扩展名切分, `%`表示从右向左进行匹配，删除匹配的到的内容（非贪婪）,`%%`同%但是**贪婪匹配**；`#`表示从左向右匹配，删除匹配到的内容（非贪婪），`##`同#但是**贪婪匹配

```shell
[root@share codes]# URL="www.baidu.com"
[root@share codes]# echo ${URL%.*}
www.baidu
[root@share codes]# echo ${URL%%.*}
www
[root@share codes]# echo ${URL#*.}
baidu.com
[root@share codes]# echo ${URL##*.}
com
```

- `rename 's/ /_/g' *` 将文件名中的空格替换成字符`_`；`rename 'y/A-Z/a-z/' *`转换文件名的大小; `find . -type f -name "*.mp3" -exec mv {} targetdir \;` 移动mp3文件到特定的目录下；`find . -type -f -exec rename 's/ /_/g' {} \;`

- `[ -z $output ]` 用于判断output是否为空

- `grep "^word" /usr/share/dict/words -q`; `look word`列出默认字典中所有的单词, `look word /home/wenfeng/test.txt`列出文件中以word起头的所有单词

- `echo -e "\nhello\n" ` **expect**可实现交互式输入

- 利用并行进程进行加速 `$!`最近一个后台程序的PID

```shell
#!/bin/bash
PIDARRAY=()
for file in File1.iso File2.sio;
do
    md5sum $file &
    PIDARRAY+=("$!")
done
wait ${PIDARRAY[@]} # 或者 wait ${PIDARRAY[*]}

```
