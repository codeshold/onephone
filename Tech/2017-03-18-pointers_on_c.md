---
title: 
layout: post
author: WenfengShi
category: 技术
tags: []
---
博客链接: [http://codeshold.me/2017/03/pointers_on_c.html](http://codeshold.me/2017/03/pointers_on_c.html)

1. c对数组下标引用和指针访问不进行有效性检测，缺少了安全性，进而有了效率
2. 注释不允许嵌套（若出现，则可能会有意想不到的结果），因此代码注释建议使用`#if 0 ...... #endif`
3. `gets()`从标准出入读取一行输入（以换行符结束），其会丢弃该行末尾的`\n`，并在行末尾添加一个`NUL`，若没有数据，则返回NULL；`puts()`把指定的字符串输入到标准输出，并在末尾添加一个`\n`
4. `int ch; ch = getchar(); while( (ch != EOF) && (ch != '\n' );` char声明为int类型，是因为`EOF`是一个整型值（这样可防治从输入读取的字符意外的被解释为EOF）
5. 使用`perror()`, `errno.h`; `exit(EXIT_SUCCESS)`, `exit(EXIT_FAILTURE)`, `stdlib.h`
6. `printf()`后面使用`fflush(stdout)`
7. `FOPEN_MAX`, `FILENAME_MAX`
8. `fgetc`, `fputc` 都是真正的函数，但`getc`, `putc`, `getchar`, `putchar`都是通过`#define`指令定义的宏, `ungetc()`撤销自负IO

