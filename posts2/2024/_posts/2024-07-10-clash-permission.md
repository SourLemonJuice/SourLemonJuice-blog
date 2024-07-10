---
title: "Clash Verge Rev v1.7.0 后 Linux 下启动 TUN 模式失败的解决方法"
---

在 [Clash Verge Rev v1.7.0](https://github.com/clash-verge-rev/clash-verge-rev/releases/tag/v1.7.0) 的更新日志的功能中有这样一行：
> 移除内核授权，改为服务模式实现

在以前 clash verge linux 版一直都是依靠手动点击一个按钮并运行一段命令来给予可执行文件一些特殊的网络操控能力的，详情在 [clash-verge: issue#182](https://github.com/zzzgydi/clash-verge/issues/182)

这次更新的功能算是将这一步骤放进了软件的系统服务中，开启服务模式软件就会自己干这些事情。
