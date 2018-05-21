---
title: 中毒U盘恢复--快捷键病毒
layout: post
author: WenfengShi
category: 技术
tags: [script]
---

> 在连续三次帮同一个好朋友修复中毒U盘之后，我决定写一个简单的脚本了...

## 0. 前言
- 用于修复中了“快捷方式病毒”的U盘
- 对windows下CMD.exe了解一点的，可直接参考**1.1**，直接手动输命令(耍帅很有用的)
- **最简单**的，拷贝**1.2**中的代码，保存到一个txt文件中，后缀名修改为bat，点击运行就行


## 1. 修复方法

### 1.1 手动修复("耍帅"技巧，我一直这么干的)
1. 打开CMD.exe
2. 进入U盘目录下，如`F:`
3. `attrib /s /d -s -h -a` 恢复所有被隐藏的文件
4. `del  /a /q /s *.lnk` 删除所有快捷方式
5. `del *.vbs ` 删除U盘主目录下的vbs文件

### 1.2 自动脚本
新建一个txt文件，将下列代码复制到文件内，保存后将文件后缀名修改bat，然后点击运行！

```bat

@echo off
title 中毒U盘恢复程序（快捷方式病毒）


:start
echo.
echo 请输入U盘对应的磁盘符号(如F)
set /p drive=
if exist %drive%:\ (
    if "%drive%"=="C" goto warning
    if "%drive%"=="c" goto warning
    goto dealing
) else (
    goto warning
)


:dealing
echo.
echo 正在恢复被隐藏的文件...
attrib /s /d -s -h -a %drive%:\*.*

echo.
echo 正在删除快捷方式...
del /a /q /s %drive%:\*.lnk

echo.
echo 正在删除vbs病毒文件...
del /a /q /s %drive%:\*.vbs

echo.
echo U盘修复成功! (有问题欢迎邮件wuzhimang@gmail.com)
echo.
echo 按任意键退出
set /p "end="
goto end

:warning
echo.
echo U盘标签未发现
echo.
echo 请插入U盘或输入正确的标签
echo.

pause

:end

```



