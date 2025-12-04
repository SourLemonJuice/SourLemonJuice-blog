---
title: "DIY SlimeVR 追踪器的总结"
tags: "greatest-hits"
---

## 0.时间线

整篇文章写于不同的时间，所以可能会出现些前后重复和矛盾的情况（会吗？）\
这些是每次修改时发生了的事情：

- [1.main()](#1main) 中写的那样
- 用纯焊飞线的方式制作了第一个追踪器
- 调试加想办法校准干了将近一天，决定换pcb和外壳并把那天的内容稍微记下来点
- 用pcb焊好了除了某个小电阻和imu以外的所有元器件后，等正确的电阻到货
- 完整做完了 5主要+1扩展 个

## 1.main()

记录一些乱七八糟的琐事吧\
不过主要是因为电烙铁坏了，看着一桌子的零件就那么摆着有点小郁闷啦

应该不会有专门解释`slimevr server`使用相关的内容，不过就现在的易用程度来看，应该也不需要来专门看教程吧

### 1.2.缘由

没什么，有一个VR不怎么想玩，VRChat嘛emm，对吧\
还是技术相关的东西更好玩一些，PCVR这东西要想玩的花软件上的功夫可不少。

### 1.3.你确定这话不矛盾吗

确实，那在这之前我试了这个<https://github.com/ju1ce/Mediapipe-VR-Fullbody-Tracking>，一个纯视觉识别的全身动捕，但是效果不怎么好，*虽然我没怎么看文档.小声*\
加上做一套slimevr*也不是多麻烦*或者多贵，那也就试试嘛，要是没用了估计还能赚点手工费（怪表情），还是觉得好玩啦。

## 2.开始并了解slimevr

在正式开始之前强烈建议去试试`owotracker`，这是一个把手机当成一只slimevr的软件\
你可以通过它了解`slimevr server`的安装和配置，以及在还没有追踪器时预览它们到底会做些什么\
在你拥有了追踪器后它也可以当作一个正常的追踪器放在..最好放腰部或者胸部吧，手机挺贵的\
官方对此也有所介绍 [link](https://docs.slimevr.dev/tools/owoTrack.html)

因为这东西最终几乎只能用在`VRChat`里（仅讨论游戏领域），所以和几乎所有跟游戏沾边的东西一样，先去b站找一圈，从而得出结论，VR确实是个小众的圈子动捕更是，或者也不完全是但我真的没找到太多教着**做**硬件设备的，大家都买现成的吗，这里找了些

- [SlimeVR 萌新科普指南](https://www.bilibili.com/video/BV13T41177Kh)
- [仅需580元！自制VR全身追踪器 slimevr 全中文教程 高精度全身追踪 owotrack](https://www.bilibili.com/video/BV1ZR4y1H75i)
- [小白向SlimeVR焊接教程+自制PCB板子](https://www.bilibili.com/video/BV1WF411P7MM)

hmm，好吧，还是去官网吧\
结果他们甚至没有有自己的主网页，所有介绍都是写在 [crowdsupply](https://www.crowdsupply.com/slimevr/slimevr-full-body-tracker) 上的。\
而且他们也有官方域名<https://slimevr.dev/>但是会重定向到`crowdsupply`。\
话说他们的[github项目页面](https://github.com/SlimeVR)好像更适合放到书签夹里，上面写了所有可能要用的官方链接

不过他们还是有文档页面的啦，在这里<https://docs.slimevr.dev/>

这些文档详细的写了如何配置和制作`slimevr`，包括[零件表](https://docs.slimevr.dev/diy/components-guide.html)，[接线图](https://docs.slimevr.dev/diy/tracker-schematics.html)，[IMU传感器选择](https://docs.slimevr.dev/diy/imu-comparison.html)，[固件刷写](https://docs.slimevr.dev/firmware/index.html)，和其他的怪问题们，发教程不发官方文档的都在想什么阿喂

## 3.购买零件

### 3.1.电子部分

[components guide/元件指南](https://docs.slimevr.dev/diy/components-guide.html)

这部分其实都好说，主要是`IMU传感器`，和`开发板`，还有`电池`，电池要根据外壳型号选择，其余看性价比什么的，这是我的:

- 开发板:`wemos d1 mini`(指南里推荐用的这个，又没有溢价)
- IMU: `BMI160`(相对便宜性价比高点，也是指南里推荐的啦，这些也没什么可选的)

我想做的是*5个追踪器加一个扩展追踪器* 所以要用 5个`开发板`6个`IMU`\
扩展连接线用的是`JST`接口，确定好壳子到底要哪个大小的，或者直接焊线

> 不要在决定外壳和接线方式之前买电池，但可以根据其他硬件选外壳\
> 另外在买`imu`和充电板时记得多买一两个，谁知道你会做些什么或者快递会做些什么

### 3.2.外壳，与接线

如果你有3D打印机也会建模，那恭喜你咯（酸）\
如果不会（比如我），也可以找些别的代打业务打印，但模型从那里找就麻烦了。

我最开始用的是[Hyperion](https://github.com/Smeltie/Hyperion)和[一个它的fork](https://github.com/Lafikateh/Hyperion)，他们是基于飞线的设计\
**Lafikateh**的fork里有适用于`BMI160`的扩展模块外壳

但是...，有点被飞线弄崩溃了，所以最后用的PCB板子\
<https://github.com/Shine-Bright-Meow/SlimeVR-Hyperion-BMI-BNO-PCB-Case>\
非常见名知意，而且我用的是`s22f32`的开关，作者给的托盘就是一个薄片拿个1mm的塑料片就能代替（蛮奇怪的）

如果你没有特别多的焊接经验最好还是用整张PCB，价钱差不了太多甚至持平（取决于你的外壳费用），但能大大降低你的血压和元件短路概率

如果想找喜欢的方案的话可以去官方discord里看看（只是说一嘴，去看指南）

> **注意** 请一定要仔细检查**最终**方案的元件表，认真确认每一个元件

### 3.3.绑带

这个还是看指南吧，可以试试搜`魔术贴绑带`什么的\
<https://docs.slimevr.dev/diy/components-guide.html#straps>

## 4.焊接

### 4.1.焊接工具

我上次焊东西都不知道是什么时候的事了，Hmm，我本来就不怎么喜欢动这种硬件吧\
尤其是这东西全都是飞线，还有好多焊孔里有两根线，这难度对我来说很地狱好嘛。

开头说的烙铁坏掉就是这段时间里的事情，在买烙铁的时候我也补充了一下那些以前遗留下来的"屎山"工具们。\
非要我说的话，可能会是：

- 能固定住pcb和电线的夹子，让心情不会爆炸
- 吸锡器去清理焊坏了留下来的实心焊盘
- SlimeVR的视频，不过是Youtube上的啦 <https://youtu.be/P0YX_eKyfxA>

### 4.2.制作，焊接

其实从最开始到现在已经过去了超久了，但没关系，在我写这一行的时候我已经焊好了一只Slime，其实也没什么想说的就只剩累了，好烦硬件相关的东西啊啊啊

还是有些注意事项要说的：

- 不要忘了，官方文档是你最好的帮手，永远不要忘记他们，因为它们甚至做了图形化的可配置的接线图 [文档链接](https://docs.slimevr.dev/diy/tracker-schematics.html)
- 如果有能力也有问题可以去官方discord服务器上逛一逛什么的 [discord链接](https://discord.gg/slimevr)
- 有点耐心，这东西确实烦人，如果没有一点锡焊基础的话... （小声：或许先买一两个没有电池的材料，最后加上`owotracker`试一试也不错）
- 不要省二极管的钱
- 对待**电池**永远不要大意，最好的情况下可以找些靠谱的接口连接电池。我没用咯，也不是那么那么重要啦，但还是小心点，焊线不要像其他的一样穿过去可能会断毕竟你是一定会弯它的
- 注意安全，保持通风，最好有只风扇架在旁边，那些烟有没有毒信谁都行但绝对不好闻（理论上闻着是没毒的啦，但是记得勤洗手）

### 4.3.构建固件

看官方教程！！！很重要，这里就不作可能过时的详细"误解"了\
<https://docs.slimevr.dev/firmware/index.html>

它们已经做的很简单了，装好插件改些必要配置就行，需要改`#define`的地方甚至有图形化配置（都到这里了还会用这个？）

注意：**不要在连接着开发板上传时打开电池开关**，我也不知到为什么，没用过esp，但接线图上写了不过是内嵌的文字，整页翻译翻不到这里说一嘴

build -> upload -> ~yay~

> 记得时不时`git pull`更新一下代码仓库，如果有新提交想着去更新固件

## 5.校准

### 5.1.常规

<https://docs.slimevr.dev/server/imu-calibration.html>

照着指南走基本不会有什么问题，不过如果你用的是需要在特定方向转来转去的`BMI160`，还连接不到串口（物理），哈，呜呜...

### 5.2.BMI160温度校准

在校准指南页面里有这样一段神奇的话\
[bmi160-temperature-calibration-tcal](https://docs.slimevr.dev/server/imu-calibration.html#bmi160-temperature-calibration-tcal)

将追踪器降温到15摄氏度以下在**慢慢**加热到45度，这样做可以大幅减少"漂移"的概率\
蛮神奇的，我是想试一试但是来来回回好几次都失败了，要么进度不满要么直接没有进入校准模式，我应该会把这些错误归咎于硬件问题和加热的速度，虽然官方的指南感觉不是严谨的类型但原文是 **gradually heat them** 所以...\
不要在几秒中内就把温度拉高一两个"整数"，要像从**15-室温**时变化的速度那样慢慢加热，如果用的是热风枪，那在≤30左右的时候热源可能需要离IMU很远才行，这种温度对人来说很不敏感的嘛

我只给几个追踪器做了温度校准，毕竟太费劲了\
这几次的校准进度也都没有达到 60/60 不过应该也能比什么都没干好一点啦

## 6.结束了

在享受完DIY带来的喜悦后，或许应该去看看`slimevr server`里的身体比例校准和佩戴校准，还有翻各种设置，这些东西还是蛮重要的而且也不多。

虽然不想写软件上的问题但我还是想放几个我遇到了的

- 为什么不能直接连到`SteamVR`\
在安装server的时候我有注意到官方的安装助手，它会在安装时帮你下载server和slimevr驱动还有串口驱动，理论上来说如果你用它安装是不会出现这种情况了\
但它要从github上下东西还不会用系统代理所以我当时是直接下载了`server`的可执行文件去做的测试，现在也就还要手动安装驱动\
<https://github.com/SlimeVR/SlimeVR-OpenVR-Driver>
- 串口控制台里的输出呢\
我的调试都在linux下完成的所以不用关心这些，但windows那边是需要装驱动的\
不过我没实验成功也懒得管就是啦，放个`wemos D1 mini(ch340芯片)`的驱动地址：\
<https://www.wemos.cc/en/latest/ch340_driver.html>
