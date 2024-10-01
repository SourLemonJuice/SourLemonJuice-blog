FROM ruby:3.3-slim-bookworm

# wow, if don't have them:
# ERROR:  Error installing jekyll:
#   ERROR: Failed to build gem native extension.
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN gem update --system && \
gem install jekyll && \
gem install bundle && \
gem cleanup

COPY Gemfile /buildroot/temp/
COPY Gemfile.lock /buildroot/temp/

RUN bundle install --gemfile=/buildroot/temp/Gemfile

WORKDIR /buildroot/working/

# 通知 jekyll 进入开发环境，某些主题会根据这一变量关闭遥测之类的功能以适合开发
# 等下，看文档的时候没注意，生产模式是要部署时才要弄的哇www
# github action 里 jekyll 模板已经写过这个了，别动咯
# ENV JEKYLL_ENV=production

EXPOSE 4000

# 运行时可以被覆盖的默认附加参数，[$ ... imageTag CMD]
# 允许全部覆盖能让使用者更好理解对吧，再要折中就只能上脚本了
# 也可以在 docker compose 里覆盖，和使用没关系就好
CMD [ "bundle", "exec", "jekyll", "server", "--host", "0.0.0.0", "--port", "4000" ]
