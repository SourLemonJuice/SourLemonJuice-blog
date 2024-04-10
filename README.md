# SourLemonJuice-blog

一个柠檬的个人网站储存库\
由`jekyll`驱动

> 前期的测试都是通过`github workflow`测试的所以有很多force的提交和hotfix什么的，抱歉啦 Github

---

## 1.部署方式

### 1.old Github-Pages

使用它的一般都是只有不完整的 jekyll 配置文件以及实际帖子内容组成的仓库\
但这也并不意味着有完整配置文件的仓库就不能用这种方式部署了

对于这个储存库，把 pages 的来源设置为该模式并且搜索目录为根目录，那等一会，部署应该会成功的

### 1.本地运行

虽然储存库最初为 **github pages** 构建，但也拥有完整的本地运行配置\
和所有jekyll站点一样，第一次用 `bundle` 安装依赖\
正常使用标准命令 `bundle exec jekyll server` 运行或者 `...eyll build` 仅生成页面

### 1.通过 Github-Action 构建与部署

支持使用 github 工作流处理部署的任务，这也是 Github-Pages 提供的最自由的部署方式\
当前部署操作的工作流是: **/.github/workflows/jekyll.yml**\
虽然这么说，但这个仓库并没有用到什么 jekyll 的新功能，不过很好玩嘛

## 2.从 docker 构建或测试

### 2.从 Docker-Compose 启动

仓库支持 Docker compose 可以用`docker compose up ~ServiceName~`启动镜像，注意不要使用没有参数的`up`子命令让服务全部启动，它们不是一整套的\
第一次启动需要`--build`参数或者`docker compose build ~ServiceName~`来构建镜像\
与博客本身相关的镜像名称为 **sourlemonjuiceblog:latest**

服务列表:

- jekyllServer\
  运行带有`--drafts`参数的 jekyll 临时预览服务器
- jekyllBuild\
  构建网站放入 */_site/*
- nginxServer\
  没什么用的 nginx server 不要运行，它连配置文件都还没有呢，现在哪里都不对

> 提示： `docker compose up -d ~ServiceName~` 分离式启动容器（不占用终端）

### 2.Docker 中运行自定义命令

要在容器中执行自定义命令，或者了解默认命令解释，可以参考: **/docker-SHELL.sh**

### 2.Docker 支持来源与参考

- 上级镜像: ruby:3.3.0-slim
- Dockerfile 参考于`bretfisher/jekyll-serve` [Github仓库](https://github.com/BretFisher/jekyll-serve)

---

## 3.需要注意的事

### 3.配置风格

配置文件的处理风格放在了 Config-Style.md 要写新配置或者 pages 的时候记得看\
至于帖子嘛，大概率是用不到的，基本都是按照类型自动处理好了的

### 3.语言代码

#### 3.标准列表

- 第一位`语言`码: ISO_639-3
- `书写方式`修饰码: ISO_15924

#### 3.标记方式

- 所有页面的缺省使用: `eng`
- 帖子被配置为根据存放的位置自动处理，例如:\
  posts/简体中文/_posts/post.md -> `zho-Hans`
- 所有 pages 需要手动编写语言标签

### 3.网站流量分析

目前配置里包含 google-search-console 的验证元信息\
所以如果有人想借鉴网站的配置请**一定一定**要把相关配置移除去，虽然这并不是什么私密信息但可别忘了

### 3.搜索引擎优化/SEO

插件列表:

- jekyll-sitemap
- jekyll-seo-tag

### 3.其他的碎碎念

如果想在储存库根目录下放东西记得在 `exclude:` 里加上路径，不然网站的根目录下就也有啦

对了，如果真的有人想借鉴这些配置请不要直接克隆储存库或者下载整个源码包到本地，需要参考什么配置直接看什么就行\
一是我希望大家都能自己搜文档去理解，这样理解更深也更有用\
二是...总之我不想啦，让我任性一回嘛 `(｡･ω･｡)`
