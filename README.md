# SourLemonJuice-blog

一个柠檬的个人网站储存库\
由`jekyll`驱动

> 前期的测试都是通过`github workflow`测试的所以有很多force的提交和hotfix什么的，抱歉啦

## 运行

储存库为 **github pages** 创建，但也拥有完整的本地运行配置\
和所有jekyll站点一样，第一次用 `bundle` 安装依赖\
正常使用标准命令 `bundle exec jekyll server` 运行或者 `...eyll build` 仅生成页面

### 从 docker 构建与测试

#### 从 Docker compose 启动

仓库支持 Docker compose 可以用`docker-compose up ~ServiceName~`启动镜像，注意不要使用没有参数的`up`子命令让服务全部启动，它们不是一整套的\
第一次启动需要`--build`参数或者`docker-compose build ~ServiceName~`来构建镜像\
与博客本身相关的镜像名称为 **sourlemonjuiceblog:latest**

服务列表:

- jekyllServer\
  运行带有`--drafts`参数的 jekyll 临时预览服务器
- jekyllBuild\
  构建网站放入 */_site/*
- nginxServer\
  没什么用的 nginx server 不要运行，它连配置文件都还没有呢，现在哪里都不对

> 提示： `docker-compose up -d ~ServiceName~` 分离式启动容器（不占用终端）

#### docker 中运行自定义命令

要在容器中执行自定义命令，参考 `/docker-SHELL.sh`

#### Docker支持来源与参考

- 上级镜像: ruby:3.3.0-slim-bookworm
- Dockerfile 参考于`bretfisher/jekyll-serve` [Github仓库](https://github.com/BretFisher/jekyll-serve)
