#!/bin/env bash

# 如果参数非空则使用输入作为启动命令
if [[ -n "$@" ]]
{
    Command="$@"
} else {
    # 否则使用镜像缺省参数:
    # CMD [ "bundle", "exec", "jekyll", "server", "--host", "0.0.0.0", "--port", "4000" ]
    Command=""
}

docker run --rm -it -v ./:/site --name sourlemonjuiceblog sourlemonjuiceblog:latest $Command
