#!/bin/env bash

# 如果参数非空则使用输入作为启动命令
if [[ -n "$@" ]]; then
    Command="$@"
else
    # 否则使用镜像缺省参数:
    # ENTRYPOINT [ "bundle", "exec", "jekyll" ]
    # CMD [ "server", "--host", "0.0.0.0", "--port", "4000" ]
    Command=""
fi

docker run --rm --interactive --tty \
--volume "./:/site" \
--publish "4000:4000" \
--name sourlemonjuiceblog \
sourlemonjuiceblog:latest \
${Command}
