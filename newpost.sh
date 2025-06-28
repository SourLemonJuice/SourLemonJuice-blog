#!/usr/bin/env bash

if [[ "$1" == "--help" ]]; then
    cat <<EOF
Usage: newpost.sh [--help] [<post_id>]

If post_id not specified, use "post" as it by default.
EOF
    exit
fi

if [[ ! -f "./_config.yml" ]]; then
    echo "This script needs to be run from the repository root"
    exit
fi

if [[ -z "$1" ]]; then
    post_id="post"
else
    post_id="$1"
fi

base_path="posts2/$(date +%Y)/_posts"
mkdir --parents "${base_path}"

post_path="${base_path}/$(date +%Y-%m-%d)-${post_id}.md"
read -p "Press enter to create: ${post_path}"

if [[ -f "${post_path}" ]]; then
    read -p "File already exists, override?(input ignore, ctrl-c to cancel)"
fi

cat <<EOF > "${post_path}"
---
lang: "zh-Hans"
title: "${post_id}"
date: $(date "+%Y-%m-%d %R %z")
---
EOF
