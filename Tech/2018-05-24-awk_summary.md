# awk命令总结
> 参考网站
http://www.grymoire.com/Unix/Awk.html
https://www.gnu.org/software/gawk/manual/

- awk命令基本格式
    `pattern {commands}`
- 测试文件生成
    `netstat -anlp > netstat.txt`

## 示例
> 过滤、匹配、统计

- Example
    ```
    # 过滤记录
    $ awk '$3==0 && $6=="LISTEN" ' netstat.txt

    # 过滤记录
    $ awk ' $3>0 {print $0}' netstat.txt

    # 保留表头
    $ awk '$3==0 && $6=="LISTEN" || NR==1 ' netstat.txt

    # 格式化输出
    $ awk '$3==0 && $6=="LISTEN" || NR==1 {printf "%-20s %-20s %s\n",$4,$5,$6}' netstat.txt

    # 制定多个分隔符
    $ awk -F '[;:]'  # 分隔符为;和:
    $ awk -F '501'   # 分隔为501
    $ awk  -F: '{print $1,$3,$6}' OFS="\t" /etc/passwd          # 分隔符为:
    $ awk  'FS="[:/]" {print $1,$3,$6}' OFS="\t" /etc/passwd    # 分隔符为:和/
    $ awk  'FS="::/" {print $1,$3,$6}' OFS="\t" /etc/passwd     # 分隔符为 ::/ 组合字符串

    # 匹配整行
    $ awk '/LISTEN/' netstat.txt
    $ awk '$0 ~ /LISTEN/' netstat.txt   #   效果同上

    # 匹配某个Field
    $ awk '$6 ~ /FIN/ || NR==1 {print NR,$4,$5,$6}' OFS="\t" netstat.txt
    $ awk '$7~/LISTEN/ && $8~/248/' OFS="\t" netstat.txt

    # 取反匹配
    $ awk '$6 !~ /WAIT/ || NR==1 {print NR,$4,$5,$6}' OFS="\t" netstat.txt
    $ awk '!/WAIT/' netstat.txt

    # 文件拆分
    $ awk 'NR!=1{if($6 ~ /TIME|ESTABLISHED/) print > "1.txt";
    else if($6 ~ /LISTEN/) print > "2.txt";
    else print > "3.txt" }' netstat.txt

    # 统计
    $ awk 'NR!=1{a[$6]++;} END {for (i in a) print i ", " a[i];}' netstat.txt
    $ ps aux | awk 'NR!=1{a[$1]+=$6;} END { for(i in a) print i ", " a[i]"KB";}'

    ```

## Pattern说明

    ```
    # All relational tests can be used as a pattern. 
    NR <= 10 {print} 等同于 {if (NR <= 10 ) {print}}

    /special/ {print} 等同于 $0 ~ /special/ {print} 等同于 {if ($0 ~ /special/) {print}}

    ($0 ~ /whole/) || (($1 ~ /part1/) && ($2 ~ /part2/)) {print}    # 有()时,测试对象必须指定，即$0, $1等

    NF == 3 ? NR == 10 : NR < 20 { print }

    # The comma separated pattern
    (NR==20),(NR==40) {print}   # between 20 and 40
    (NR==1),/stop/ {print}      # between 1 and the line containing 'stop'
    /start/,/stop/ {print}      # between the line containt 'start' and ...
      功能等同于
    {
      if ($0 ~ /start/) {
        triggered=1;
      }
      if (triggered) {
         print;
         if ($0 ~ /stop/) {
        triggered=0;
         }
      }
    }
    ```

## 变量
- 主要的内建变量
    - `$0`	当前记录（这个变量中存放着整个行的内容）
    - `$1~$n`	当前记录的第n个字段，字段间由FS分隔
    - `FS`	输入字段分隔符 默认是空格或Tab
        - FS - The Input Field Separator Variable
    - `NF`	当前记录中的字段个数，就是有多少列
        - NF - The Number of Fields Variable
    - `NR`	已经读出的记录数，就是行号，从1开始，如果有多个文件话，这个值也是不断累加中。
        - NR - The Number of Records Variable
    - `FNR`	当前记录数，与NR不同的是，这个值会是各个文件自己的行号
    - `RS`	输入的记录分隔符， 默认为换行符
        - RS - The Record Separator Variable
    - `OFS`	输出字段分隔符， 默认也是空格
        - OFS - The Output Field Separator Variable
    - `ORS`	输出的记录分隔符，默认为换行符
        - ORS - The Output Record Separator Variable
    - `FILENAME`	当前输入文件的名字
        - FILENAME - The Current Filename Variable
- 关联数组 Associative Array
    ```
    # An associative array in an array whose index is a string.
    $ awk '
    BEGIN {FS=":"}
    { login[$7]++;}
    END { print "\n"; for( i in login) print i, login[i]}
    ' /etc/passwd

    # unix guru's choice
    $ awk '{print $7}' /etc/passwd | sort | uniq -c | sort -nr

    # multi-dimensional array
    a[1 "," 2] = y; # ok
    a[1, 2] = y;    # error
    ```
- 环境变量的使用
    ```
    # 使用`-v`参数和`ENVIRON`，使用`ENVIRON`的环境变量需要`export`
    $ x=5
    $ y=10
    $ export y
    $ echo $x $y
    5 10
    $ awk -v val=$x '{print $1, $2, $3, $4+val, $5+ENVIRON["y"]}' OFS="\t" score.txt

    # The quotes toggle a switch inside the interpretor.
    column=${1:-1}
    awk '{print $'$column'}'

    # FS动态修改
    # 去除源文件中的特定字段
    $ awk 'BEGIN{FS=":"; OFS=":"} {$3="";$4=""; print}' /etc/passwd # print默认打印 $0
    #!/bin/awk -f
    {
        if ( $0 ~ /:/ ) {
            FS=":";
            $0=$0
        } else {
            FS=" ";
            $0=$0
        }
        #print the third field, whatever format
        print $3
    }
    ```

## 函数
- 控制：exit, conintue, next
- 用户定义函数
- 数学函数:  Trigonometric Functions, Exponents, logs and square roots, Truncating Integers, Random Numbers,
- 时间函数:  function, The Split function,
- 字符串函数: The Length function, The Index Function, The Substr
    ```
    # length
    length("hello") < 80

    # index
    if (index(sentence, ",") > 0) {
    printf("Found a comma in position \%d\n", index(sentence,","));
    }

    # substr
    substr(string,position)
    substr(string,position,length)

    # split
    BEGIN {
        string="This is a string, is it not?";
        search=" ";
        n=split(string,array,search);
        for (i=1;i<=n;i++) {
            printf("Word[%d]=%s\n",i,array[i]);
        }
    }

    # lower
    print tolower($0);

    # sub() and gsub() returns a positive value if a match is found 
    sub(/old/, "new", string)   # only changes the first occurrence
    gsub(/old/, "new", string)  # all occurrence are converted

    # match
    {
        regex="[a-zA-Z0-9]+";
        if (match($0,regex)) print;
    }

    # system
    {
        if (system("/bin/rm junk") != 0)
        print "command didn't work";
    }

    # getline -- a command that allows you to force a new line. It doesn't take any arguments. It returns a 1, if successful, a 0 if end-of-file is reached, and a -1 if an error occurs.
    {
        line = substr(line,1,length(line)-1);
        i=getline;
        if (i > 0) {
            line = line $0;     # getline
        } else {
            printf("missing continuation on line %d\n", NR);
        }
    }
    # systime, strftime
    {
       ts = systime();
       one_day = 24 * 60 * 60;
       next_week = ts + (7 * one_day);
       format = "%a %b %e %H:%M:%S %Z %Y";
       print strftime(format, next_week);
    }

    # User Defined Functions
    #!/usr/bin/nawk -f
    {
        if (NF != 4) {
            error("Expected 4 fields");
        } else {
            print;
        }
    }
    function error ( message ) {
        if (FILENAME != "-") {
            printf("%s: ", FILENAME) > "/dev/tty";
        }
        printf("line # %d, %s, line: %s\n", NR, message, $0) >> "/dev/tty";
    }
    ```

- PRINTF输出
    ```
    #运行前
    BEGIN {
        math = 0
        english = 0
        computer = 0
     
        printf "NAME    NO.   MATH  ENGLISH  COMPUTER   TOTAL\n"
        printf "---------------------------------------------\n"
    }
    #运行中
    {
        math+=$3
        english+=$4
        computer+=$5
        printf "%-6s %-6s %4d %8d %8d %8d\n", $1, $2, $3,$4,$5, $3+$4+$5
    }
    #运行后
    END {
        printf "---------------------------------------------\n"
        printf "  TOTAL:%10d %8d %8d \n", math, english, computer
        printf "AVERAGE:%10.2f %8.2f %8.2f\n", math/NR, english/NR, computer/NR
    }

    # printf 写入到文件
    printf("string\n") > "/tmp/file";   # Create
    printf("string\n") >> "/tmp/file";  # Append
    # AWK chooses the create/append option the first time a file is opened for writing. Afterwards, the use of ">" or ">>" is ignored.
    {
        print $0 >>"/tmp/a" # Append
        print $0 >"/tmp/b"  # Append
    } 
    ```
