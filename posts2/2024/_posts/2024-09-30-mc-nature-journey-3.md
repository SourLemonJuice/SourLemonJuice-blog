---
title: "Minecraft 整合包《自然之旅3》在 Linux 上无法运行的解决方式"
---

最近看到（被别人推荐）了这个整合包：[新旅途！邂逅超多动物与自然的休闲之旅【MC整合包发布】自然之旅1.20.1](https://www.bilibili.com/video/BV1Ji421a7sR)

先抛开要私信才能拿到下载方式，和把全部模组都丢到模组包里私自分发，而不用任何一个模组原始下载方式的行为是好是坏。\
抛下怨气，既然都想玩游戏了那还是要玩的嘛

## 系统环境

系统是 Archlinux + KDE Plasma 6 + OpenJDK-jdk 17

因为 PCL2 这个以前用了很久的启动器并不支持 Linux 平台，加上 HMCL 的长相和小问题，很久以前我就转到了 MultiMC 的下游 Prism Launcher。\
但启动器的选择也不会导致什么差异就是了

## Unable to load library 'imm32'

第一次启动时直接弹出了一堆一堆的报错

经过一两天里断断续续的尝试，这次最重要的问题是 `---- Minecraft Crash Report ----` 下的：

```text
java.lang.UnsatisfiedLinkError: Unable to load library 'imm32':
libimm32.so: cannot open shared object file: No such file or directory
libimm32.so: cannot open shared object file: No such file or directory
```

有了 libimm32.so 这个关键字，在简单的搜索后就能找到这个 issue 页面：<https://github.com/reserveword/IMBlocker/issues/6>

长话短说的话大概就是：模组 IMBlocker 是个在游玩时帮助控制输入法状态的模组，但作者并没有实现对 Linux 平台的支持。（而且报错看来也很强硬的说）\
在禁用掉模组后（就是改后缀名而已）游戏就能打开咯

## 由 libopenal.so 引起的 Java 运行时报错

但突然又在某个时刻，它又开始报错了。MC 总是很神奇的嘛...

这次的错误发生在 forge 加载后，标题界面已经在显示了。但突然间系统声音会全部停止，在日志的最后会输出这些：

```text
#
# A fatal error has been detected by the Java Runtime Environment:
...
# Problematic frame:
# C  [libopenal.so+0x9fb4d]
...
```

能把 java 运行时弄炸的程序还是蛮恐怖的。
但往好了想，出问题的原生库已经被超级明显的标注出来了不是么

搜了搜，找到了这篇帖子：<https://www.reddit.com/r/linux_gaming/comments/18qjnwk/comment/kev60xc/>\
Archwiki 上竟然有 Minecraft 的条目，而且还把这个错误写清了诶

在这个段落：<https://wiki.archlinux.org/title/Minecraft#Audio_stutters_on_PipeWire>

在启动时设置环境变量 `ALSOFT_DRIVERS=pulse` 后启动游戏就没问题了。\
至于怎么设置嘛，如果允许可以试试改 jvm 启动命令，或者给启动器这个上级进程设置。\
不过都和我没关系 Prims Launcher 在实例的设置选项卡下可以直接编辑环境变量（享受）
