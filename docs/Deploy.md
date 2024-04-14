# 部署与测试

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
- Dockerfile 参考于`bretfisher/jekyll-serve` [Github 仓库](https://github.com/BretFisher/jekyll-serve)
