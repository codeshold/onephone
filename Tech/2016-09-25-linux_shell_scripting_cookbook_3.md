---
title: linux shell 学习摘记（3） 
layout: post
author: WenfengShi
category: 技术
tags: [shell]
---

> 《linux shell 脚本编程攻略 （第2版）》 第三章 “以文件之名” 笔记      

> 常用命令：`comm`, `chmod/chown`, `chattr`, `touch`, `列出目录的相关命令`, `readlink`, `file`, `<<<`, `dd`, `有关光盘的各类命令`,`mkfs.ext4`, `mkisofs`, `isohybrid`, `mount/umount`, `fdisk`, `loseup`, `sync`, `cdrecord`, `eject`, `diff`, `patch`, `seq`, `tail`, `dmesg`, `pidof`, `pushd/popd`, `wc`, `tree`    
  
- `comm A.txt B.txt -2 -3` 删除第二列和第三列，保留只在A.txt中出现的行  
  
- 文件权限  
    1. `chmod u=rwx g=rw o=r filename`, 即`chmod 764 filename`  
    2. `chown USER.GROUP filename` 修改用户名和组  
    3. `chmod a+t directoryname` 给目录设置粘滞位(只有目录的所有者才能删除目录中的文件)  
    4. `chmod +s executablefile` 允许其他用户以文件所有者的身份来执行文件(setuid)，只能应用于Linux ELF格式二进制文件上  
    5. `chattr +i file`将文件设置为不可修改， `chattr -i file`移除不可修改属性  
  
- `touch -d "2016-09-22" filename` 也用`-c -m`参数，表示更改文件访问时间和内容修改时间  
  
- `ls -s target symboliclinkname`, `ls -l | grep "^1"`, `find . -type l -print`  
  
- `readlink symboliclinkname`  
  
- `file -b filename`  
  
```bash  
while read line;  
do   
    ...  
done <<< "`find $path -type f -print`" ### <<<可以将字符串作为输入文件   
# 或者 done < <(find $path -type f-print)  
```  
  
- **loopback**（环回文件）是指那些在文件中而非物理设备中创建的文件系统，可以将这些文件挂载到挂载点上（在物理磁盘中创建逻辑磁盘。  
    1. `dd if=/dev/zero of=loopbackfile.img bs=1G count=1`  
    2. `mkfs.ext4 loopbackfile.img`  
    3. `mount -o loop loopbackfile.img /mnt/loopback` 挂载环回文件系统（连接到名为/dev/loop1或loop2上）或者手动`losetup /dev/loop1 loopbackfile.img && mount /dev/loop1 /mnt/loopback`  
    4. `umout /mnt/loopback`  或 `umount /dev/loop1`  
  
- 在环回镜像中创建分区(并挂在其中一个分区)  
    1. `losetup /dev/loop1 loopback.img`  
    2. `fdisk /dev/loop1` 创建分区  
    3. `losetup -o 32256 /dev/loop2 loopback.img` 挂载第一个分区  
  
- ISO文件作为环回文件挂载  
    1. `mount -o loop linux.iso /mnt/iso`  
    2. `sync`  
  
- 生成ISO文件,`dd if=/dev/cdrom of=image.iso` （创建iso镜像）或者 `mkisofs -V "Label" -o image.iso sourcedir ` （创建ISO文件系统）  
  
- 将可引导的ISO文件写入USB设备来换成混合ISO  
    1. `isohybrid image.iso` 获得混合image.iso  
    2. `dd if=image.iso of=/dev/sdb1` 或者 `cat image.iso /dev/sdb1`  
  
- 刻录ISO`cdrecord -v dev=/dev/cdrom image.iso`, 加参数`-speed 8`表示刻录速度为8x; 多区段刻录`cdrecord -v dev=/dev/cdrom image.iso -multi`  
  
- `eject`, `eject -t` 命令行打开／关闭光驱  
  
- `diff -u file1.txt file2.txt > version.path`, `patch -p1 file1.txt < version.path`(对已修补过的文件进行修补将会撤销修改) `diff -Naur` -a 将所有文件视为文本文件， -u 生成一体化输出， -r 遍历目录下的所有文件， -N 将所有确实文件视为空文件  
  
- `seq 100 | tail -n 5`, `tail -n +M` 打印第M行及之后的行, `dmesg | tail -f -s 2` dmesg查看内核的环形缓冲区消息，每隔2秒, `PID=$(pidof Foo) && tail -f file --pid $PID`程序技术后tail也会结束  
  
- 列出目录`ls -d */`, `ls -F | grep "/$"`, `ls -l | grep "^d"`, `find. -type d -maxdepth 1 -print`  
  
- 多个目录间来回切换`pushd /var/www`, `pushd /usr/scr`（压入并切换路径）, `pushd +3` 切换路径（从0开始）, `popd`删除最后添加的路径并切换至该目录, `popd +3`移除特定的路径并切换  
  
- `wc file`（打印出文件行数，单词书，字符数）  
  
- 打印目录树 `tree . -P "*.md"`显示出匹配某种样式的文件, `tree . -I "*.md~"`显示不匹配某种样式的文件, `tree . -h` 打印出文件和目录大小, `tree . -H http://localhost -o out.html`  
