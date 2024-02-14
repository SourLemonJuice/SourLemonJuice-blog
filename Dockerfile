FROM ruby:3.3.0-slim-bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

RUN gem update --system && \
gem install jekyll && \
gem install bundle && \
gem cleanup

COPY Gemfile /

RUN bundle install --gemfile=/Gemfile

WORKDIR /site

EXPOSE 4000

# ENTRYPOINT [ "exec" ]

# 运行时可以被覆盖的默认附加参数，[$ ... imageTag CMD]
# 允许全部覆盖能让使用者更好理解对吧，再要折中就只能上脚本了
CMD [ "bundle", "exec", "jekyll", "server", "--host", "0.0.0.0", "--port", "4000" ]
