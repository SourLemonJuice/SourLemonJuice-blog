---
lang: "zh-Hans"
title: "Linux 上不同类型的只读访问"
date: 2025-09-17 05:51 +0800
---

“只读”这一特性在所有系统上都作为一种控制软件和用户访问文件系统的功能。这篇文章大概会简短的说一说我认识的 Linux 下的“只读/read-only”意味着些什么

## POSIX 文件系统权限

一般来说只读的英文全程 read-only 会在很多地方简化为 `ro`，对应的反义词是 read-write 简写是 `rw`

POSIX 文件系统作为最常见的权限系统存在于几乎所有 Unix 系统上，你可以用 `ls -l <filename>` 查看到相应文件的权限：

```text
$ ll
total 4.0K
drwx------  2 root root  60 Sep 17 04:32 ./
drwx------ 34 root root   0 Sep 17 04:32 ../
-rw-r--r--  1 root root  10 Sep 17 04:32 filename
```

最下面的文件 `filename` 就是例子，在那一行最左边的元素 `-rw-r--r--` 就是它的权限：

```text
-     |rw-    |r--    |r--  |
type  |owner  |group  |other|
```

Type 意味着这个文件是一个普通的文件而不是文件夹或者硬件设备。Owner 权限表示它的所有者对这个文件可读可写，Group 权限表示文件对它所属的组仅可读，Other 权限表示除此之外的所有人对它都仅可读

这里的场景也可能变成这样子：

```text
-     |rwx    |rwx    |rwx  |
type  |owner  |group  |other|
```

这样，无论是所有者还是文件所属的组还是其他人都可以读写这个文件，并且如果这个文件是可执行文件，无论是二进制文件还是脚本，所有人都有权限执行它。比如：`$ ./filename`

开头的 type，也可能是 `d` 表示目录（directory），或者 `b` 表示块设备（block）比如 `/dev/sda` 这块硬盘就是一个块设备。\
另外目录“文件”必须要有可执行权限，也就是 `rwx` 中的 `x` 才能被进入，比如命令 cd。所以在 `drw-rw-rw-` 的情况下，所有人都可以修改这个文件夹本身的名字，但谁都不能进去看到里面的内容

更改文件权限可以用命令 chmod 实现，不过方式有很多种可能类似与下面这些形式：

```shell
chmod 700 dirname
chmod o-rwx dirname
chmod 644 filename
chmod a-w filename
```

如果有需要的话一个权限为 `----------` 的文件也是可以存在的（`chmod 000 filename`），不过除了 root 以外没人能直接读写就是了。而且所有者也可以随时把权限改成别的状态再进行读写

另外，如果你知道的话 suid 和 guid 这种东西也归这里管。好了，就说这么多

## 文件属性/Attributes

这是个我很陌生的领域，因为日常场景中基本完全不需要它。我上次见他还是在 btrfs，有一个属性可以去关闭某个文件的 CoW（写时复制）功能

想要查看当前文件拥有的属性可以用命令 lsattr，它和 ls 很像，但每一行最前面的条条变长了好多...\
设置或者更改属性可以用命令 chattr，它类似于 chmod，一般来说整个命令可能看起来像这样子：`chattr +i filename`

和 read-only 相关的属性就是 `i`，他的介绍是这样的：

> A file with the 'i' attribute cannot be modified: it cannot be deleted or renamed, no link can be created to this file, most of the file's metadata can not be modified, and the file can not be opened in write mode. Only the superuser or a process possessing the CAP_LINUX_IMMUTABLE capability can set or clear this attribute.\
> 具有'i'属性的文件不可修改：无法删除或重命名该文件，无法创建指向该文件的链接，文件的大部分元数据不可修改，且无法以写入模式打开该文件。仅超级用户或拥有CAP_LINUX_IMMUTABLE能力的进程可设置或清除此属性。—— Deepl.com free

大概是 immutable/不可变 的意思。\
设置了这个属性的文件或者文件夹即使是所有者在也不能修改一点内容，而且即使是 root 也需要先动用特权删除这一属性才能修改内容：`chattr -i filename`

添加了属性后在看 lsattr 会看起来像这样：

```text
$ lsattr
----i----------------- ./filename
```

## 文件系统挂载选项

在 /etc/fstab 里写文件系统的配置时，还有 `mount -o <options>` 时都可以指定一系列的挂载选项。用的最多的选项合集 `defaults` 中就包含了一个 `rw` 选项。与之对应的，你也可以在挂载时补上一个 `ro` 来在文件系统层面上禁止所有账户和软件的写入操作，甚至完全包括 root

另一个好玩的选项是 `umask=XXXX`，它和命令 umask 类似都是用来指定文件权限的掩码，但命令 umask 是应用于当前的终端登陆中创建的文件的，而 `umask=XXXX` 挂在选项则是应用在了整个文件系统上。\
比如为 /boot 分区的挂载指定 `umask=0077` 就可以完全屏蔽掉所有原先存在的所有者以外的任何权限。权限列表也会变成 `-rwx------`

有一个可能的限制方式是挂载一个类型为 bind 的“文件系统”，它会将一个路径绑定到挂载点上，在这个过程中就可以加上一些挂载选项来做些什么。\
比如：

```shell
mount --bind -o "ro" /path/dir /path/dir
```

虽然两次路径一样，但由于新加入的挂载选项也让 /path/dir 这个目录变为了文件系统级别的只读

关于挂载选项什么的，还有些比较有用的选项比如 `noexec`，`nodev`，`nosuid`。分别能在文件执行时阻止它，禁止出现特殊的设备文件，和禁止出现 suid 可执行文件

## 文件系统错误

这是个听上去很危险的话题（事实上也是）。\
一些文件系统的实现在发现磁盘上出现了自己无法处理的错误时，会出发一定的保护机制将挂载选项里的 `rw` 改成 `ro`，并拒绝执行任何更多的写入操作。btrfs 就是一个例子，因为我没遇到过 ext4 出问题过（什（怎么感觉是讽刺

一般来说重启后内核模块都会重置，文件系统会重新可写，但一定一定要在出问题后运行一次对应文件系统的检查功能。不然数据可能在过一段时间真的会消失（大概吧，也可能什么都不会发生233

## EOF

虽然不知道为什么，但是突发奇想花了一个小时面无表情的写了这篇东西。校对很少，所以，谢谢你能看到这里awa

## Thanks for

- [chmod(1) — Arch manual pages](https://man.archlinux.org/man/chmod.1.en)
- [chattr(1) — Arch manual pages](https://man.archlinux.org/man/chattr.1.en)
- [File permissions and attributes - ArchWiki](https://wiki.archlinux.org/title/File_permissions_and_attributes#File_attributes)
- [4.12. Bind Mounts and Context-Dependent Path Names | Global File System 2 | Red Hat Enterprise Linux | 6 | Red Hat Documentation](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/6/html/global_file_system_2/s1-manage-pathnames)
- [linux - Explanation of nodev and nosuid in fstab - Server Fault](https://serverfault.com/a/547240/1244499)
