--- 
title: 实用的 vim 技巧
layout: post
author: WenfengShi
category: 私库
tags: [vim]
---

## 命令部分

### 分屏 Ctrl+w
- 启动窗口：`vim O2 filename1 filename2` 垂直分屏打开两个文件; `vim o3 filename1 filename2 filename3` 水平分屏打开三个文件
- 关闭窗口：`Ctrl+w c` 关闭当前窗口，如果是最后一个了，则不关闭；  `Ctrl+w q` 如果是最后一个，则直接关闭vim
- 屏间移动光标：`Ctrl+w`后再按`h/j/k/l`； `Ctrl+w w`
- 移动分屏位置：`Ctrl+w`后再按`H/J/K/L` （**这也可以让分屏在垂直显示和水平显示之间相互切换**，具体可`:help opening-window`）
- 修改分屏尺寸：`Ctrl+w`后再按`=/+/-` 设置全部一样的高度/增加高度/减少高度；`Ctrl+w`后再按`>/<`设置增加/减少宽度
- 分屏转化为标签： `CTRL+w t`

### 多标签 tab
- 打开多个文件（多标签）:`vim -p file1 file2`; `:tabe file1`

### 窗口调节

- 设置vim默认打开窗口最大化的方式: windows下在*vimrc*中添加`au GUIEnter * simalt ~x`; linux下*vimrc*添加如下代码([其他详细配置参考链接](http://vim.wikia.com/wiki/Maximize_or_set_initial_window_size))

```vim
    if has("gui_running")
        set lines=999 columns=999
    else
        if esixts("+lines")
            set lines=50
        endif
    endif
```

### 专家命令
- 删除连续的空白行 `:%s/^\(.*\)\n\1$/\1/g`
- 在每行前添加两空行 `:g/^/norm 2o`
- 在新分屏中打开本文档所在的目录：`:H!`
- 同时在打开的多个标签文件中执行命令: `:tabdo XXX`

### 有趣的命令

### 基本概念
- buffer 缓冲区 --> `:b ` `:buffers`
- register 寄存器 --> `"`（存入或取出）
- marcro 宏 `qa`(记录在寄存器a中) --> `@a`(执行寄存器里面的命令)
- mark 标记 `ma` --> `'a` 或 `g'a`
- `g#`(匹配的是`word`) `#`(匹配的是`\<word\>单个词)` `g*` `*`
- vim中输入`:h!` `:h 42`
