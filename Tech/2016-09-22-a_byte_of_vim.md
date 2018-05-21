---
title: A Byte of Vim 笔记
layout: post
author: WenfengShi
category: 技术
tags: [vim]
---

> 作为一名vim深度用户，[A Byte of Vim](http://www.swaroopch.com/notes/vim/) 一直是自己最喜欢的读物。我会向任何想学习vi/vim的朋友推荐它。
**务必读英文原版！** 英语简单，书也简明！在此感谢swaroopch大神。

下面是自己整理的“A Byete of Vim”笔记，用于回忆和自测。**更可作为检测自己是否是一名合格的vim用户！！**

## 1.Perface

> "There is no great writing, only great rewriting." -- Louis Brandeis
"Vim if one of the few pieces of software that I use for nearly 10 hours a day." -- Authors
The mantra is *Concepts. Examples. Pithy*
Perfection is achieved, not when there is nothing more to add, but when there is nothing left to take away.

## 2.Introduction

> Powerful means following the paradigm of "Minimal effort. Maximal effect."

Press `*`        Run `:sp`        Run `:50`        Run `:,100s/old/new/g`    Press `gf`

Run `:colorscheme desert`        Run `:nmap <c-s> :w<CR>`

Run `:mksession ~/latest_session.vim` -> `vim -S ~/latest_session.vim`

Run `:syntax on` -> `:set filetype=Wikipedia`

Run `:set foldmethod=indent`    Run `:tabedit <file>`

Press `ctrl-n`(自动补全)    Run `:0,10s/form/to/gc`    Run `:%s/from/to/g`

Run `:help vim-modes-intro`    Run `:edit hello.txt`<-->`:e hello.txt`

Run `:help notation`(帮助理解命令的含义)    Run `:help keycodes`(特殊按键的表示方法)

Press `:ab swf shiwenfeng`

Press `vab`(选定括号内的全部内容`help ab`)    Press `dw`    Press `2d3w`

## 3.Modes

There are three basic modes in Vim - normal, insert and visual

Run `:echo "hello world"`        Run `:help usr_toc`或`:help user-manual`

Run `:help index`(可寻找感兴趣的内容)

Run `:help vim-modes-intro`    Run `:help mode-switching`

Important --> `a,A i,I o,O r,R s,S     v,V`(这个很重要)

```
+---------+ i,I,a,A,o,O,r,R,s,S +----------+
| Normal  +---------->------------+ Insert |
| mode    |                       | mode   |
|         +----------<------------+        |
+-+---+---+         <Esc>         +--------+
    | |
    | |
    | |
v,V V ^ <Esc>
    | |
    | |
+---+---+----+
| Visual     |
| mode       |
+------------+
```

## 4.Typing Skills

vi/vim graphical cheat sheet:

- 这是自己用的[vim速查表](http://www.viemu.com/vi-vim-cheat-sheet.gif) 

![image_1at8j2ohpfprnvl148oi93rb39.png-159.6kB](http://static.zybuluo.com/wuzhimang/c31twk8wj1w45k8wdauzn9zl/image_1at8j2ohpfprnvl148oi93rb39.png)

- 这是自己的[vim桌面](https://github.com/LevelbossMike/vim_shortcut_wallpaper))

![image_1at8j38d7c7e76cd8u3mgivsm.png-78kB](http://static.zybuluo.com/wuzhimang/8f1tr6q41m3w2xzja6dcsv2o/image_1at8j38d7c7e76cd8u3mgivsm.png)

Press `}` `{` `(` `)` 

Press `ctrl-o`(the previous location)   Press `ctrl-i`

Press `^` `$` `ctrl-f` `crtl-b`

Press `G` `H`(highg) `M`(middle) `L`(low)     Press `: help word-motions`

Press `:help cursor-motions`

Press `:help text-objects`   Press `:help object-motions`

Press `:help motion`

press `:help various-motions`

## 5.Help

> "The true delight is in the finding out rather than in the knowing"

Run `:help`    Run `:help user-manual`

Run `:help abbreviate`     Press `ctrl-]`

Run `:helpgrep gt`(这个很有用，模糊查询）

Run `:cnext` Run `:cprev`  Run `:clist` (这类用的少)

Press `ma` -> Press `'a`     Press `~`

Run `:let &keywordprg=':help'` --> `K`(快捷帮助)

## 6.Editing Basics

> "If I had eight hours to chop down a tree, I'd spent six hours sharpening my axe" -- Abraham Lincoln

Run `:swapname`    Run `:help swap-file`

`nmap <c-s> :w<CR>`

`imap <c-s> <Esc>:w<CR>a`

Run `:e ../tmp/test.txt`    `:cd`    `:pwd`

Run `:e C:\\shopping\\monday.txt`

`y` -> yank

`1G` and `|` -> moves to the first line and the first column respectively

Run `dl`    `dw`

`yy` -> operation name twice, it will operate on the

`yap` -> yank the current paragraph   

`xp` -> swap two characters

`dwwP` -> swap two words

`m{a-zA-z}` -> `'{a-zA-Z}`({}内是可选字母范围)

`u/U` <-> `ctrl-r` --> undolevels    `:earlier 4m`(比较有用，回到4分钟之前)    `:later 45s`

`:undolist`    Run `:help :undolist/undo-redo/usr_32.txt`

`set incsearch/ignorecase/smartcase`(设置搜索配置) --> `/step` `/Step`

Run `:help vimrc-intro`    `:help pattern`

Run `:/\<step\>`    `/\d\+`(匹配数字) 

## 7.Multiplicity

`:set foldmethod=indent` --> `zc` `zo` `za`

`:nnoremap <space> za` --> noremap

Run `:help buffer-list`    `:buffers`(查看当前的buffers)   `:b 1`或`:e XX.txt`(切换到对应的buffer) `:ls`    

`:sp` or `ctrl-w s`        `:vsp` or `ctrl-w v`

`ctrl-w r` --> rotate the windows

`ctrl-w K` --> move the current windows to the topmost position

`ctrl-w _` --> make the cutternt windows as big as possible

`ctrl-w =` --> make the windows 'equal' in height again

`:resize 10`

`:help windows`

`:tabnew`        `:tabc`    `:help tabpage`

`:tabmove 0`    `:tabdo`(在每个标签中执行命令)

`:help setting-guitablabel:


## 8.Personal Information Management

## 9.Scripting

`gUl` --> to switch the first letter to upper case

`g#`(匹配的是`word`) `#`(匹配的是`\<word\>单个词)` `g*` `*`

`qa` --> to start recording the macro named as a (register)
`q` --> stop recording the macro 
`@a` --> apply this to other lines

`.` --> repeat the last action   

`:colorscheme desert` --> <tab> to cycle through the available schemes

`:echo strlen(getline('.'))`

`:let len = strlen(getline('.'))`

`:echo "We have 'len' characters in this line."`

`:echo $HOME`    `:echo &filetype`        `:echo @a`

`:help function-list`

`:source capitalize.vim`        `:call Capitalize()`

`:echo has("python")`

`:help eval`    `:help python-commands`   `:help perl-using`

`:help ruby-commands` 

## 10.Plugins

> **the colon is optional when writing scripts in files**

There are various kinds of plugins that can be written
1. vimrc --> for general customizations
2. global plugin
3. filetype plugin
4. syntax highlighting plugin
5. compiler plugin

gvimrc --> for GUI specific customizations

`:help vimrc`

`vim -u NONE` -> start up Vim without any initialization scripts being run

`:hlep -u`        `:help starting`

## 11.Programmers Editor

> "Let's me reiterate that typing skills is critical for a programmer"
"We are typists first, programmers second"

`:set filetype=vim`       `$VIMRUNTIME/syntax` --> the list of language types available

`svn diff | vim -R -`(这个还比较实用)

`:set autoindent`     `:set smartindent`

`%` -> bounce(curly bracket)

`!` -> shell commands     `:sh` -> a full-fledged shell     `:%!sort`

`gf` -> open the file     `gd` -> move to the local definition of the variable name (实用)

`gD` -> the global declaration        `]]`

`:help object-motions`    `[I` -> display all lines that contain they keyword under the cursor

`:Vex`或`:Sex` (在新窗口中打开当前目录)

`ctags`   `cscope`  `:make`

omnicompletion -> pythoncomplete.vim -> ftplugin/<language>complete.vim

`:runtime! autoload/pythoncomplete.vim`

~/.vimrc -> autocmd FiltType python runtime! autoload/pythoncomplete.vim

`ctrl-n`  `ctrl-p`

`:help new-omni-completion`

`imap <c-space> <c-x><c-o>` -> omnicompletion

snippet -> SnippetsEmu

`:source %`       :runtime! ftplugin/python_snippets.vim

## 12.More

Modeline -> `vim: noexpandtab`

Portable Vim -> GVimPortable.exe

Upgrade plugins -> `:GLVS`(which stands for 'G'et 'L'atest 'V'im 'S'cripts) -> `:help getscript` 

Dr.Chip's plugins -> drawit.vim

Blog from Vim -> Vimpress plugin

Make Firefox work like Vim -> Vimperator add-on

Contribute to Vim -> `:help development`

Bram's talk on the seven habits -> "Seven habit of effective text editing"

Community -> hang out at the vim@vim.org

## 13.What Next

The other important resources -> "Best of Vim Tips"  `:help user-manual` -> the all-important

`:help new-7`

