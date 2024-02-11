# 在树莓派上运行excalidraw的方式_以及讨厌的emo

## 1.docker官方镜像

<https://hub.docker.com/r/excalidraw/excalidraw>

很显然官方并没有提供任何ARM版本的构建

这里有一个[PR#3937](https://github.com/excalidraw/excalidraw/pull/3937)还有个改动少的版本，看着更正常些[PR#6796](https://github.com/excalidraw/excalidraw/pull/6796)\
从2021干到了2023还是没完事，郁闷中

## 2.本地构建

这其实是我一开始的做法，因为[文档](https://docs.excalidraw.com/docs/introduction/development#self-hosting)里就是这么写的\
然后就是 ERROR 和 ERROR

这是Dockerfile

```Dockerfile
FROM node:18 AS build

WORKDIR /opt/node_app

COPY package.json yarn.lock ./
RUN yarn --ignore-optional --network-timeout 600000

ARG NODE_ENV=production

COPY . .
RUN yarn build:app:docker

FROM nginx:1.21-alpine

COPY --from=build /opt/node_app/build /usr/share/nginx/html

HEALTHCHECK CMD wget -q -O /dev/null http://localhost || exit 1
```

那，其实我从来就没有去了解过`node.js`的项目结构，所以都没怎么看提示毕竟看不懂\
总之弄清楚了就来说一下。首先，报错的尾巴是这个：

```text
$ cross-env VITE_APP_DISABLE_SENTRY=true VITE_APP_DISABLE_TRACKING=true vite build
/bin/sh: 1: cross-env: not found
error Command failed with exit code 127.
info Visit https://yarnpkg.com/en/docs/cli/run for documentation about this command.
The command '/bin/sh -c yarn build:app:docker' returned a non-zero code: 127
```

但错因在前面，第三步命令`RUN yarn`\
yarn会下载所有需要的依赖软件包，源地址应该是这里`registry.yarnpkg.com`，通过<https://itdog.cn/ping>可知，这个域名在全球除了埃及和中国大陆访问时间都在1ms左右，用了cloudflare的CDN\
唉，埃及最少还能稳定连接呢，这连能用都费劲，都是从什么时候开始的...\
我只想构建一个node.js项目，为什么...\
虽然在这之前我也经历过`docker hub`和经典的`Github`这两个重灾区，因为很重要嘛，但前者不影响`pull`后者不影响`push(ssh)`，反复安慰一下自己也就这样了，毕竟都快成老传统了再生气也没用。

但，这可能是最近几个月我最生气的一次吧，今天还在春节里，过了初一也还有零星几个人放烟花，这些烟花到底放了有什么用，又是给谁放的，想要违抗打压能不能先去真正需要的地方，还是说大家都傻到只会放放烟花，也就只想放放烟花了，这个时候真的响一次难受一次。\
我到底干吗了，更新系统连不上`Github`搜镜像连不上`Docker Hub`就连最单纯的软件依赖库都能被封掉，我有干任何政治相关的内容吗，这破防火墙都在干吗，都是谁在维护，我就是个普通的..连开发者都算不上呢...或许等我技术力强了才能让别人真正听到我说的话，能真心的夸我吧。但等着我的到底会是什么东西呢，我承认因为各种原因我几乎讨厌身边的所有人类和事物，但这说的方式就像都是因我而起的一样，我也不想逃避，但是无论是在我的那个阶段这些压力和刻板印象都太过于的重了吧，我想当个温柔一点的弄技术的人，总有无数的阻力挡着我，而那些人只有在自己也放弃后才会多说几句，还都是没用的东西。就算是这件事是人生也是这样，不过道理我还是懂得啦，但道理轻飘飘的，我心里缺的那份关心谁来补嘛。我真的太想被能感知的爱了，太想有人能夸我了...\
是谁都行，父母，同学，网上的人，只要有人有这方面的倾向我都想不顾一切的满足它，这就是我吧。\
真正的梦想..迟早会被耗干的。

确实有在说我的父母，我明白他们的爱，但我真的做不到了，所以我才会..我不知道应该叫辍学吧，那又如何仍然不能改变我，即使没有了负担，我也已经是这样的我了，更何况只是没负担还不是正数呢对吧，他们应该是不可能知道我到底怎么样了。\
哈，我知道，因为我确实想过，但是吧，我的基因里有个超棒的片段，我怕血...之前戴着一个智能手表测心率，看着数值心率都会都会框框降，从7-80一路降到5-60，这是最有依据的一次了吧哈哈，这层防火墙真的挺好用的，不然我肯定不会想现在这样写这些对吧。

emm，重点其实应该是，自由软件开源软件的开发者难道就该被这样对待吗，是，我不会我不是"开发者"但这不是更惨，最终用户都会受到这么大的牵连，这..还是很夸张的，所以我才会这么这么的生气，也算是新年第一次哭啦，顺带着就又进到emo状态了，而且是程度很高的那种~hum。

这篇"文章?"应该不会直接放到网站上去了，弄个不会被识别的文件夹扔进去吧，我还是有点想留着它们让可能的"别人"发现的。

---

对了对了，这是解决办法，在下载之前加一行换源的命令

```Dockerfile
RUN yarn config set registry https://registry.npm.taobao.org/ && \
yarn --ignore-optional --network-timeout 600000
```

对什么对，看看这个[PR#7502](https://github.com/excalidraw/excalidraw/pull/7502)，人家本来就是坏的，github action里docker镜像构建一堆红叉\
竟然一点都没往这方面想，恐怖\
好吧，还是错怪了，看来大陆的仓库没有完全封，但也很不稳定，从测试循环可以看的出来，东红一片西红一片的，hmmm\
就当是说了会心里话吧
