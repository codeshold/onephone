--- 
title: 实用的 git 技巧
layout: post
author: WenfengShi
category: 私库
tags: [git]
---

## 实用命令
1. 恢复删除的所有文件 `git ls-files -d | xargs git checkout --`
2. 恢复删除的所有文件（路径或文件含中文）`git ls-files -d | xargs echo -e | xargs git checkout --`
