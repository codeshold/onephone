---
title: firefox vim 插件 vimperator
layout: post
author: WenfengShi
category: 技术
tags: [vim]
---
> firefox 火狐浏览器中自己使用的是 **vimperator** 插件，下面是其主要的命令

### 1. Features
- **`:set gui=none/tabs/`**
- `:source ` `:echo window` `:map` `:command` `:time`
- `:open guofei gu` `:open ebay terminator` 直接进行对应的搜索

### 2. Quick-start tutorial
- Geting help `:help`
- Scrolling `j k <space> <S-space> <C-b> <C-u> <C-d>`
- History & Tabs `H <C-o> <C-i> <C-n> <C-p> gt g1 gT g$ 3gt d o t` `:open url` `:tabopen url`
- Exit `ZZ ZQ` `:xall` `:qall` 前者保存访问的标签页
- Others `:dialog :bmakrs :bmark :history :emenu :addons` `:help Tutorial`

### 3. Starting Vimperator
- `res` 重启浏览器

### 4. Browsering
- `<S-Esc>` `Insert` 忽略所有keys
- `i` `I` 忽略单个key
- `:open baidu, google` `:tabopen` `t T o O w W p P gP ~`
- `jumps`-->`[count]H` `[count]L` `gh gH` `[count]gu` `gU` `gr`-->阅读器的方式浏览
- `r R` `:re` `:reloadall` <--> `<C-c>` `:st` `:stopall`
- `:sav [filename]`
- `q` `quitall` `:winc[lose]` `:winon[ly]` `:wqa[ll] :xa[all]` `ZZ ZQ`
- `:cd` `pwd`

### 5. Buffer
- `<C-g>` `g<C-g>` --> 查看网页信息；`:gf` `gF` `:vie` -->查看源码
- `0 $ % [count]h/j/k/l/**<C-d/u/b/f>**`
- `[count]]]` `[count][[` --> 相当于点击next/prev链接
- `[count]zi zm zo zr zz` `[count]zI zM zO zR zZ` `:zoom [value]`
- `y Y` --> `P` <==> `T`


