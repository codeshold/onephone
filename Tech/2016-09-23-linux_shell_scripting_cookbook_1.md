---
title: linux shell 学习摘记（1）
layout: post
author: WenfengShi
category: 技术
tags: [shell]
---
  
> 《linux shell 脚本编程攻略 （第2版）》 第一章 “小试牛刀” 笔记  

> 主要命令：`let`, `cat`, `变量字符串处理`, `数学计算`, `管道|`, `重定向`, `$`, `expr`, `bc`, `echo`, `$#`, `$*`, `$0`, `eval`, `tr`, `printf`, `read`, `tput`, `循环语句`, `条件语句`, `分隔符IFS`等

- 文本行`#!/bin/bash`中的`#!`读作 *shebang* （也可读做 *hashbang*，*pound-bang*）[参考维基](https://en.wikipedia.org/wiki/Shebang_(Unix))

- 终端打印除了`echo`命令还可以用`printf`（语法规则同C语言类似)，如`printf "%s %f\n" swf 1234`输出 *swf 1234.000000*

- 变量替换在单引号中无效

- 打印**彩色字体**，`echo -e "\e[1;31m This is red text \e[0m"`，`\e[1;31m`将颜色设为红色(`;`前的数字表示背景颜色，`;`后的表示字体颜色)，`\e[0m`将颜色重新置回

- 查询某程序运行时环境变量`cat /proc/进程ID/environca` (`pgrep gedit`查看程序gedit的PID，或使用`ps aux | grep gedit`查看)

- `tr`将输出重新格式化 `cat /proc/84354/environ | tr '\0' '\n'`
 
- 获取字符串长度`var=wenfeng; echo ${#var}`(助记:`#`是number sign)，获取当前使用的SHELL `echo $0`或`echo $SHELL`

- `${parameter:+expression}` 如果parameter有值且不为空，则使用expression的值。`prepend() { [ -d "$2" ] && eval $1=\"$2\$\{$1:+':'\$$1\}\" && export $1; } (`eval`可将多个参数整合成一个参数)

- 显示/修改Bash提示字符串`echo $PS1`/`PS1="wefeng"`

- shell数学运算

    1. `let` 变量名前不需要用`$`,如`let result=no1+no2; echo $result`
    2. `(())` 如`result=$(( no1 + 50 ))` 或 `result=$ (( $no1 + 50 ))`
    3. `[]` 如`result=$[ no1 + no2]`或`result=$[ $no1 + 5 ]`
    4. `expr` 如`result=反引号expr 3 + 4反引号` 或 `result=$(expr $no1 + 5)`
    5. `bc`命令（**支持浮点数**）`echo "scale=2;3/8" | bc` 设置小数位数为2; `echo "obase=2;$no" | bc`将数字转化为2进制; `echo "obase=10;ibase=2;$no" | bc` 将二进制转化为十进制

- 重定向 
    1. stderr转换成stdout重定向 `cmd 2>&1 stdout.txt` 或者 `cmd &> output.txt`
    2. `command | tee FILE1 FILE2` 接收来自stdin的数据，将副本写入FILE1和FILE2,同时也将副本左后后续命令的stdin
    3. `cmd -` 将stdin作为命令参数

- 脚本内部文件块重定向

```sh
#!/bin/bash
cat > log.txt <<EOF
This is a test log file.
Function: System statistics
EOF
```

或者

```sh
#!/bin/bash
cat<<EOF>log.txt
This is a test log file.
Function: System statistics
EOF
```

- 自定义文件描述符 `exec 3<input.txt` `exec 5>>output.txt`

```bash
[root@share codes]# cat log.txt 
This is a test log file.
Function: System statistics
[root@share codes]# exec 3<log.txt 
[root@share codes]# cat<&3
This is a test log file.
Function: System statistics
[root@share codes]# exec 5>>output.txt
[root@share codes]# echo newline >&5
[root@share codes]# cat output.txt 
newline
```

- 数组`array_var=(s w f)`, `echo ${array_var[0]}`打印一个元素, `echo ${#array_var[*]}`打印数组长度，`echo ${!array_var[*]}`打印出数组索引列表，`echo ${array_var[*]}` 打印出所有元素

- 关联数组（相当于字典）先声明`declare -A ass_array`，再赋值`ass_array=([index1]=val1 [index2]=val2)` 或者 `ass_array[index3]=val3` 其他操作同上，只是索引不再是数字了

- 当用alias设置了别名命令后，当不想用这个别名是，可对其进行转义即 `\command`

- 获取当前终端行数/列数/终端名 `tput lines`/`tput cols`/`tput longname`; `tput sc`存储光标位置, `tput rc`恢复光标位置 `tput ed`清除从当前光标位置到行尾之间的所有内容 （下面实现一个计时器）

```
#! /bin/bash

echo -n Count:
tput sc

count=0;
while true;
do
  if [ $count -lt 40 ];
  then
    let count++;
    sleep 1;
    tput rc
    tput ed
    echo -n $count;
  else exit 0;
  fi
done
```

- 通过stty实现 **输入密码时不应显示输入内容**（也可直接`read -s`启动slient模式，但stty更通用）

```
#!/bin/bash
echo -e "Enter password:"
stty -echo
read password
stty echo
echo
echo Password is $password
```

- `date +%s` 打印timestamp （从1970年1月1日0点开始的秒数）即POSIX时间; `date "+%d %B %Y"` 按格式输出

- 调试脚本
    1. `bash -x script.sh` 或 `sh -x script.sh`
    2. `set -x`和`set +x`(执行命令后会显示该指令及其参数);`set -v`当命令进行读取时显示输入，`set +v`进制打印输入 [详细介绍](http://man.linuxde.net/set)
    3. 将shebang从`#!/bin/bash` 改成 `#!/bin/bash -xv` 也可(`./script.sh`运行)
    4. 自定义格式显示调试信息，新建如下脚本，然后命令行键入 `[root@share codes]# _DEBUG=on sh debug.sh` (`:`告诉shell不进行任何操作)

```
#!/bin/bash

function DEBUG()
{
  [ "$_DEBUG" == "on" ] && $@ || :
}

for i in {1..10};
do
  DEBUG echo $i
done
```

- 函数和参数
    1. `$@` 被扩展成 `$1 $2 $3`等
    2. `$*` 被扩展成`$1c$2c$3`(c是IFS的第一个字符, IFS即internal field seprator, `env | grep IFS`或`set | grep IFS`查看)
    3. `$?` 获取命令或函数的返回值
    4. "$@" 比 "$*" 更常用，后者会把所有参数当作单个字符串处理
    5. 递归 `F() { echo $1; F hello; sleep 1; } `，这是 **fork bomb** `:(){ :|:& };:` （可通过修改`/etc/security/limits.conf`或命令`ulimit`来限制生成的最大进程数）[维基扩展](https://en.wikipedia.org/wiki/Fork_bomb)
    6. 导出函数 `export -f fname` 可将函数的作用域扩展到子进程中
    7. 向命令传递参数的方式`command -p -v -k 1 file`或者`command -pv -k1 file`或者`command -pvk 1 file`或者`command file -pvk 1`

- 存储命令的输出
    1. `$(  )` 通过子shell方式， 如 `output=$(ls | cat -n)` 子shell里面的变化如`cd XX`等不会反应到主shell中
    2. 反引用方式(通过**反引号**)
    3. 可将子shell或反引用放入以个双引号中，以保留空格和换行符(\n)

```
cmd_output=`ls | cat -n`
echo $cmd_output
```

- `read -n 5 -s -t 2 -d ":" -p "Enter your password:" var` 从输入中以**无回显**的方式读取5个字符并存入变量var中，且需要在2秒内输入，以**:**作为输入行的结束符，终端会有"Enter your password:"的提示

- `true`作为`/bin`中的一个二进制文件来实现的，即表示每执行一次便会生成一个进程，若不想则可以通过内建的`:`命令（其总会返回0）

```shell
[root@share codes]# repeat() { while :; do $@ && return; sleep 30; done }
[root@share codes]# repeat wget -c http://www.wenfengbaidu.com/
```
 
- 字段分隔符 IFS

```
#!/bin/bash -xv

line="shares:x:503:lu,han,lei,wenfeng,yuxuan,ming"
oldIFS=$IFS
IFS=":"
count=0
for item in $line; do
    [ $count -eq 0 ] && user=$item;
    [ $count -eq 3 ] && members=$item;
    if [[ "$members" != "" ]]; then
        IFS=",";
        no=1;
        for name in $members; do
            echo "NO. $no: $name"
        let no++
        done
    fi
    let count++
done
IFS=$oldFIS
echo "This is $user group"
```

- 循环语句 `for in do done`, `while do done`, `until do done` 连写成一行时,do前要用`;`

- 比较语句 `if then fi`, `if then else if then else fi` 连写成一行时，then前用`;`
    1. `[ condition ] && action` 或 `[ condition ] || action`
    2. 算数比较 -eq, -ne, -lt, -ge, -le; `[ $var1 -ne 0 -a $var2 -gt 2 ]`（AND条件用`-a`,OR条件用`-o`），也可分开用类似`[  ] && [  ]`
    3. 文件系统相关测试 -f, -d, -e, -b, -w, -r, -x, -L (用`[  ]`)
    4. 字符串比较 `[[  ]]` (-z, -n , ==, !=)

