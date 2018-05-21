---
title: linux shell 学习摘记（6） 
layout: post
author: WenfengShi
category: 技术
tags: [shell]
---

> 《linux shell 脚本编程攻略 （第2版）》 第六章 “B计划” 笔记  
  
> 常用命令: `tar`, `gzip`, `zcat`, `zip`, `unzip`, `lzma`, `pbzip`, `rsync`, `git`, `squashfs`, `fsarchiver`  
  
- **tar**归档（无压缩功能）  
    1. `tar -cf output.tar file1 file2 file3`创建, `tar -tf output.tar`列出  
    2. `tar -rvf original.tar newfile` 向归档文件中添加一个文件  
    3. `tar -Af file1.tar file2.tar` 合并两个归档文件  
    4. `tar -uf archive.tar file1` 仅当file1比归档文档中的file新时喜爱进行追加  
    5. `tar -df archive.tar` 比较归档文件和文件系统中的内容  
    6. `tar -f archive.tar --delete file1 file2` 或 `tar --delete --file archive.tar file1 file2`  
    7. `tar -cf arch.tar * --exclude "*.txt"`, `tar -cf arch.tar * -X list` list包含要排除的文件列表  
    8. `--totals` 在归档玩车功能之后打印出总归档字节数  
    9. 在归档时排除版本控制相关的文件和目录`tar --exclude-vcs -czvvf sourcecode.tar.gz mysvn`  
  
- **tar**压缩归档  
    1. `-j` bunzip2 格式压缩  
    2. `-z` gzip 格式压缩  
    3. `--l` lzma 格式压缩  
    4. `tar acvf archive.tar.gz file1 file2`, 自动选择格式压缩  
  
- `cpio`从stdin获取文件名，并将归档写入stdout, `echo file1 file2 | cpio -ov > archive.cpio`, `-o`指定输出  
  
- `gzip`只能压缩单个文件或数据流  
    1. `gzip -l test.txt.gz` 列出压缩文件中的内容  
    2. `tar -cavvf archive.tar.gz -C extract_directory`  
    3. `gzip -5 test.img` 压缩率， 1级压缩率最低，9级最高  
  
- `zcat test.gz`无需解压直接读取test.gz  
  
- `bzip2`语法同gzip, 但压缩效率更高, test.tar.bz2  
  
- `lzma` 压缩效率比上面的更高, `unlzma`, test.tar.lzma  
  
- `zip`同时有归档和压缩功能, `zip -r archive.zip folder1 folder2` 对目录和文件进行递归操作, `unzip file.zip`, `zip file.zip -u newfile` 更新压缩文件中的内容, `zip -d file.zip file1` 删除文件  
  
- **pbzip2**更快速的归档工具 `tar cf myfile.tar.bz2 --use-compress-prog=pbzip2 dir`, `pbzip2 -c ...`, 还可指定处理器数量`bpzip -p4 myfile.tar`  
  
- 创建压缩文件系统 `squashfs` 还可利用环回形式挂载squashfs文件系统`mount -o loop compressedfs.squashfs /mnt/squash`  
  
- `rsync` 备份系统快照(ssh)`  
    1. `rsync -av sourpath destinationpath`, -a表示归档  
    2. `rsync -av /home/xxfile root@10.10.82.154:/home/xxfile`, `-avz`可以在网络传输时压缩数据  
    3. 讲一个目录中的内容同步到另一个目录`rsync -av /home/test/ /homt/backups`前者有/  
    4. `rsync -av /home/test /home/backups` 将目录本书及内容复制  
    5. `--exclude "*.txt"` 排除指定的文件,  
    6. `rsync -avz SOURCE DESTINATION --delete` 备份时，查处不存在的文件(针对远程)  
  
- `git` 进行版本控制   

- `fsarchiver`创建全盘镜像， 将整个文件系统中的内容保存成一个压缩形式的归档文件 
