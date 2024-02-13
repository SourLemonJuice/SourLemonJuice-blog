# SourLemonJuice-blog

一个柠檬的个人网站储存库\
由`jekyll`驱动

> 前期的测试都是通过`github workflow`测试的所以有很多force的提交和hotfix什么的，抱歉啦

## 运行

储存库为`github pages`创建，但也拥有完整的本地运行配置\
和所有jekyll站点一样，第一次用`bundle`配置依赖\
正常使用标准命令`bundle exec jekyll server`运行或者`...eyll build`仅生成页面

### docker中构建

docker中构建属于实验中的方式\
测试使用的原始镜像为`bretfisher/jekyll-serve` [github](https://github.com/BretFisher/jekyll-serve)\
至于Dockerfile什么时候放进来嘛...
