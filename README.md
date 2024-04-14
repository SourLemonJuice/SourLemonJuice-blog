# SourLemonJuice-blog

一个柠檬的个人网站储存库\
由`jekyll`驱动

> 前期的测试都是通过`github workflow`测试的所以有很多force的提交和hotfix什么的，抱歉啦 Github

---

## 部署与测试

参考: [docs/Deploy.md](docs/Deploy.md)

## 配置文件风格

配置文件的处理风格放在了 [docs/Config-style.md](docs/Config-style.md) 要写新配置或者 pages 的时候记得看\
至于帖子嘛，大概率是用不到的，基本都是按照类型自动处理好了的

## 页面使用的语言代码标准

参考: [docs/Language-standard.md](docs/Language-standard.md)

## 关于 搜索引擎优化/SEO 的注意事项

目前配置里包含 一些搜索引擎调查工具(google-search-console, bing webmasters...) 的验证元信息\
所以如果有人想借鉴网站的配置请**一定一定**要把相关配置移除去，虽然这并不是什么私密信息但可别忘了

插件列表:

- jekyll-sitemap
- jekyll-seo-tag

## 维护文档

所有维护或说明用的文档都放在了 `docs/` 下

## 其他的碎碎念

如果想在储存库根目录下放东西记得在 `exclude:` 里加上路径，不然网站的根目录下就也有啦

对了，如果真的有人想借鉴这些配置请不要直接克隆储存库或者下载整个源码包到本地，需要参考什么配置直接看什么就行\
一是我希望大家都能自己搜文档去理解，这样理解更深也更有用\
二是...总之我不想啦，让我任性一回嘛 `(｡･ω･｡)`

## TODO

- 添加关键字和标签搜索（能用就行）
- 整理 tags 定义，并补全部分帖子缺失的标签
