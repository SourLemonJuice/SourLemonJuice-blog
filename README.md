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

仓库支持 Docker compose 所以可以用`docker-compose up`启动镜像，第一次启动需要`--build`参数或者`docker-compose build`来构建镜像\
镜像默认名称为 **sourlemonjuiceblog:latest**

> 提示： `docker-compose up -d` 分离式启动容器（不占用终端）

#### docker 中运行自定义命令

要在容器中执行自定义命令，参考 `/docker-SHELL.sh`

#### Gemfile.lock 在 docker 中可能造成的问题

构建镜像时会根据仓库里的 Gemfile 在容器内安装最新的gem软件包\
运行时 bundle 如果检测到仓库目录内没有 Gemfile.lock 则会创建包含最新版本列表的锁定文件\
所以，如果在运行镜像时出现 bundle 的报错，可以删除仓库下的 Gemfile.lock 再试

#### Docker支持来源与参考

- 上级镜像: ruby:3.3.0-slim-bookworm
- Dockerfile 参考于`bretfisher/jekyll-serve` [Github仓库](https://github.com/BretFisher/jekyll-serve)
