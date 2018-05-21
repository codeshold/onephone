---
title: Shell Shortcuts（和Tab键一样实用）
layout: post
author: WenfengShi
category: 技术
tags: [shell]
---

> 总结并列举了15个有用的shell快捷键（基本都和Tab键一样实用），能有效的**加快**命令输入速度，只要记住了就基本会去用的键！


以Windows下Git shell的截图为例（助于理解）：

![命令行示意图](http://static.zybuluo.com/wuzhimang/4wo449hali113jcdsuz5lspz/image_1asm2ur1j6gqqdr15s7qc59a49.png)

## 快捷键
1. `Ctrl + A`：将光标移到**行首**
2. `Ctrl + E`：将光标移到**行尾**
14. `Alt + F`：将光标**向右**移动一个word --> 可能会失效，见**说明**
15. `Alt + B`：将光标**向左**移动一个word --> 可能会失效，见**说明**
4. `Ctrl + K`：删除光标**右边**的所有内容（即一直删到行尾）
3. `Ctrl + U`：删除光标**左边**的所有内容（若光标在行尾，则删除整行）
6. `Alt + D`：删除光标**右边**的一个word --> 可能会失效，见**说明**
5. `Ctrl + W`：删除光标**左边**的一个word
6. `Ctrl + L`：清空屏幕（相当于`clear`命令, **这个基本都知道**）
7. `Ctrl + H`：和退格键的功能一样（Backspace）
8. `Ctrl + R`：搜索最近使用过的命令（**避免重复输入命令**）
9. `Ctrl + C`：kill掉正在运行的程序（**这个应该都知道**）
10. `Ctrl + D`：退出当前shell（**不用再输入exit/logout了**）
11. `Ctrl + Z`：将正在运行的程序挂起，通过`fg`命令可重新运行（**这个也应该都知道了**）
12. `Ctrl + T`：效果是**“将光标左边的一个字符往右移”**，详细描述是“将光标左的一个字符和右的一个字符交换位置，同时光标向右移动一个字符（若光标在行尾，则交换行尾最后两个字符的位置）”--> 这个自己用的少

## 说明

> Shell快捷键很多，上面列举的15个大部分是自己平时经常用的，原生**git shell**和**bash shell**下都work！   


但上述一些快捷键有时候可能会**失效**，比如：   
1. 当通过telnet/ssh会话连接到bash shell（如putty，xshell等工具）时，比如`Alt`开头的快捷键  
2. 已经有了相应的快捷键映射（软件默认的或自己手动设置的）  
3. 其他本人不知道的情况，哈哈……  

## 参考 
1. [Wikipedia_Table_of_keyboard_shortcuts](https://en.wikipedia.org/wiki/Table_of_keyboard_shortcuts)：维基百科最全  
2. [Keyboard Shortcuts for Bash](https://www.howtogeek.com/howto/ubuntu/keyboard-shortcuts-for-bash-command-shell-for-ubuntu-debian-suse-redhat-linux-etc/)：一个比较好的geek网站  
3. 感谢[黄志斌](http://www.ituring.com.cn/users/98916)的留言和建议，自己对原文做了不少的修改，谢谢

