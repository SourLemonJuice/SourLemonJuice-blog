---
lang: "zho-Hans"
title: "TLS 证书申请工具 certbot 的基本用法"
date: 2025-01-24 21:59 +0800
---

certbot 是一款开源的自动化 TLS 证书申请工具。前些日子在看怎么给我的 sourlemonjuice.net 更好的管理证书，所以认真的看了看。正好给这里加一篇帖子咯awa

## 证书的申请协议

申请证书使用的协议名为 [Automatic Certificate Management Environment (ACME)](https://en.wikipedia.org/wiki/Automatic_Certificate_Management_Environment)，是有够长的。\
它可以让无人值守的程序与某个 证书颁发机构/CA 沟通并确认对域名的所有权，最终下发证书。certbot 默认使用的是 [Let's Encrypt](https://letsencrypt.org/) 来颁发证书，这也是下文所使用到的

这是个使用很广泛的免费颁发机构，如果想要让 certbot 其他使用 ACME 协议的颁发机构可以在一些主要命令后加上 `--server <URL>` 来指定其它地址。详情可以看看这个：[Changing the ACME Server](https://eff-certbot.readthedocs.io/en/stable/using.html#changing-the-acme-server)

## 安装

emm，certbot 是一个用 Python 编写的程序。所以用户大抵上是要处理各种各样的依赖问题的。在官方的引导网页（[certbot instructions](https://certbot.eff.org/instructions)）中，推荐的安装方式有 snap 和 pip 两种可选。\
老实说，对于全局系统工具而言... 好像都不咋地的说。但照着引导页面一步一步走基本上要做的事情也能弄明白一些

不过，官方文档写着推荐用 snap，不过我没装上生气就直接换成 docker 了（

更详细也更有用的安装文档在这里：[Get Certbot](https://eff-certbot.readthedocs.io/en/stable/install.html)\
其中我使用的是第一个代替选项 docker 镜像，虽然用 docker 短时间里跑一个小小的实用程序很奇怪，但毕竟最稳妥也更好重现（申请证书前先修环境什么的都不要呀www\
这一部分建议先去看看文档：[Alternative 1: Docker](https://eff-certbot.readthedocs.io/en/stable/install.html#alternative-1-docker)

从 docker 命令行启动用到的最基本的命令是这个：

```shell
sudo docker run --rm -it \
    -v "/etc/letsencrypt:/etc/letsencrypt" \
    -v "/var/lib/letsencrypt:/var/lib/letsencrypt" \
    certbot/certbot certonly
```

镜像的默认 entrypoint 被设置为了可执行文件，所以后面直接写上需要的参数就好。certbot 还可以和很多 web 服务器交互来填入证书什么的，但我更喜欢自己写配置，所以包括后文的命令都只会提到仅申请证书的模式
> To just obtain the certificate without installing it anywhere, the certbot certonly (“certificate only”) command can be used.

如果需要下文的 DNS 认证方式，则需要使用装有对应插件的镜像，比如 `certbot/dns-cloudflare`。
所有官方镜像存放在 Docker Hub 上：[u/certbot](https://hub.docker.com/u/certbot)

## 认证方式

有这些验证方式可选：[Getting certificates (and choosing plugins)](https://eff-certbot.readthedocs.io/en/stable/using.html#getting-certificates-and-choosing-plugins)

下文用到的是 DNS 验证。\
不知道为什么 docker 镜像里的 [Manual](https://eff-certbot.readthedocs.io/en/stable/using.html#manual) 模式好像没有手动 DNS 选项...

## 认证时的各种手动确认

在第一次申请一套证书的时候，certbot 会提示很多很多关于用户协议呀什么的信息，这些信息可以使用这些 flag 跳过：

- `--email <email_addr>`：注册应急邮箱地址
- `--no-eff-email`：不向 EFF 发送该电子邮件用于可能的宣传邮件
- `--agree-tos`：同意最终用户协议

但毕竟也只会碰到一次，手动填也不麻烦，只是放在这里说一下

## 证书都在哪里，要怎么使用

看文档：[Where are my certificates?](https://eff-certbot.readthedocs.io/en/stable/using.html#where-are-my-certificates)

证书的最新版本的各个文件会被存放在 `/etc/letsencrypt/live/example.com/*` 中。\
虽然每个证书可以携带一堆子域名，但列表中的第一个会被当作这一套证书的名称。比如填入的列表是 `example.com,tool.example.com`，最终的名称就是 `example.com`。\
现有的所有已配置的证书可以使用 `certbot certificates` 命令查看

服务器配置中的私钥一般填入对应域名下的 `privkey.pem` 路径，公钥则填入 `fullchain.pem`

## 注销/撤销证书

certbot 不会在删除证书之前撤销证书，但文档中说及时不撤销别人不知道私钥影响也不大，只是会收到些邮件而已。

基本命令：`certbot revoke --cert-name example.com`

文档：[Revoking certificates](https://eff-certbot.readthedocs.io/en/stable/using.html#revoking-certificates)

## 删除证书文件

证书不可以直接使用 `sudo rm` 删除，毕竟除了文件本身 certbot 还会储存一系列用于自动化续期的配置。\
官方的删除方式是：`certbot delete --cert-name example.com`

可以看看这里：[Deleting certificates](https://eff-certbot.readthedocs.io/en/stable/using.html#deleting-certificates)

## 续期

命令 `certbot renew` 可以检测所有被配置了的证书，如果证书在30天内会过期，就会对其进行续订

文档：[Renewing certificates](https://eff-certbot.readthedocs.io/en/stable/using.html#renewing-certificates)
