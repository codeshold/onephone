---
title: 实用的四个shell编程题
layout: post
author: WenfengShi
category: 私库
tags: [shell, leetcode]
---

> 4个用来测试自己shell编程能力的题(面试题)，同时也是比较实用的四个小脚本。源自[leetcode](https://leetcode.com/problemset/shell/)


## 1. 词频统计
统计文本content.txt中每个单词的出现的频率，不区分大小写，不统计数字和符号
- `cat content.txt | awk '{for(i=1;i<=NF;i++){count[$i]++}} END{for(i in count){print i"\t" count[i]}}' | sort -k2nr | head -n 10`
- `cat content.txt | tr '[:upper:]' '[:lower:]' | tr -cs '[:alpha:]' '\n' | sort | uniq -c | sort -rn | head -n 10`


## 2. 合法号码判断
xxx-xxx-xxxx 或 (xxx) xxx-xxxx格式的为合法号码
- `grep -E "^([0-9]{3}-|\([0-9]{3}\) )[0-9]{3}-[0-9]{4}$" file.txt`
- `sed -n -r '/^([0-9]{3}-|\([0-9]{3}\) )[0-9]{3}-[0-9]{4}$/p' file.txt`
- `awk '/^([0-9]{3}-|\([0-9]{3}\) )[0-9]{3}-[0-9]{4}$/' file.txt`


## 3. 文本行列转置
即写一个脚本，文本内容如下

> one phone
> 1 2
> wen feng 

通过执行反转脚本后，输出内容如下
> one 1 wen
> phone 2 feng

- 可执行脚本1

``` bash
awk '
{
    for (i=1; i<=NF; i++) {
        if (NR == 1){
            tmp[i] = $i;
        } else {
            tmp[i] = tmp[i] " " $i;
        }
    }
}
END {
    for (i=1; tmp[i] != ""; i++){
        print tmp[i];
    }
}' file.txt

```

- 可执行脚本2

``` bash
count=`head -n 1 file.txt | wc -w`

for i in `seq 1 $count`
do
    echo `cut -d ' ' -f $i file.txt`
done

```


## 4. 显示文件file.txt的第n信息
- `awk 'NR==10' file.txt`
- `awk '{ if(NR==10) print $0 }' file.txt`
- `awk '{ if(NR==10) print}' file.txt`
- `head -n 10 file.txt | tail -n 1` (当行数不小于10时，正确)
- shell script

```bash
count=0
while read line && [ $count -le 10 ];do
    let 'count++'
    [ $count -eq 10 ] && echo $line && exit
done < file.txt
```

## 5. 参考
[leetcode](https://leetcode.com/problemset/shell/)
