---
title: vim--自动添加jekyll post信息头
layout: post
author: WenfengShi
category: 技术
tags: [vim]
---

```vim
" for jekyll *.md
auto BufNewFile,BufRead *.md set encoding=utf-8 
auto BufNewFile,BufRead *.md set filetype=makrdown 
" auto BufNewFile [0-9]\\\{4\}-[0-9]\\\{2\}-[0-9]\\\{2\}-*.md exec ":call JekyllMDHeader()"
auto BufNewFile [0-9]\\\{4\}{-[0-9]\\\{2\}}\\\{2\}-*.md exec ":call JekyllMDHeader()"

function JekyllMDHeader()
    let typelen = 6
    let cwd = getcwd()
    let posttype = strpart(cwd, strlen(cwd)-typelen, typelen)
    let category = "category: " . posttype

    " if posttype == "读书"
        " 
    " elseif posttype == "技术"
        "
    " elseif posttype == "碎言"
        "
    " elseif postype == "私库"
        " 
    " elseif postype == "资源"
        "
    " else
        " 
    " endif
    call setline(1, "---")
    call append(1, "title: ")
    call append(2, "layout: post")
    call append(3, "author: WenfengShi")
    call append(4, category)
    call append(5, "tags: []")
    call append(6, "---")
endfunction
```

