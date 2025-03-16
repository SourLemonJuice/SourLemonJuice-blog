---
lang: "zho-Hans"
title: "用端到端加密在自托管的云服务器上安全的储存和同步文件的思路"
date: 2025-03-15 23:23 +0800
---

在一段时间以来我都想在电脑和移动设备之间同步某些文件，可能是笔记可能是照片。但纵使像 Google Drive 这样的云盘提供了稳定的储存空间但数据安全则完全不被保证。\
所以这段时间去研究了下怎么在不信任云盘提供商和自托管的情况下储存和同步文件们

## 远程访问方式

在传输文件这个方面上，开发者与服务器之间常用的 SFTP 是稳定且安全的协议，但它与 SSH 半绑定也不适合完全分离的账户控制（或者说很麻烦？）

加上各种各样的破事，WebDav 倒是现在相对通用的一种文件传输协议。它是 HTTP 的扩展，完全服务于文件传输，可以用用户名和密码控制访问权限，也可以直接经过反向代理添加统一的 TLS 支持。\
许多支持远程同步的软件也很有可能开放一个 WebDav 的接口方便使用。这一点绝对是值得被考虑的，下文的所有内容也都将围绕着这个最基础的 WebDav 来写

## WebDav 服务器

Apache 和 Nginx 竟然也能当作 WebDav 服务器诶，情理之中但意料之外。\
另外也有其它独立的实现，比如这个：[github.com/hacdias/webdav](https://github.com/hacdias/webdav)

## 访问与同步文件

有了协议就要能访问，在 Linux 上 KDE 和 GNOME 的 Dolphin 和 Nautilus 文件管理器都支持打开网络位置，你可以用 `davs://` 或者没有加密的 `dav://` 当作 scheme 试一试。\
此处的 URL 还代表当前要访问的路径，比如 `folder1/subfolder/` 这个目录反映到 URL 中就是：`davs://example.com/folder1/subfolder/`。\
有些服务器可能会允许在 URI 部分前加上一个前缀，比如 `davs://example.com/dav/` 代表的是主目录

在所有支持 WebDav 的软件里填写对应的主机名和用户名密码，或者使用 HTTP 的 scheme（比如 `https://example.com`）就可以直接使用啦（大家对 scheme 的标准都超不统一的）。\
另外 rclone 这个命令行工具的挂载点功能可以让其它普通程序轻松的交互云端的文件，并且以最自然的方式让用户与之互动，就像 Google Drive 在 Windows 上映射成一个盘符一样。\
除此之外，rclone 还支持众多其它文件传输协议，还有用来操控它们的实用程序。强烈推荐ing

开启缓存后一定要用正确的方式卸载 rclone 的挂载点，直接停止进程可能会导致数据状态异常

## 端到端加密

数据在传输中以 TLS 传输层加密作为保障，但在服务端所有数据均以明文存储，一旦服务器物理遭到攻击或维护不当数据都将直接暴露在攻击者的眼中。\
在端到端加密（end-to-end encryption/E2EE）的模型中，数据会在本地加密并上传的服务器，由于解密数据的密钥只有客户端知道，因此即使服务端被攻破用户的数据依旧不会丢失

但如何加密是个问题，rclone 提供了一个内置的加密目标（`crypt`）用来将文件加密后转储至一个现有远程服务器的某个目录中。\
gocryptfs 也提供了类似的为云储存优化过的解决方案，不过在我需要的手机访问上会有些不方便就是了：<https://wiki.archlinux.org/title/Gocryptfs>

### 在 Android 上访问端到端加密保险库

这确实是烦了我蛮久的问题，因为 Android 的安全限制，FUSE 挂载点是不能在具有常规权限的软件中创建的：[gocryptfs issue #239](https://github.com/rfjakob/gocryptfs/issues/239#issuecomment-435580475)。\
而在我的使用中 Android 提供的 [Content providers](https://developer.android.com/guide/topics/providers/content-providers) 接口在 [DAVx5](https://www.davx5.com) 这个支持该功能的 WebDav 客户端中也没法写入，所以...

我放弃了实时访问这个特性，虽然这样失去了很多，但仍然可以受限的实现一些单向同步的功能。\
[Round Sync](https://github.com/newhinton/Round-Sync) 是一款 rclone 的 Android 包装器，也就顺便继承了 rclone 的 crypt 加密目标，这样就能在一个软件内搞定数据的客户端加密了。\
不过问题是 Round Sync 完全不支持 Content providers，这样的话其它程序就连只读访问也没有了

这也就是为什么刚才上文写的是“单向同步”，Round Sync 有个叫做 Task 的功能大概就是手动点一下就能把远程服务器的目录下载或覆盖到本地目录（反过来也行），配上 Trigger 功能就可以定时的下载和同步手机中的目录。\
但手机软件对文件的修改无法自动的同步到服务器。就这样吧，摆烂了...

### 原生支持端到端加密的软件

有些软件会比较大发慈悲的自己支持端到端加密的 WebDav 同步，比如笔记软件 [Joplin](https://joplinapp.org)。\
对于它们，设置好加密密钥后直接配置同步到原始的 WebDav 服务器就已经完成了端到端加密所需的所有操作，而且软件自己大概率也是最懂自己储存习惯的，理论上来说带宽优化空间会更大（猜得）

## 服务端加密

我看到这个概念实在 NextCloud 的设置里，它们允许使用服务端可以算出的密钥来静态加密数据并将其储存在其它云储存提供商中。这是因为它们对应的安全模型中远程储存是不可信的，但服务器如果被攻破数据依旧不受保障。\
同样也是在 NextCloud 中，如果开启了端到端加密，服务端加密是需要被关闭的，毕竟数据被加密两次很无聊嘛（但反过来说也确实可以增强安全等级）

## 相册备份

别整烂活。\
别把自己锁在外面，仔细想想端到端加密的必要性。\
剩下的... 我不知道

另外，怎么很多商业网盘都有个单独的 Photos 选项卡，是因为真的很想要拿用户的照片训练 AI 么（叹气）

## See also

- [Data-at-rest encryption - ArchWiki](https://wiki.archlinux.org/title/Data-at-rest_encryption)
