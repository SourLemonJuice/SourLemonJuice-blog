---
title: "在 Chromebook 上安装完整 Linux 发行版的方法总结"
---

## 一、关于 Chromebook 与 ChromeOS

Chromebook 本身是 Google 为了教育和轻度电脑使用者准备的纯“上网本”，我对它其实不太可能产生什么兴趣，但 Pixelbook Go 实在是太好看了哇，而且二手价还超级便宜（500多人民币？）\
至于这篇文章，大概会讲一些 Chromebook 的安全特性和安装标准 linux 发行版可能会遇到的问题吧。\
希望不会跑题太多（？

那么，首先顾名思义 ChromeOS 是 Chromebook 内的操作系统。\
我对二者的概念比较分明 ChromeOS 单指软件，而 Chromebook 则是搭载了众多安全功能的硬件平台，二者并不能混为一谈。\
但它们所对应的开源项目 ChromiumOS 的文档中则不是这样，这里说一下，这也只是我的风格而已。

## 二、ChromeOS 的功能性

我本身不想过多讨论 ChromeOS 的功能性，它很好的完成了它的目标任务——即能打开 Chrome 浏览器。\
这就是它的全部，linux 容器、Android 容器、没什么的本地软件，都不是什么重点也都不怎么好用。

但由于 Chromebook 的目标群体，它也具有相对来说极高的安全性和组织管理能力，这也是 Google 在其宣传页面上所大幅提及的。\
不过嘛，说是组织管理能力好但连个有密码的 socket 代理都不行（系统本体没有验证的弹窗，但 Chrome 有）

## 三、植入于底层硬件的高安全性

那现在，来看看 Chromebook 的机身里都藏了什么怪东西吧。

首先，请去看看 [mrchromebox.tech](https://mrchromebox.tech) 这位大佬的文档和自制固件们，但至少我会希望在没弄清楚之前先再考虑考虑实际操作。

主页中有很多地方写的相对含糊，想要弄清楚这些概念的话可以先看看这些 ChromiumOS 文档：

- [写保护/write protection](https://www.chromium.org/chromium-os/developer-library/reference/security/write-protection/)
- [闭箱调试/Closed Case Debug/CCD](https://chromium.googlesource.com/chromiumos/third_party/hdctools/+/main/docs/ccd.md)
- [词汇表/Glossary](https://www.chromium.org/chromium-os/developer-library/glossary/)

对于特定主题的链接等下会分别放到单独的段落下的

我的目标是“破解” Chromebook 的硬件本身，而非 ChromeOS 所以我也没有去了解太多和系统安全性相关的内容，我不是多想了解，但如果有兴趣可以看看这个: [Security in ChromeOS](https://www.chromium.org/chromium-os/developer-library/reference/security/security-whitepaper)。

### 可能的目标有哪些

- 使用替换引导加载程序\
    使用 Alternative Bootloader (AltFw)/替换引导加载程序\
    可以轻松的启动到其他标准系统，包括 live 镜像和储存盘内的已安装系统。\
    但这并不受官方支持
- 安装社区提供的第三方加载程序\
    用 [mrchromebox](https://mrchromebox.tech/#bootmodes) 开发的 UEFI 固件替换掉 Chromebook 中初始的专用固件。但有些 Chromebook 的替换加载引导也是 UEFI 的

### 哪些安全措施需要被移除

- 将 Chromebook 切换成开发者模式\
    这会禁用加载系统时的签名验证，并且获得系统内超级用户的权限
- 完全解锁 Cr50 安全芯片的安全功能，这个系统又称(闭箱调试/CCD)\
    可以用来关闭写保护，如果使用替换加载程序并不需要这么做\
    但如果需要刷入社区固件的话这是必需的，这也是为了不让 bootloader 变成砖（可以用 CCD 重新刷写固件）。

## 四、切换至开发者模式

有关开发者模式的详细信息可以参阅，ChromiumOS 文档: [Developer mode](https://www.chromium.org/chromium-os/developer-library/guides/device/developer-mode/)\
在默认启动固件页面时，可能需要的快捷键列表在这里: [Firmware Keyboard Interface](https://www.chromium.org/chromium-os/developer-library/guides/debugging/debug-buttons/#firmware-keyboard-interface)

总而言之，启动开发者模式后设备将可以运行非官方签名的镜像、从usb启动 ChromeOS 镜像、从替换引导程序启动标准系统。并且可以进入 ChromeOS 的 [Shell 命令行环境](https://www.chromium.org/chromium-os/developer-library/guides/device/developer-mode/#getting-to-a-command-prompt)。\
在 [VT-2](https://www.chromium.org/chromium-os/developer-library/guides/device/developer-mode/#get-the-command-prompt-through-vt-2) 终端下允许用 sudo 提升至最高权限。这也是后文中所有系统内（CPU/AP）环境下运行命令的地方

如果进行到了这一步，AltFw 就可以使用了。\
ChromiumOS 的文档在这里: [AltFw](https://www.chromium.org/chromium-os/developer-library/guides/device/developer-mode/#running-an-alternative-bootloader-legacy-bios)

这不意味着用户需要自己编译一个引导程序，设备本身的引导程序可能就已经足够可用（比如我的 Pixelbook Go）如果不可用可以用 mrchromebox 制作的脚本写入它的引导程序: [Firmware Utility Script](https://mrchromebox.tech/#fwscript)

想要启用 AltFw 需要先执行上文文档中最后的命令 `crossystem dev_boot_legacy=1` 更改系统选项。重启后在启动固件页面输入 Ctrl+L 快捷键，就可以进入替换加载程序菜单了。

如果需要写入完整的社区启动固件，还需要干些别的事情。

## 五、禁用写保护

想要写入自定义的启动固件就必须要关闭 Chromebook 的 [写保护/Write protection](https://www.chromium.org/chromium-os/developer-library/reference/security/write-protection/) 功能。\
如果该功能存在，系统将完全无法向固件储存器中写入任何的位。请务必去看看文档了解有关它的完整信息。

由于软件写保护只是决定硬件写保护何时启用，所以并不能在硬件写保护未关闭前直接打开它（我的猜测，懒得找来源了）\
关闭硬件写保护的办法在这里: [Disabling hardware write protect](https://www.chromium.org/chromium-os/developer-library/reference/security/write-protection/#disabling-hardware-write-protect)\
大致可以分为：

1. 拆除硬件保护螺丝（旧设备）
2. 使用 CCD 功能控制 Cr50 改变保护状态（新设备？）
3. 拆除电池以告知 Cr50 关闭写保护（新设备）

这里的重点当然是 CCD 咯（其他就是蛮拆就行），解锁完成后的步骤会放到下下个章节。

## 六、打开闭盒调试(CCD)

我已经等了很久了，呼，这是文档: [Google Security Chip (GSC) Case Closed Debugging (CCD)](https://chromium.googlesource.com/chromiumos/platform/ec/+/fe6ca90e/docs/case_closed_debugging_cr50.md)

但在使用 CCD 之前，需要一个 [SuzyQ](https://chromium.googlesource.com/chromiumos/third_party/hdctools/+/main/docs/ccd.md#suzyq-suzyqable) 线缆来访问对应的几个 [命令行串口](https://chromium.googlesource.com/chromiumos/third_party/hdctools/+/main/docs/ccd.md#raw-access)。\
或者参考 [这个段落](https://chromium.googlesource.com/chromiumos/platform/ec/+/fe6ca90e/docs/case_closed_debugging_cr50.md#ccd-open-no-boot) 以在无法启动设备的情况下打开 CCD。（最有用的就是拔电池）

如果已经拥有了一个 SuzyQ，就可以直接按照标准的方法打开闭盒调试，文档链接: [CCD Open](https://chromium.googlesource.com/chromiumos/platform/ec/+/fe6ca90e/docs/case_closed_debugging_cr50.md#ccd-open)\
这部分文档写的其实很详细了的说... 好不写啦

不过，文档中的很多命令是通过开发sdk的工具打开的，但其实简单来说直接用 tio 这种工具接上对应的usb串口就能访问了（cr50 对应 ttyUSB0，[参考这里](https://chromium.googlesource.com/chromiumos/third_party/hdctools/+/main/docs/ccd.md#raw-access)）（有 dut/AP 字样的是 ChromeOS 的控制台，我也不知道为什么）

控制硬件写保护的部分在这一段: [Control Hardware Write Protect](https://chromium.googlesource.com/chromiumos/platform/ec/+/fe6ca90e/docs/case_closed_debugging_cr50.md#hw-wp)

## 七、写入社区UEFI启动固件

请完全参考原作者的文档。\
比如，这是 [mrchromebox](https://mrchromebox.tech/#fwscript) 的，不过我也不知道有没有别人做这些。

呐，这就是，两个启动方式的大致处理步骤，都快成超链接战神了（累

## 八、让标准Linux能正常工作哇ww

有关兼容性，要不看看 mrchromebox 做的 [Supported Devices](https://mrchromebox.tech/#devices)（及其子链接们）

### 0.发行版的选择

对于一个非标准的笔记本，相对小众点的发行版是第一个就要被排除的\
虽然我用的不多，但笔记本的 触控板/屏幕背光/键盘背光 在linux下多多少少会有点小毛病

对于我的 Pixelbook Go（而不是你的设备）:

- Debian 还好，触摸板有点卡卡的
- PoP!_OS 的触摸板滚动还是有点问题，因为触摸屏的存在屏幕键盘会一直被调用出来还关不掉 [issue](https://github.com/pop-os/shell/issues/1503)。而且没办法调整键盘背光（但对应的内核模块已经加载）
- 现在用的是 Fedora Workstation，超棒的，但以前没用过还得熟悉熟悉

不过似乎所有发行版的屏幕背光的自动亮度调整都不顺滑，对我倒是无所谓的

### 1.音频部分

这里有个超棒的项目: [WeirdTreeThing/chromebook-linux-audio](https://github.com/WeirdTreeThing/chromebook-linux-audio)

### 2.键盘映射

或许 [fascinatingcaptain/CBFixesAndTweaks](https://github.com/fascinatingcaptain/CBFixesAndTweaks)\
或者 [How do I setup a keyboard mapping compatible with a Chromebook?](https://askubuntu.com/questions/566060/how-do-i-setup-a-keyboard-mapping-compatible-with-a-chromebook)

不过有些问题，Chromebook 上独有的 Assistant 按键在 [xmodmap](https://wiki.archlinux.org/title/xmodmap) 里是识别不到的，可以参考下这里: [crouton:issue#3505](https://github.com/dnschneid/crouton/issues/3505)

所以我们需要些更底层的方式将 Assistant 按键键值映射到其他的值上，也就是直接给 input event 开刀。\
这方面上 Archwiki 里已经有了相对详细的说明: [Map scancodes to keycodes](https://wiki.archlinux.org/title/Map_scancodes_to_keycodes)\
不过，很多概念我也懒得搞明白了，下面都是随便写的，记得看上面的链接

整个过程需要用到两个工具

- `evtest` 用来测试键值
- `evemu-describe` 用来获取 event 详细信息

而最终目标则是将**某个**特定键盘，或**某些**类型的键盘的 Assistant 转换成类似 Meta 的按键。\
实现映射功能的是 systemd-hwdb，它的配置文件允许匹配

- `input:` 开头的映射块名称，类似\
  evdev:input:b0003v32ACp0012e0111-*
- `模块名:dmi:...` 开头的 DMI 表示符，类似\
  evdev:atkbd:dmi:*

#### 2.1.匹配事件映射块

配置文件中可以使用的通配符在手册中有写: [HWDB(7)](https://man.archlinux.org/man/core/systemd/hwdb.7.en)\
要想获取 DMI 名称可以运行不带参数的 `evemu-describe`，并选择看起来像键盘的 event 设备，详细信息中应该会有写。虽说我也不知道这堆值具体都是什么意思。\
加上通配符，最终效果可能类似这样: `evdev:atkbd:dmi:bvn*:bvr*:bd*:svnGoogle:pnAtlas:pvr*`\
反正这个是能匹配 Pixelbook Go(硬件代号Atlas) 的键盘啦

或者可以按照 [#Remap specific device](https://wiki.archlinux.org/title/Map_scancodes_to_keycodes#Remap_specific_device) 章节所述的那样，直接使用 `input:` 开头的映射块名称，看起来更直观一些，笔记本的内置键盘也不可能有第二个，所以看心情咯。\
匹配字段的效果类似:\
`evdev:input:b0000000000000A*`

#### 2.2.映射键值

Archwiki 中说的已经挺多的了（咕\
不过可以补充两句

每条映射看起来是这样的:\
`KEYBOARD_KEY_1a=leftalt`\
其中 `1a` 是用 `evtest` 测出来的键值，而等号右边的字符在运行 `evtest`, `evemu-describe` 时会有输出，类似: `Event code 30 (KEY_A)`\
将其中的 `A` 转换成小写(`a`)就是需要放到等号右侧的目标键值了。比如: `KEY_LEFTMETA` -> `leftmeta`

Archwiki 中说可以在 `/usr/include/linux/input-event-codes.h` 下找，但好像会比这些工具的输出少一些，所以还是看工具的输出吧。

#### 2.3.记得刷新HWDB的数据库哦

啊，对了这些东西不是实时生效的，刷新方式什么的去看 wiki

简单点，就是用最高权限执行这些:

```shell
systemd-hwdb update
udevadm trigger
```

## --、碎碎念

- 其实到现在我也不清楚 [EC/集成控制器](https://chromium.googlesource.com/chromiumos/platform/ec/+/d92daea73957789df43e458d31fadae7d2c64989/README.md) 是怎么参与启动流程的
- 所以 AP 到底指代的是什么 ChromeOS 还是处理器硬件模块，指代关系怎么老是变化阿喂
- 你知道吗，我因为偷懒花了80多块钱买 SuzyQ... 有能力的花完全可以自己买几个电阻和分线版做一个呀
- 我的2023年是和 Nintendo Switch 过的，2024上半年是和 Chromebook 过的，要不回头买点别的旧的能“破解/不走寻常路”的怪设备当成个爱好玩233
- 要不是我真的喜欢 Pixelbook Go 的外观和做工，我才不会折腾这么多东西呢，有关 Chromebook 的社区资料真的没多少（累
