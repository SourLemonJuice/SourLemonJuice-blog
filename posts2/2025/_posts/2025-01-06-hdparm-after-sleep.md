---
title: "如何让 hdparm 在系统从睡眠恢复时应用硬盘电源配置"
date: 2025-01-06 06:41 +0800
---

根据 ArchWiki 中的 [hdparm](https://wiki.archlinux.org/title/Hdparm) 的介绍，hdparm 可以用于配置硬盘的各种电源管理参数，但这些操作不是永久的需要手动管理才能在重启或睡眠后生效

## 启动时使用 udev 规则

udev 规则是 [ArchWiki #Persistent configuration using udev rule](https://wiki.archlinux.org/title/Hdparm#Persistent_configuration_using_udev_rule) 中推荐的持久化方式。\
这是 wiki 中给出的例子之一（为所有会旋转的硬盘修改 [APM/高级电源管理](https://en.wikipedia.org/wiki/Advanced_Power_Management) 等级到 127）：

```text
# /etc/udev/rules.d/69-hdparm.rules

ACTION=="add|change", KERNEL=="sd[a-z]", ATTRS{queue/rotational}=="1", RUN+="/usr/bin/hdparm -B 127 /dev/%k"
```

其实挺好用的，但问题是这些配置会在每次系统断电后重回默认值。关机重启时 udev 规则能救，但各各休眠们可不会

## systemd 单元

半参考这篇回答 <https://unix.stackexchange.com/a/89013/678474>

重点就是要定义一个执行一次性命令的系统单元，并在正常启动和睡眠（广义上的 sleep）结束后启动：

```ini
# /etc/systemd/system/hdparm.service
[Unit]
Description=setup hdparm

[Service]
Type=oneshot
ExecStart=/usr/bin/hdparm -S 60 '/dev/disk/by-id/<disk-id>'

[Install]
WantedBy=multi-user.target sleep.target
```

`/dev/disk/by-id/...` 是要比 `/dev/sdx` 更持久化的磁盘定位方式。该文件夹下的文件都是指向 `/dev/...` 的软链接，要想找到对应的条目的话用 `ls -l` 看一下指向的目标就好咯

前面的回答中写了 `After=suspend.target` 和 `WantedBy=suspend.target`，先说 After，这其实并不重要，毕竟 After 是用来排序的，如果 A 与 B 都会在 base 之后启动那为什么需要都特地声明一下它们每个单元都排在 base 之后呢

至于为什么用 `sleep.target` 而不是 `suspend.target`，可以参考 ArchWiki 中的：[Power management/Suspend and hibernate #Custom systemd units](https://wiki.archlinux.org/title/Power_management/Suspend_and_hibernate#Custom_systemd_units)\
简而言之就是，`sleep.target` 是诸如 `suspend.target` 和 `hibernate.target` 等睡眠模式的合集。毕竟 hdparm 的配置在哪个模式下恢复都会丢失，所以就直接写这个范围最广的啦

而且 `multi-user.target` 好像也有点没必要，可以在提前一些... 不过嘛 ArchWiki 也在 [#Putting a drive to sleep directly after boot](https://wiki.archlinux.org/title/Hdparm#Putting_a_drive_to_sleep_directly_after_boot) 章节里用的 `multi-user.target`，问题不大awa

## 验证

虽然我的主要目标是修改停转时间（`-S <num>` flag），但磁盘上的这个参数没法获取只能设置。但也还是可以试探性的在服务配置中设置一下 APM 等级（`-B <num>` flag）再在系统恢复时查看是否修改成功（不带参数的 `-B`）

或者看简单的一眼服务的日志就好：`systemctl status hdparm.service`
