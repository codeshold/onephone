---
title: vim 自动给文件添加头部信息
layout: post
author: WenfengShi
category: 技术
tags: [vim]
---

以**.md**文件为例，希望当新建的文件名以**2016**开头时，则自动在首部加入下列信息

```
---
title: 
layout: post
author: WenfengShi
category: 技术
tags: []
---
```


**.vimrc**中添加如下代码即可

```vim
auto BufNewFile 2016*.md exec ":call JekyllMDHeader()"
func JekyllMDHeader()
    call setline(1, "---")
    call append(1, "title: ")
    call append(2, "layout: post")
    call append(3, "author: WenfengShi")
    call append(4, "category: 技术")
    call append(5, "tags: []")
    call append(6, "---")
```

当用vim新建一个文件时，如`vim 2016-09-11-XXX.md`，下列内容会自动添加到文件头部：



