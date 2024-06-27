---
title: "MinGW-w64 中不改变任何语言编码解决中文乱码问题"
---

## 长话短说

C语言标准是有本地化(locale)设置的，或者说是 `<locale.h>` 头文件，和 `setlocale()` 函数。\
在没有任何显示设置的情况下本地化设置为 `C` 这是一个最小配置仅仅能实现让程序运行起来。更多详情可以去搜搜关于标准库中本地化的信息。

有一个说法是在没设置 locale 时，编译器可能会假定终端不能输出非 ASCII 字符，所以遇到中文或任何非 ASCII 字符都会乱输出。\
我不知道有多少是真的，我只知道把 locale 设置成 `C` 以外的合法字符串程序就能输出中文了...

## 呃，所以怎么做

在进行任何 IO 操作之前执行函数 `setlocale(LC_ALL, "zh_CN.UTF-8")`

第二个地区代码可以参考所使用的编译器的文档，比如 gcc 的文档在这里: <https://www.gnu.org/s/libc/manual/html_node/Setting-the-Locale.html>
