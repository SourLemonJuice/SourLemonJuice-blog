---
title: "BinTP/0：一个简单的 HTTP/1.1 仿制品，长度更短但没什么用"
has_modified: true
---

十月份一直在看网络上的东西，所以也开始想做些相关（而且能做出来的）小项目试试。\
因为这里的“网络”指的是现代意义上的前端和 HTTP 服务器所以这次的目标也就定为成与 HTTP 相关的东西咯

> 只是写着玩的而已，没打算真的用，不要实现，不要当真（

## 新协议？

BinTP -> Binary Transfer Protocol -> 二进制传输协议

HTTP/1.1 协议中使用直接的字符传递标头，之前我也一直有对它性能和带宽占用的疑惑。\
所以，如果把它们换成二进制的呢。当然，如果能再让加上些更有趣的功能不是更有趣了吗。这就是项目的初衷

BinTP 的第一个版本大概会去实现类似 HTTP/1.1 的功能，概念中甚至能与它互相转译

## 从理智的角度看，它与 HTTP 会有优势吗

没有，或者说对比与 HTTP/2 甚至 HTTP/3 而言不可能有任何优势。但这很酷，至少能去欺负欺负 HTTP/1.1 对吧（笑）。\
HTTP/2 使用 HPACK 压缩标头，这本身就几乎让整个项目显得毫无意义：[HPACK: the silent killer (feature) of HTTP/2](https://blog.cloudflare.com/hpack-the-silent-killer-feature-of-http-2/)

## 版本迭代

本质上来说当前并没有任何可用版本，但所有的讨论都在围绕着 BinTP/1 进行。这篇帖子也在不定期的进行不同规模的更新。\
不同于 HTTP，所有 BinTP 请求都已一个 `uint8` 的 reversion/修订 起始来表明版本。\
修订号大概率是不会超过 256 个的，但至于像 HTTP/0.9, 1.0, 1.1 这样的子版本号的编号可能就对不上就是了（ver2.14 -> rev17）

在这 256 个数字中，为了向后兼容和区分特殊版本 `255/0xff` 将作为保留版本号。该版本号直接代表了**特殊版本**的含义。\
它可能是正在开发中的版本，也可能是用作奇怪的通信控制。该请求将被生产服务器视为无效，**不得**以任何用途响应正常返回，甚至**应该**直接忽略连接不返回任何内容

```text
| uint8 修订号 |
```

## 字符集

对于字符集，BinTP/1 的主要目标是与 HTTP/1.1 的可转换性，所以有任何需要字符串的场景都需要参考 HTTP Semantics: [RFC9110](https://www.rfc-editor.org/info/rfc9110) 中对于该部分的定义

（翻译：累了，自己看着办吧（呜呜呜））

## BinTP URI 格式

> 孩子写着玩的，别当真，呜呜呜（不对正片文档都不能当真）

URI 段落格式与 HTTP 所使用的 [RFC3986](https://www.rfc-editor.org/info/rfc3986) 一致

这是 bintp 的 URI 格式定义：

```text
"bintp" "://" authority path-abempty [ "?" query ]
```

bintp URI 的目标服务器由 authority 组件提供，其中包括了主机标识符和强制的端口号。\
BinTP 目前没有默认保留端口号，所以必须写明端口号

发送者不得生成带有空主机标识符的 URI，处理此类 URI 的程序必须将其视为无效并且直接丢掉。\
Authority 组件中的 userinfo 子组件在 URI 中不被允许，处理该类 URI 的程序同样必须将其视为无效

> [RFC 9110: Deprecation of userinfo in http(s) URIs](https://www.rfc-editor.org/rfc/rfc9110.html#section-4.2.4)

## 请求中的 URI

但整个 URI 段落以 NUL/0x00 字符结尾

```text
| 标识符字符串 | NUL |
```

## 内嵌整数格式

所有大于 1byte 长度的整数使用小端法传输。问就是方便（

## 标头字段/Field

fields 是一套固定格式的循环。这是单个结构的格式：

```text
| 1bit 长度模式 | 7bit-15bit 名称长度 | 名称 | 1bit 长度模式 | 7bit-15bit 参数长度 | 参数 |
```

每个结构的“长度”由最低位的一位长度模式以及剩下的数据部分组成，总长可能为 8bit 或 16bit。\
长度模式如果为真，则表明使用 16bit 长度模式，数据中剩下的部分则当作 uint15 处理。\
反之则只使用 8bit 长度，剩下的部分当作 uint7 处理

所有“长度”的单位均为 byte。\
这样，8bit 模式下最高可以表达 127byte 的长度，16bit 模式下为 32767byte

整个标头以一个值为 0x00 的 uint8 结尾，如果以解析 field 的方式理解这会是一个长度为0的“名称长度”。从逻辑上讲，这倒也是合理的对吧

```text
| field array | 0x00 |
```

字段的名称长度的 0 值用作检测字段结束，而参数长度不可能为 0，任何处理到该标头的主机都**必须**将该请求视为无效

## 标头字段的格式和对照

我不认为直接将所有官方标头的字符串一一对应是个好想法，但我们应该也需要些官方标头。\
但，可惜的是，我很懒...

所以目前而言，标头的名称与参数将完整以字符串的形式使用 HTTP 的头字段：[RFC4229](https://www.rfc-editor.org/info/rfc4229)

## 请求格式

请求与响应都已修订号段落起始，随后接上 uint8 的“请求方法”，以及 URI 段落和标头字段们。\
其中，请求方法是大小为 8bit 的二进制格式

```text
| uint8 修订号 | uint8 方法 | URI | 标头字段 ... | 负载 |
```

随机生成的方法对照：

|HTTP|BinTP|
|:--|:--|
|GET|0xa9|
|HEAD|0xd3|
|POST|0x11|
|PUT|0xa0|
|DELETE|0x80|
|CONNECT|0x6f|
|OPTIONS|0x83|
|TRACE|0x0d|

> <https://www.rfc-editor.org/rfc/rfc9110.html#section-9>

## 响应格式

首先是修订号。紧接着的就是响应状态码，当前版本使用 uint16 作为储存格式。\
随后则是与请求格式一样的标头字段：

```text
| uint8 修订号 | uint16 status | 标头字段 ... | 负载 |
```

status 直接使用 HTTP 状态码章节的描述

> <https://www.rfc-editor.org/rfc/rfc9110.html#section-15>

## 还需要想的事情

嘛，这点东西太简单了（捂脸）。不过没事，拿来练练手还是很合适的

在想标准的时候 HTTP/1.1 的 Connection 标头让我一直摇摆不定，既然这是个很底层的协议，那要不要做些更好的连接控制方式呢。\
但以目前的协议框架来说要扩展这一部分就意味着要改动标头字段前的内容顺序，而且... 我不知道我要做什么

或许等未来一段时间去深入的看看 HTTP/2 再来想这一部分吧

## 实现

一个自己用来做测试的请求与响应的生成与解析库（C 语言）：[SourLemonJuice/BinTP](https://github.com/SourLemonJuice/BinTP)
