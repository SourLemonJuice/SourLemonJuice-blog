FROM ruby:3.3.0-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN gem update --system && \
gem install jekyll && \
gem install bundle && \
gem cleanup

COPY Gemfile /srv/blog/build-temp/
COPY Gemfile.lock /srv/blog/build-temp/

RUN bundle install --gemfile=/srv/blog/build-temp/Gemfile

WORKDIR /srv/blog/working-dir/

EXPOSE 4000

ENTRYPOINT []

# 运行时可以被覆盖的默认附加参数，[$ ... imageTag CMD]
# 允许全部覆盖能让使用者更好理解对吧，再要折中就只能上脚本了
# 也可以在 docker compose 里覆盖，和使用没关系就好
CMD [ "bundle", "exec", "jekyll", "server", "--host", "0.0.0.0", "--port", "4000" ]
