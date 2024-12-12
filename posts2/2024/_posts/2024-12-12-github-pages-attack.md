---
title: "由于 GitHub Pages 自定义域缺乏验证进而可能导致的攻击"
date: 2024-12-12 00:00 +0800
---

GitHub Pages 一直拥有将部署的网站使用自定义域的能力：[配置 GitHub Pages 站点的自定义域](https://docs.github.com/zh/pages/configuring-a-custom-domain-for-your-github-pages-site)。\
但在添加域时的验证措施却很容易被篡改

## 原因

在 GitHub 仓库设置中的 Pages 选项卡下，将 Pages 添加自定义域只需要填入测试的域名（比如 `x23w8o0xodjf.hidden.sourlemonjuice.net`），并将该域名的 DNS 记录设置为指向 GitHub Pages 服务器的 IP 地址或 **任何一个** GitHub 用户所属的 `*.github.io` 地址（比如 `github.github.io`）。\
无需更多操作即可验证域名

由于所有 GitHub Pages 指向的都是同一组服务器，而且整个验证过程不需要 DNS 记录的干预。\
所以，如果仓库所有者将域名以何种方式删除了该 Pages 或者整个仓库，但没有删除 DNS 记录（比如由于 DMCA 或者只是单纯忘记了），其他的 GitHub 用户将可以立即占有该域而不会经过任何的所有权验证

## GitHub Pages 的所有权系统

GitHub 并不是那么愚蠢，在用户设置下的 Pages 选项卡有着一个大大的 **Verified domains** 栏目：[验证 GitHub Pages 的自定义域](https://docs.github.com/zh/pages/configuring-a-custom-domain-for-your-github-pages-site/verifying-your-custom-domain-for-github-pages)

在此页面下验证了对于某个 APEX 域的所有权后（比如 `sourlemonjuice.net`），任何其他用户都将无法验证域的所有权：

> 报错如下：\
> The custom domain x23w8o0xodjf.hidden.sourlemonjuice.net is already taken. If you are the owner of this domain, check out https://docs.github.com/pages/configuring-a-custom-domain-for-your-github-pages-site/verifying-your-custom-domain-for-github-pages for information about how to verify and release this domain.

此处的验证需要在 APEX 域下添加一个特殊且随机的 TXT 类型 DNS 记录，相比与只需要添加单一的指向 GitHub Pages 服务器的 CNAME 记录，这可以明显的阻止未经认可的域名验证。\
即使如此，如果其他用户在验证 APEX 域之前就已经将子域验证，那所有者也无法验证此前被其他用户占有的子域

## 可能的改进方式

呃，直接让用户强制在用户设置下验证域不就好了（？）

那 GitHub 为什么只是在输入框下面放了个指向文档的链接呢（盯）
