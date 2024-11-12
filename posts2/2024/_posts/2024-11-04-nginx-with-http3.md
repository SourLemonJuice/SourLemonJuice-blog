---
title: "在 NGINX Docker 上启用 HTTP/3 的经历"
has_modified: true
---

HTTP3 是最新一代的 HTTP 协议，最近在折腾自己的网站加上一直久仰它的大名，所以就像看看能不能给自己的网站塞上

## 基本信息

HTTP3 基于 QUIC 协议，QUIC 则是基于 UDP 协议构建起的新一代通信协议。整合了很多，复杂了很多。但最重要的改变是在保留了消息可靠性的同时将最底层协议从 TCP 转为了 UDP。\
可能 HTTP 的创始人怎么都不会想到它有朝一日也能跑在 UDP 上吧233

至于我的系统环境则是跑在 Docker 里的 nginx 1.27

## NGINX 对 QUIC 的支持

nginx 在 v1.25 时添加了对 HTTP3 和 QUIC 的支持，它们对此也一片简短的文档：[Support for QUIC and HTTP/3](https://nginx.org/en/docs/quic.html)\
至少在现在的 Docker 官方镜像中 `--with-http_v3_module` 已经被添加，所以这里倒是不用再去编译些什么的

nginx v1.25 还将 `listen` 字段的**参数** `http2` 转为了新的**命令** `http2 on;`：[ngx_http_core_module#http2](https://nginx.org/en/docs/http/ngx_http_v2_module.html#http2)\
看得出来，当时开发者都没想到 HTTP3 会把 TCP 给直接丢掉

## 需要做什么

首先是依照文档中所写，添加一个新的监听。虽说协议不同，但似乎至少要使用了同一个端口就必须在 `listen` 上加上 `reuseport` 参数：

```text
listen 443 ssl;
# for quic
listen 443 quic reuseport;
```

默认情况下似乎并不需要指定“开启 HTTP3”也就是命令 `http3 on;`：[HTTP/3: Shiny New Thing, or More Issues?](https://medium.com/tech-internals-conf/http-3-shiny-new-thing-or-more-issues-6e4fe14e52ea)\
但显示声明也不是什么坏处

由于使用了完全不同的底层协议，客户端与服务端之间的协议协商会出现些问题。\
要让客户端明白自己可以和怎么用 HTTP3 连接到服务器，那就还需要加上 `Alt-Svc` 标头字段：

```text
# 从 nginx 文档里扣来的
add_header Alt-Svc 'h3=":443"; ma=86400';
```

到这里，现在服务器应该就可以在 0.0.0.0 的 UDP 端口443上监听 HTTP3 了。\
但由于使用的底层协议变了，防火墙或类似会阻隔流量的配置也要跟着改变

比如我在用的 Docker 容器

## Docker 导出的端口默认是 TCP 不是全部协议

老实说我一直以为 Docker 的 --port 导出的是 TCP 和 UDP，好吧，看来是 UDP 用的太少了（咕）

网站环境用的是 Docker Compose，所以参考这里：[Services top-level elements#ports](https://docs.docker.com/reference/compose-file/services/#short-syntax-3)\
给导出端口里加上 UDP 就好了：

```docker-compose
ports:
  - 443:443/tcp # 等同于 443:443
  - 443:443/udp
```

记得一定要看防火墙呀

## 使用多个虚拟主机（子域）时报错无法绑定端口

报错信息可能类似这样：

```text
duplicate listen options xxx:443
```

参见这篇帖子：<https://github.com/cloudflare/quiche/issues/236#issuecomment-548042467>\
和这里：<https://stackoverflow.com/a/77005737/25416550>

只写一次 reuseport 就好了，其它的主机只需要 `listen 443 quic;`...\
nginx 有时还是太底层了的说

## 还可以看看这些

- <https://inaba-serverdesign.jp/blog/20240404/nginx-http3.html>
- <https://medium.com/tech-internals-conf/http-3-shiny-new-thing-or-more-issues-6e4fe14e52ea>
- <https://qiita.com/t13801206/items/c33bc5dd79d87c211b7f>
