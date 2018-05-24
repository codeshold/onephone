# git diff/reset/log

## git diff / git reset

|场景\操作|查看修改|撤销修改|
|:--|:--|:--|
|已修改，未暂存|`git diff`|`git checkout . `或`git reset --hard`|
|已暂存，未提交|`git diff --cached filename `|`git reset && git checkout .` 或 `git reset --hard`|
|已提交，未推送|`git diff master origin/master `|`git reset --hard origin/master`|  
|已提交，特定两个版本之间|`git diff d44fc6c d1077b7` 或 `git diff d44fc6c:epd_23/epd_comm.sh d1077b7:epd_23/epd_comm.sh`|--|

## git reset
- [Git-工具-重置揭密](https://git-scm.com/book/zh/v2/Git-%E5%B7%A5%E5%85%B7-%E9%87%8D%E7%BD%AE%E6%8F%AD%E5%AF%86)

|命令|场景|作用域|
|:--|:--|:--|
|`git checkout`|丢掉本地目录的修改|工作区|
|`git reset –hard head@{n}` 或 `git reset –hard commitId`|已经提交回退到某个版本|本地仓库|
|`git revert head@{n}`|已经提交到远程回退|远程仓库分支|

## git reset soft/mixed/hard 区别
|命令|说明|
|:--|:--|
|`git reset --soft HEAD^`|仅撤销上一次 git commit 命令，后续可git commit --amend|
|`git reset –-mixed HEAD^` 或 `git reset HEAD^`|撤销暂存的所有的东西，回滚到了 git add 和 git commit 执行前|
|`git reset --hard HEAD^`|撤销最后的提交、git add 和 git commit 命令以及工作目录中的所有工作|



## 搜索git log中的关键字
If you want to find all commits where commit message contains given word, use
```
$ git log --grep=word
If you want to find all commits where "word" was added or removed in the file contents (to be more exact: where number of occurences of "word" changed), i.e. search the commit contents, use so called 'pickaxe' search with

$ git log -Sword
In modern git there is also

$ git log -Gword
to look for differences whose added or removed line matches "word" (also commit contents).

Note that -G by default accepts a regex, while -S accepts a string, but can be modified to accept regexes using the --pickaxe-regex.
```
## git log && git status 中文显示问题
> 原文：[windows下乱码解决方案](https://gist.github.com/vamdt/6334583b4aae156ed8571b7bf2329c62)
以下内容为“搬运”!

1. git status时中文文件名乱码

    现象：
    
    ```
    \344\275\240\345\245\275
    ```
    
    执行以下命令即可：
    
    ```bash
    git config --global core.quotepath false
    ```
    
    quotepath解释：
    
    The commands that output paths (e.g. ls-files, diff), when not given the -z option,will quote "unusual" characters in the pathname by enclosing the pathname in a double-quote pair and with backslashes the same way strings in C source code are quoted. If this variable is set to false, the bytes higher than 0x80 are not quoted but output as verbatim. Note that double quote, backslash and control characters are always quoted without -z regardless of the setting of this variable.

2. git log 查看提交中含中文乱码

    现象：
    ```
    <E4><BF><AE><E6>
    ```
    
    修改git全局配置设置提交和查看日志编码都是utf-8
    
    ```bash
    git config --global i18n.commitencoding utf-8 
    git config --global i18n.logoutputencoding utf-8
    ```
    修改git目录下etc\profile文件，设置less的字符集为utf-8
    
    ```bash
    export LESSCHARSET=utf-8
    ```
    修改cmder目录vendor\init.bat文件，添加以下代码,设定cmder编码为utf-8
    
    ```bash
    @chcp 65001 > nul
    ```
    chcp 65001的解释：
    
    [Why is there no option to choose codepage 65001 (UTF-8) as a default codepage in console window](http://superuser.com/questions/692202/why-is-there-no-option-to-choose-codepage-65001-utf-8-as-a-default-codepage-in/692230#692230)

3. gitk查看中文乱码
    
    ```bash
    git config --global gui.encoding utf-8
    ```
4. 补充：*nix系统下请先确认LANG的设置
`export LANG=”zh_CN.UTF-8”`
