---
title: "未来的 SourLemonJuice-blog 会发生什么变化呢"
date: 2024-12-12 20:42 +0800
---

## 网站设计

或许你可能会说，这个网站很丑？\
我也一直有这种想法在，及时保持简单仍是整个 blog 设计中首先被考虑到的因素，但简单不意味着没有美学。我的美术细胞不多，但阻止整个网站变得更好的其实更多是隐藏在页面背后的技术栈

在2023年底我第一次开始尝试在 GitHub Pages 上尝试使用了 Jekyll 这个静态网站构建器，这是 GH Pages 的默认使用方式。\
但它年纪已大，加上使用 ruby 这个半死不活的语言编写（Jekyll 是我第一个听说的 ruby 项目），开发本身似乎已经变得有点困难

由于 ruby 的奇怪依赖问题，2024年一年中依赖报错和各种莫名其妙的构建问题一直伴随着这个网站。\
其使用的 Liquid 模板语言在一些方面上也让我有点不爽，不过这倒不是重点

一个列表 `page.tags` 竟然不能判断是否为空？\
<https://github.com/jekyll/jekyll/issues/2538>

截至目前，GitHub Action 中构建的页面没法自动获取到正确的修改时间，本地测试也完全依赖 Docker 容器化整个环境，这对一个网站来说似乎早已有点过分了

## 新选择

由于前一两个月对网络技术栈的丰富，或许是时候把它搬到 Hugo 或 Hexo 之类的新静态网站生成器上了呢。\
等到域名上的事稳定下来后，网站被迁移到自己的域上什么的也说不定。\
（感觉用 Hugo 的可能性会高很多，Hexo 是用 JavaScript 写的...）（快就是好，好就是快，好耶）

或许整个计划会在最近一两个月内实现，毕竟要自己处理主题上的内容，我对自己的前端技术栈还是很没有信心的（

## 那这个旧网站呢

我不讨厌现在这个网站的布局和样式，如果将来的新主题被做出来了是否要抛弃现有的这个呢...\
不会。而且，与其说各种重定向，继续把这些内容按它们长久以来的样子放在 github.io 上发挥着它们的作用也记录着我的历史不也很酷么