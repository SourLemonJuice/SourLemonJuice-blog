---
title: "如何在视频翻译工作中使用 Whisper CLI"
tags: ["OpenAI", "Machine-Learning", "CLI/TUI", "Utilities"]
---

因为想去烤烤肉（翻译视频）所以又去看了看 whisper 的命令行界面的用法

Whisper 的使用方式其实挺简单的，就像这样 `whisper --model small --output_format srt video.mp4`

但对于字幕来说，每段字幕的长度都是需要严格控制的，whisper 也有这个功能:

```text
--max_words_per_line MAX_WORDS_PER_LINE
                        (requires --word_timestamps True, no effect with --max_line_width) the maximum number of words in a segment (default: None)
```

所以将命令改为:

```shell
whisper --model small --output_format srt --word_timestamps True --max_words_per_line 6 video.mp4
```

就可以限制每段文本的单词数不超过 6 个了。\
但这项设置在 shell 的输出里并不会及时生效，它只针对输出文件进行处理 [Github Issue](https://github.com/openai/whisper/discussions/1808)

记得多看看 `whisper --help` 和 搜索引擎 哦
