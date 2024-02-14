# linux下配置默认emoji字体

## 1.正常情况下配置字体的方式

其实我所有对字体配置的知识都只是从装windows字体开始的，因为windows有很多很多不同语言风格的字体所以导致了很多没有默认设置的字体出现错误。

根据[ArchWikiCN](https://wiki.archlinuxcn.org/wiki/%E5%AD%97%E4%BD%93%E9%85%8D%E7%BD%AE)的介绍，用`fontconfig`把 serif,sans-serif,sans,monospace 的默认偏好字体设置成了`noto`

```text
<alias>
 <family>serif</family>
 <prefer>
  <family>Noto Serif CJK SC</family>
  <family>Noto Serif</family>
 </prefer>
</alias>
...
```

## 2.emoji

但在一些程序中emoji显示并不正确，因为noto的emoji字体叫做`"Noto Color Emoji"`\
而配置中并没有带上它

其实这一点我也不太清楚毕竟我的中文字体是`Noto Sans CJK SC`，我之前没有配置过它们却一直都是默认项，应该是系统配置里有它们的原因吧 `/etc/fonts/conf.d/`

总之现在系统中还有个叫做，`segoe UI Emoji`的家伙，它把位置占了，这不对\
但更改匹配时的字体系列为： `<family>emoji</family>` 并没有什么用处，程序在使用字体时不会特殊强调这段`sans`里的*emoji*用的是`emoji`字体

所以如果这段文字是`sans`的那这段文字里的`emoji`也会去查找`sans`的字体序列，那把刚才的配置改成：

```text
<alias>
 <family>sans</family>
 <prefer>
  <family>Noto Sans CJK SC</family>
  <family>Noto Sans</family>
  <family>Noto Color Emoji</family>
 </prefer>
</alias>
```

现在程序就会默认显示noto的emoji了
