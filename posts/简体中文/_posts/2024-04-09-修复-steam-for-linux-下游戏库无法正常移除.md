---
title: "修复 steam-for-linux 下游戏库无法正常移除"
tags: [ "Steam", "Linux", "PC-Desktop" ]
---

## 1.现象

在 steam 的储存设置中`移除库`后虽然当时显示已经移除但等到重新启动 steam 时该游戏库又会重新出现

很神奇，但考虑到这块分区的挂载路径从添加成游戏库后，被改了好几遍，期间 proton 也对这块游戏库（NTFS文件系统）进行了一轮 linux 风格文件名的轰炸...\
其实我也不怎么怪它了233

## 2.解决办法

这是一轮搜索后我找到了...\
这个: <https://github.com/ValveSoftware/steam-for-linux/issues/8353>

这基本就是我遇到的情况，而且看来这个bug好像就是会随机发病的

解决办法是**ifyun**的评论[#issuecomment-1219165269](https://github.com/ValveSoftware/steam-for-linux/issues/8353#issuecomment-1219165269)

算是手动帮 steam 修正错误的配置文件了，另外我在 archlinux 上的文件夹不是 `~/.steam/debian-installation/` 而是 `~/.steam/root/`
