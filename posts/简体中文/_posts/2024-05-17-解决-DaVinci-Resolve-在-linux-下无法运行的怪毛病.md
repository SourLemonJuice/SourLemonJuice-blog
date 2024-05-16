---
title: "解决 DaVinci Resolve 在 linux 下无法运行的怪毛病"
tags: ["DaVinci-Resolve", "Bug-Fix", "Utilities", "Linux", "PC-Desktop"]
---

在尝试启动达芬奇但无法执行后需要 debug 的第一件事就是用终端启动它的可执行文件看看报错是什么。\
安装路径是 `/opt/resolve/` 可执行文件是 `/opt/resolve/bin/resolve`

## Glib 库文件错误

我的情况与这个帖子一样 <https://www.reddit.com/r/Fedora/comments/12z32r1/davinci_resolve_libpango_undefined_symbol_g/>

也就是:

```text
./resolve: symbol lookup error: /lib64/libpango-1.0.so.0: undefined symbol: g_string_free_and_steal
```

但在替换了 `libglib-2.0.so.0` 指向的路径后问题转移成了

```text
./resolve: symbol lookup error: /usr/lib/libgdk_pixbuf-2.0.so.0: undefined symbol: g_task_set_static_name
```

总之所有事情都与 glib 有关是吧，在然后就看到了这篇帖子: [Davinci Resolve stopped working, after update?](https://discuss.getsol.us/d/9386-davinci-resolve-stopped-working-after-update)

简单来说就是吧 glib 的所有 `.so` 全都替换成系统版本的，不过我只替换了所有 `.so.0` 软链接的目标到系统库，也就是类似 `/usr/lib/libglib-2.0.so.0`。\
我更倾向于这么改，毕竟不用动二进制文件嘛，谁不想欺负软链接呢。

...终于能工作了，烦人

## 不识别 GPU

对了，如果不识别 GPU 的话记得看看装没装 OpenCL 相关的库。\
Archwiki: <https://wiki.archlinux.org/title/GPGPU>
