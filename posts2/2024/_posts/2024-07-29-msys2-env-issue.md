---
title: "MSYS2 环境中编译的软件在其他原生系统里无法运行的原因"
noindex: true
has_modified: true
---

这篇帖子并不能实际解决问题，可能未来会有更新但现在绝不是个可靠的参考。\
帖子在发布后已被添加 `noindex` 标记

我也不熟啦，现学现卖

## 问题原因

如果在 MSYS2 环境中用 `pacman -Sy gcc` 直接安装 `gcc` 之类的编译器。最终安装的版本是不能运行在没有安装 MSYS2 环境的系统上的。\
它们仍然会链接 MSYS2 虚拟环境中的库

要想编译出完全能在纯 Windows 环境下运行的可执行文件则需要包名类似于 `mingw-w64-x86_64-gcc` 的交叉编译工具链

## 安装

运行像这样的命令 `pacman -Sy mingw-w64-x86_64-gcc` 安装所需的编译器。\
这些包提供的可执行文件并不在 `/usr/bin/` 下面，而是在 `/mingw64/bin/` 下

另外，所有软件包提供的文件列表可以用 `pacman -Ql <packageName>` 查看，找不到了可以试试

## 依赖包的安装

与主软件一样，所有依赖也需要安装以 `mingw-w64-x86_64-*` 命名的版本。\
这些包才是用来构建原生 Windows 程序的

不过像 git, make 这样的实用程序并不算在内

## 参考于

- [Python64+win10_64+cython+msys2(ming64)踩坑记](https://www.cnblogs.com/yafengabc/p/11399939.html)
