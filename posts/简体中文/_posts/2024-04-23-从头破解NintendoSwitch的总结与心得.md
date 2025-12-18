---
title: "从头破解 Nintendo Switch 的总结与心得"
tags: ["Featured", "Nintendo", "Nintendo-Switch", "Hacking"]
has_modified: true
---

整理一些自己在破解 `Nintendo Switch` 做的事情。\
整片帖子不会详细的写清每一步要做什么，请善用搜索引擎（当然啦，用英文）以及看看那些项目开发者幸苦写的文档吧

注意，整片帖子应该没有任何图片，我尽量排的好看点啦\
也可以看看这个: <https://nh-server.github.io/switch-guide/>

## 缩写/术语 列表

|缩写|全称|中文解释|
|:--:|:--:|:--:|
|搜索引擎||Google, Bing, Baidu, ...|
|HOS|Horizon OS|Switch 系统代号|
|OFW|Original Firmware|原始系统/固件|
|CFW|Custom Firmware|经修改过的系统/固件|
|NAND/emmc|NAND 存储|此处特指机身内置闪存|
|emunand/[emummc](https://github.com/m4xw/emuMMC)|Emulated NAND|虚拟的完整闪存镜像，或指其功能性|
|title||HOS中拥有高权限的游戏，也包括系统组件|
|自制软件||社区制作的 .nro 小软件，只能利用部分系统资源|
|hbmenu||Atmosphere/大气层 的自制软件菜单（覆盖层）|

CFW 不是中国防火墙啦

可以去看看: <https://rentry.org/SwitchTerminology>

---

## 硬件

先从硬件开始，我想用的机器是 switch续航版，所以必须要用上一些硬件魔法。\
通过咸鱼几分钟买到了硬件，加上b站视频大法，最后还有我不怎么样但并不萌新的焊工...

就结束咯，详情可以参考一些锡焊教程。另外 switch 的螺丝很软的，记得别太暴力

## 关于 hekate Bootloader

`hekate` 是所有被破解的 switch 的核心，作为 bootloader 它是启动后第一个被加载的程序并以此为基础为其他软件打好地基。\
GitHub链接: [CTCaer/hekate](https://github.com/CTCaer/hekate)

要想安装它，只需要将下载下来的压缩包（类似: `hekate_ctcaer_6.1.1_Nyx_1.6.1.zip`）解压到 sd 卡的根目录即可，记得看官方手册

除此之外，硬件设备大多只会识别SD卡根目录下的某个特定文件，比如 `payload.bin`，想要通过硬件启动就需要将压缩包根目录的 类似`hekate_ctcaer_6.1.1.bin` 改成对应的文件名

安装好后就可以使用 hekate 的众多实用工具啦，如果认识英语或者善用翻译软件的话很快就会掌握的对吧，反正我相信你是不需要看其他半桶水发得奇怪视频的

## Atmosphere/大气层 破解系统以及部分配置方式链接

所谓的大气层系统就是用来实际破解HOS的一套工具，提供了让所有人熟知的哪些功能。\
GitHub链接: [Atmosphere-NX/Atmosphere](https://github.com/Atmosphere-NX/Atmosphere)\
记得看看有没有预发布版本哦

解压，复制到根目录，想知道什么别的记得看文档...\
<https://github.com/Atmosphere-NX/Atmosphere/tree/master/docs>

- 如果想认识或修改覆盖层的触发方式可以看看: [docs/features/configurations.md#override_configini](https://github.com/Atmosphere-NX/Atmosphere/blob/master/docs/features/configurations.md#override_configini)
- 有类似与软抹除序列号之类的想法的可以从这里开始: [docs/features/configurations.md#exosphereini](https://github.com/Atmosphere-NX/Atmosphere/blob/master/docs/features/configurations.md#exosphereini)

### 安装大气层签名补丁(Signature Patches)

可能是为了避免版权纠纷，在安装非官方软件，即"盗版"游戏/title 时需要为大气层添加签名补丁，详情请见搜索引擎

如果想用别的大佬弄好的版本可以看看 gbatemp 中的 [这条神秘帖子](https://gbatemp.net/threads/sigpatches-for-atmosphere-hekate-fss0-fusee-package3.571543/)\
已经提示很多了哦，嘿

### 屏蔽任天堂官方服务器的方式

大气层的文档中关于本机 host 文件的介绍: [docs/features/dns_mitm.md](https://github.com/Atmosphere-NX/Atmosphere/blob/master/docs/features/dns_mitm.md)\
在这个好东西出现之前屏蔽服务器的方式是 [90DNS](https://gitlab.com/a/90dns)，通过架设一个 DNS 服务器来屏蔽所有任天堂官方服务器。\
使用 host 文件重定向则与之类似，但将所有工作放到了本地。\
毕竟 90DNS 的工作又不是动态报告 IP 地址，只是全部解析成回环罢了

对此，可以参考一下这篇 [文章](https://nh-server.github.io/switch-guide/extras/blocking_nintendo/)

需要注意的是，很多教程中的 `emummc.txt` 使用了IP `95.216.149.205` 来欺骗用于网络连接测试的域名，该 IP 隶属于 90DNS 但有关其安全性的问题我也不清楚，看你自己的想法咯。\
附上一个 gbatemp 上有关的帖子: [Safety of pointing Nintendo servers to 95.216.149.205](https://gbatemp.net/threads/safety-of-pointing-nintendo-servers-to-95-216-149-205.628528/)

如果想测试屏蔽状态可以使用 90DNS 推荐的测试软件: [meganukebmp/Switch_90DNS_tester](https://github.com/meganukebmp/Switch_90DNS_tester/)

总之，如果你的 CFW 是新出炉的，软抹除序列号加域名屏蔽是最好的选择

## hekate 启动项的配置

详情请查阅 hekate 的文档。\
这是我的 `hekate_ipl.ini` 文件（不完整），除了 `icon` 路径以外其他基本都能通用。

```ini
[config]
# ...

[HOS/OFW - sysMMC]
fss0=atmosphere/package3
emummc_force_disable=1
stock=1
icon=bootloader/res/switch_hue.bmp

[CFW - emuMMC]
fss0=atmosphere/package3
kip1patch=nosigchk
emummcforce=1
atmosphere=1
icon=bootloader/res/atmosphere_hue.bmp

[CFW - sysMMC]
fss0=atmosphere/package3
kip1patch=nosigchk
atmosphere=1
emummc_force_disable=1
icon=bootloader/res/payload_hue.bmp

[fusee]
payload=bootloader/payloads/atmosphere_fusee.bin
icon=bootloader/res/payload_hue.bmp
{}
```

注意，如果没有安装大气层签名补丁，从 hekate 启动时报没有 `nosigchk`，甚至启动 eMMC 上的任何系统时蓝屏，都是正常的。\
对于启动时蓝屏可以看看这篇帖子: [Blue screen after udating sysmmc with hwfly](https://gbatemp.net/threads/blue-screen-after-udating-sysmmc-with-hwfly.641239/)

顺便扔一个有关图标的 gbatemp 帖子: [Help with hekate icons](https://gbatemp.net/threads/help-with-hekate-icons.636892/)

## 设备密钥提取

大气层的签名补丁只能让其正常破解系统，但仍然安装不了 title（可以运行），这也是为什么我要把它放在大气层与 hekat 的配置章节之后

想要提取 eMMC 中的密钥，可以使用 [shchmue/Lockpick_RCM](https://github.com/shchmue/Lockpick_RCM)，但如你所见它被 DMCA 了...
我现在用的是它的 fork: [Decscots/Lockpick_RCM](https://github.com/Decscots/Lockpick_RCM)\
我不知道它的未来会怎样，但这种核心组件在什么时候都一定会有继任者的，不然 ns 的破解圈子才是真的凉了

总之一般来说提取后的密钥们放在 `SD://switch/*.key`，一般需要密钥的自制软件也会自己去这里找

---

## 游戏副本(title)的安装与提取

一般的游戏副本有 `NSP`, `NSZ`, `XCI`, `XCZ` 几种\
NSx 是游戏安装文件，而 XCx 是卡带镜像文件，二者都能使用但还是要明白区别的。至于 xxZ 代表的是它们的压缩版本，这两种压缩格式是社区订制的

**注意**：安装 游戏/title 必须安装大气层的签名补丁，并且需要被提取设备的密钥（均见上文）

### 安装游戏用的社区自制软件

嘛... 别问，反正我就用 [DBI](https://github.com/rashevskyv/dbi)，只要有一定的好奇心 DBI 真的能解决 switch 上几乎 70% 的问题。\
同样的，如果你看得懂英语或者善于使用翻译软件的话

### 提取游戏副本用的社区自制软件

我一直用的 [DarkMatterCore/nxdumptool](https://github.com/DarkMatterCore/nxdumptool) 如果可以记得尝试一下它的预发布版本，目前为止作者正在努力重写这坨软件

如果想用 nxdumptool 的 usb 模式而且你再用 linux 那么可以看看: [v1993/nxdumpclient](https://github.com/v1993/nxdumpclient)

---

## 其他的常见小问题

### 怎么在新系统里进入完整模式的覆盖层

如果你认真研究了覆盖层文档的话应该明白怎么配置打开快捷键，但新系统里可是一个正经 title 都没有的。\
所以，那就尝试装一个咯。我比较推荐提取下 eshop 里的 youtube 装上去，占地不大也有些整蛊的乐趣，不过需要伪链接任天堂账户（见下文）

至于很多整合包的根目录下放的 `hbmenu.nsp`...\
或许来自 [gbatemp 的帖子](https://gbatemp.net/threads/homebrew-menu-nsp-updated.588319/)？\
但就像下面的人所说的一样，由于其中包含的 hbmenu 版本很容易落后，不如拿它的本体当作摆设，并将覆盖层按键设置为 `=!R` 之类的反向触发系统本身的 hbmenu 覆盖层

### 破解后的系统平时到底能不能联网

如果修改了 DNS 阻断了与官方服务器的链接而且还软抹除了序列号，我觉得没什么问题，我的ns的后半生几乎都是连着网用的而且也没有抹除序列号

### 软抹除序列号会有什么副作用吗

大气层的 [exosphere.ini](https://github.com/Atmosphere-NX/Atmosphere/blob/master/config_templates/exosphere.ini) 模板中的注释已经回答了:

```ini
#  NOTE: This is not known to be safe, as data may be
#   cached elsewhere in the system. Usage is not encouraged.
```

中文翻译:

> 注意：这并不安全，因为数据可能会被缓存在系统的其他地方。不鼓励使用。

### 游戏启动需要链接任天堂账户

这个问题其实中文互联网上说的也很多很多，解决方法就是 [rdmrocha/linkalho](https://github.com/rdmrocha/linkalho)，不过很神奇的是作者（rdmrocha）好像吧仓库删掉了。\
嘛... 没辙了... 说不定去其他网站找个副本（比如[这种](https://shipengliang.com/games/switch-%E7%A6%BB%E7%BA%BF%E5%85%B3%E8%81%94%E8%B4%A6%E6%88%B7-kefir-updater%E6%9B%BF%E4%BB%A3%E5%93%81linkalho%E4%BD%BF%E7%94%A8%E6%95%99%E7%A8%8B.html)）？\
总之，祝你好运

---

## 结尾/尾巴

这篇文章我从明白了破解需要的项目后就想写了，但实际来写这篇帖子却是在想卖掉 ns 的那天。换个角度想这片帖子也有了一个优雅的地方存放（SourLemonJuice-blog）不是么。

任天堂的游戏好玩归好玩，但联网游戏的基础功能要订阅对于我这个喜欢多人游戏但不怎么玩的人来说，实在是很过分了，抱歉咯

任天堂的软件开发部一直都很有创造力，但悠久的历史也让它们的决策层放不太开手脚迎接这个半导体技术飞速发展的时代。\
你明显可以从它们做的稀烂的联机游戏以及 ns 低配高价的策略上看出来

我也没有什么更多想说的了，或许一个喜欢折腾软件的人就是跟任天堂合不来吧

---

还有，感谢所有 hacker 们提供的开源项目，即使这个社区已经变得不再那么景气，但我至少还能向你们道一声谢，对吧。
