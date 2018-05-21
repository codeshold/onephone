---
layout: post
title: GitHub Tips （很实用，值得收藏）
category: 技术
tags: [git]
---

> 针对GitHub 和 Git，各列举了15个小技巧！精简实用

## GitHub Tips
1. [这里][1]可以下载各种造型的GitHub吉祥物（**总有一款会是你的菜**）
2. [这里][2]可以查看GitHub托管的总仓库数（**总数很大很大**）
4. [这里][4]可以查看当前备受瞩目的开源软件（**追逐潮流，走在前沿，拥抱最新的技术**）
5. GitHub上的开源代码，大多数使用的是[MIT许可协议][5]，基本要求要了解（**要了解**）
     
    > **被授权人权利**
    被授权人有权利使用、复制、修改、合并、出版发行、散布、再授权和/或贩售软件及软件的副本，及授予被供应人同等权利，惟服从以下义务。
    **被授权人义务**
    在软件和软件的所有副本中都必须包含以上版权声明和本许可声明。
    **其他重要特性**
    此许可协议并非属copyleft的自由软件许可协议条款，允许在自由及开放源代码软件或非自由软件（proprietary software）所使用。
    MIT的内容可依照程序著作权者的需求更改内容。此亦为MIT与BSD（The BSD license, 3-clause BSD license）本质上不同处。
    MIT许可协议可与其他许可协议并存。
    另外，MIT条款也是自由软件基金会（FSF）所认可的自由软件许可协议条款，与GPL兼容

6. GitHub上Issue、Wiki、评论等都可以用MarkDown语法表示（**是都可以！**）
7. [这里][6]有最全的各类`.gitignore`模版（**直接download吧**）
8. GitHub页面支持使用键盘快捷键，`shift` + `/` 键可打开一览表（**不知道试试吧**）
9. 在某仓库页面上按下键盘的`t`键再输入文件名，可快速查询需要的目录或文件名，不用手动找（**很实用,节约时间**）
10. 通过手写URL快速查看代码之间的差异，可按**分支**、**前几天**、**制定日期**的方式查询（**高手的习惯**）

    > 查看分支差别：`https://github.com/rails/rails/compare/4-0-stable...3-2-stable`
    查看几天前差别：`https://github.com/rails/rails/compare/master@{2.day.ago}...master`
    查看特定日期差别：`https://github.com/rails/rails/compare/master@%7B2016-09-08%7D...master`

11. 通过在Pull Request的URL后添加`.diff`或`.patch`，可直接获取对应格式的Pull Request文件

    > 若Pull Request的URL为`https://XXXX/仓库名/pull/28`,则获取diff格式文件，只需在其末尾添加`.diff`，如`https://XXXX/仓库名/pull/28.diff`，patch格式也相同，末尾添加`.patch`
12. Close Issue时，可在提交中以一定的格式描述提交信息，而对应的Issue就会自动Close。不用在网页中手动操作。（**方便**）

    > 下列任意格式都可以——`fix #2`, `fixes #2`, `fixed #2`, `close #2`, `closes #2`, `closed #2`, `resolve #2`, `resolves #2`, `resolved #2`

13. Issue和Pull Request的编号通用，可以直接在Issue中给出源代码，其就可以变成Pull Request。（**hub命令**）
15. emoji表情自动补全功能，评论中输入`:`后便会启动，emoji速查表在[这里][7]
16. Wiki也可以通过Git进行管理，Clone其URL即可
3. 建立个人私有仓库，按[套餐类型][3]，最低只要**7美元/月**


## Git Tips
13. 学习Git的好网站 [LearnGitBranching][9]（**右下角地球标志可切换成中文版的**）
0. [这里][8]是最新的Pro Git中文官方学习资料（**免费，且有pdf,epub,mobi,html版本**）
1. `git config --global `全局配置文件`.gitconfig`存放的目录为`~`（**windows下也是**）
2.  这样设置后可以优美简洁的显示`git log`

    > `git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"`，之后查看log只需键入`git lg`，是`git lg`

3. `git XXX --help`可在**浏览器**中查看最详细最全的git命令帮助信息，`git XXX -h`可在命令行中显示简要的帮助信息
4. 若想以后通过**确认日志工具**方便的查看提交记录，`git commit`后，编辑提交信息时要注意格式

    > 第一行：用一行文字描述提交的更改内容
    第二行：空行
    第三行：技术更改的原因和详细内容

5. `git commit -a`只能统一提交修改过的文件，但**新建的文件**还是需要`git add XXX`后再提交。
6. `git checkout -`可以方便的切换至上一个分支
7. `git reflog`可查看当前仓库执行过的操作（**即使错误的执行了git命令，也可通过reflog恢复原来状态**，而`git log`只能查看以当前状态为终点的历史操作

    > 只要不进行Git的GC（Carbage Collection，垃圾回收）就可以通过reflog日志随意调取最近的历史状态

8. `git reset --hard XXXXX`回溯历史时，哈希值只要输入**4位以上**就行
9. `git commit --amend` 修改提交信息（**万一提交信息里面有拼写错误呢**）
10. `git rebase -i HEAD~2`将最近两次提交的记录合并为一次完美记录，`git rebase`可将不良记录（如拼写错误）从历史中抹去（**很实用，很实用**）
11. `git branch -a` 同时显示本地仓库和远程仓库的分支信息
14. `git log -p FILENAME`显示文件改动信息
15. `git commit`之前先`git diff HEAD`查看本次提交和上次提交的区别（**好习惯**）

## 词汇
**Groupware**：群件
**CRM**：Customer Relationship Management，顾客关系管理
**IRC**：Internet Relay Chat，网上实时聊天
**GFM**：GitHub Flavored Markdown
**TiDD**：Ticket-driven Development
**BTS**: Bug Tracking System，典型的还有Redmine， Trac， Bugzilla

## 说明
1. 本文章主要是总结了《GitHub入门与实践》1-5章的内容，同时还包括其他部分网站的信息。在此一并表示感谢！
3. 有其他值得收藏（一般人不知道的）GitHub Tips欢迎指出……


  [1]: https://octodex.github.com/
  [2]: https://github.com/features/hosting
  [3]: https://github.com/plans
  [4]: https://github.com/trending
  [5]: https://en.wikipedia.org/wiki/MIT_License
  [6]: https://github.com/github/gitignore
  [7]: http://www.webpagefx.com/tools/emoji-cheat-sheet/
  [8]: https://git-scm.com/book/zh/
  [9]: http://learngitbranching.js.org/
