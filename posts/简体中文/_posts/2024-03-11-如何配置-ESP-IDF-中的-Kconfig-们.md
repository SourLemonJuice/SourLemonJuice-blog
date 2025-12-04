---
title: "如何配置 ESP-IDF 中的 Kconfig 们"
---

## 1.Kconfig 在 esp-idf 里是干什么的

这一部分在很多官方示例代码里都有体现，它们通常都要用户在`idf.py menuconfig`里设置些 gpio 之类的东西\
这些操作就是通过`kconfig`实现的

不过问题是怎么配置，esp-idf的文档里对这些东西的描述还是挺乱的。\
什么都不知道的情况下的认识途径可能是这些，其实都看全了也能了解的差不多

- [API指南/构建系统/仅配置组件](https://docs.espressif.com/projects/esp-idf/zh_CN/v5.2.1/esp32c2/api-guides/build-system.html#config-only-component)
- [API参考/项目配置/格式检查器](https://docs.espressif.com/projects/esp-idf/zh_CN/v5.2.1/esp32c2/api-reference/kconfig.html#id4)
- [API指南/构建系统/示例项目](https://docs.espressif.com/projects/esp-idf/zh_CN/v5.2.1/esp32c2/api-guides/build-system.html#example-project-structure)
- [以及最详细的-API指南/构建系统/覆盖项目的部分设置](https://docs.espressif.com/projects/esp-idf/zh_CN/v5.2.1/esp32c2/api-guides/build-system.html#override-project-config)

所有的部分都写得很零散，用法写一边，写法写一边，注意事项写一边，或者说都不详细\
对 esp-idf 的好感度又降了不少

## 2.文件命名

这里是我最想吐槽的东西，因为文档里并没有在一个地方写全正确的文件名，所以为了凑齐这几个文件名我甚至要在不同的章节来回复制

还没完，刚才列举的四处段落中的最后一段是对于`project_include.cmake`和`Kconfig.projbuild`讲解最多的\
但问题是在[覆盖项目的部分设置/KConfig.projbuild](https://docs.espressif.com/projects/esp-idf/zh_CN/v5.2.1/esp32c2/api-guides/build-system.html#kconfig-projbuild)，章节内容里并没有其文件名，但它的标题`KConfig.projbuild`是错误的，正确的是 **c** 没有大写的`Kconfig.projbuild`

## 3.配置项不出现在 menuconfig 菜单里

应该是因为这个配置与构建系统深度集成的缘故，如果只是修改文件并保存是不会直接反映到 menuconfig 里的\
重新构建项目就可以刷新构建系统的缓存，配置项也就能显示了\
如果还不行可以运行`idf.py clean`或者什么别的能够清理缓存的方法，比如 vscode 扩展里窗口底部的垃圾桶图标(ESP-IDF: Full Clean)，再试\
ESP-IDF 嘛，出点什么问题**清缓存**加**重新选择目标芯片**大概率都是能解决的
