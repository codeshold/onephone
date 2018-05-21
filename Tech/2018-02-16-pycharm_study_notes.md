---
title: PyCharm教学视频学习笔记
layout: post
author: WenfengShi
category: 技术
tags: [python, tools]
---
博客链接: [http://codeshold.me/2018/02/pycharm_study_notes.html](http://codeshold.me/2018/02/pycharm_study_notes.html)

[Pycharm简易教学视频][1] -- Paul Everitt

> Tips:
> 有些快捷键是有问题的
> Command(Mac)同Alt(Linux/Windows)
> 注意PyCharm最下面的提示信息（左下角）


1. Coding
    - `⌘`+`,`: Preferences
        - 非community版本：支持配置remote python interpreter (以及Docker)
        - Appearance -> Theme: 设置主题
        - Keymap: 设置快捷键
        - Plugins: IdeaVim
    - `⌘`+`J`: Insert Live Template
        - Win/Linux则是`Ctrl`+`J`
        - 可快速插入代码模版，如`if __name__ == '__main__':`
        - `Enter`: Choose Lookup Item, 选定对应的template
        - `Command`+`,` --> `Live` 可进行详细的设置
    - `Alt`+`Enter`: Show Intention Actions
        - 可以快速修改代码风格，比如将单引号字符串转化为双引号字符串，将字典的literal表示方式转化为constructor表示方式等
        - 可以快速创建函数名 function name
        - 可以快速 import this name
    - `Ctl`+`J`: Quick Document
        - 查找手册文档
        - View -> Quick Definition / Quick Documentation
    - `Alt`+`Command`+`M`: Extract -> Method
        - Win/Linux则是`Ctrl`+`Alt`+`M`
        - 快速添加方法定义
    - `Alt`+`Shift`+`Command`+`T`: Refactor
2. Navigation
    - 文件夹右键点击`Find in Path...`可搜索对应目录下所有包含特定字符串的的文件
    - `Command`+`E`: Recent Files
        - 快捷打开当前目录下的文件
    - `Shift`+`Shift`: Search Everywhere
        - 快速查找
    - `Command`+`B`: Navigate -> Declaration
        - 跳转到对应的申明处
    - `Command`+`A`: Select All
    - `Alt`+`F7`: Find Usage
    - `Command`+`B`: Declaration
        - Win/Linux: `Ctrl`+`B`
        - 右键->Go To->Declaration
    - Bookmarks
        - `Comand`+`F11`: Add bookmark
        - `Shift`+`F11`: Show bookmarks
    - `Command`+`Shift`+`A`: Find All Actions
        - 可以查询到所有的操作，比如键入 `bookmarks`
    - `Command`+`Number`: 可以在各窗口之间切换
        - `Command`+`7`: Structure Windows

3. Debugging
    - `Shift`+`Command`+`F9`: Debug
    - `Shift`+`Command`+`F7`: Step Into My Code
    - `Shift`+`Command`+`T`: Navigate -> Test
        - Win/Linux: Shift+Ctrl+T
    - `Alt`+`Command`+`O`:
    - `Alt`+`Command`+`Y`: Synchronize
        - File -> Synchronize
        - Win/Windows: `Ctrl` + `Alt` + `Y`
    - `Shift`+`Command`+`A`: Find Action
        - 查找IDE功能的最快捷的方式，比如想要修改字体，则输入Font即可
        - `Shift`+`Ctrl`+`A`
    - `Ctrl`+`Tab`: Switcher
        - 多文件之间切换快捷键，加上`Shift`可来回切换
    - `Command`+`R`: return 'running'
        - 重新运行
    - `Alt`+`Command`+`L`: Reformat Code
        - 调整代码风格
        - Win/Linux: `Ctrl`+`Alt`+`L`
    - Running && Debug Running
        - Evaluate Expression: `Alt`+`F8`(Debugger)` 或者 Console->Show Python Prompt


  [1]: https://pan.baidu.com/s/1eTmR3to#list/path=/
