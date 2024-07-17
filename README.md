# SourLemonJuice-blog

一个柠檬的个人网站储存库。\
由 `Jekyll` 与经修改后的 `minima` 主题驱动

分叉出的 minima 在这里: [minima-for-SourLemonJuice](https://github.com/SourLemonJuice/minima-for-SourLemonJuice)

> 前期的测试都是通过`github workflow`测试的所以有很多force的提交和hotfix什么的，抱歉啦

## 维护文档

所有维护或说明用的文档都放在 [docs/](docs/) 下了（很可能过时，但改动应该不会太大）\
例如：

- [部署与测试](docs/Deploy.md)
- [页面使用的语言代码标准](docs/Language-standard.md)
- [yaml 配置的风格](docs/Config-style.md)

## 关于 搜索引擎优化/SEO 的注意事项

目前配置里包含 一些搜索引擎调查工具(google-search-console, bing webmasters...) 的验证元信息\
所以如果有人想借鉴网站的配置请**一定一定**要把相关配置移除去，虽然这并不是什么私密信息但可别忘了

插件列表:

- jekyll-sitemap
- jekyll-seo-tag

## 其他的碎碎念

如果想在储存库根目录下放东西记得在 `exclude:` 里加上路径，不然网站的根目录下就也有啦

对了，如果真的有人想借鉴这些配置请不要直接克隆储存库或者下载整个源码包到本地，需要参考什么配置直接看什么就行\
一是我希望大家都能自己搜文档去理解，这样理解更深也更有用\
二是...总之我不想啦，让我任性一回嘛 `(｡･ω･｡)`

## TODO

- 想到什么就加什么
