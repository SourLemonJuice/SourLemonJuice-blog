---
title: "GitHub Action 配置中 defaults 块与 jobs.<id>.defaults 块的覆盖问题"
---

在弄这个项目 [SourLemonJuice/i18nglish.c](https://github.com/SourLemonJuice/i18nglish.c/actions) 的时候碰到了点问题

在 github workflow 的配置文件中 [`defaults.run`](https://docs.github.com/zh/actions/using-workflows/workflow-syntax-for-github-actions#defaultsrun) 能为工作流配置 shell 和工作目录等属性，除此之外还有个类似的配置项 [`jobs.<job_id>.defaults`](https://docs.github.com/zh/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_iddefaults) 该配置只会将设置的值应用到 **当前的工作(job)** 中。

以此为基础我写了这堆东西

全局(defaults.run):

```yml
defaults:
  run:
    working-directory: source/
```

特定工作(jobs.id.defaults):

```yml
defaults:
  run:
    shell: msys2 {0}
```

但执行过程中构建报错了，此处的报错还是 `make: *** No rule to make target 'i18nglish.exe'.  Stop.` 而非找不到 makefile 也让找错的过程更不顺利

说回来，文档中对于 `jobs.<job_id>.defaults` 的描述是：

> 使用相同名称定义了多个默认设置时，GitHub 会使用最具体的默认设置。 例如，在作业中定义的默认设置将覆盖在工作流程中定义的同名默认设置。

总的来说它确实是这么做的，毕竟其他的 job 都没有用 msys2 的终端，但在这个 job 中 working-directory 却是未设置的。\
在 [job ID:26656961410](https://github.com/SourLemonJuice/i18nglish.c/actions/runs/9663812739/job/26656961410) 中的 pwd 步骤可以看到 shell 并没有进入到 source/ 下

所以，我可以合理推测一下，文档中说的 **使用最具体的默认设置** 是指最具体的 `jobs.<id>.defaults` 块，而非其下面的子属性，比如 `.defaults.run.shell` 之类的。\
如果在 job 中定义了 `jobs.<id>.defaults` 就完全使用该块中的配置，没有定义的子项也不会向上寻找全局的 `defaults`。

换句话说 `jobs.<id>.defaults` 的内容不会继承于 `defaults`

所以，这是一次调整过后的 job [ID:26659054006](https://github.com/SourLemonJuice/i18nglish.c/actions/runs/9664425697/job/26659054006)。\
其中的 pwd 步骤表明了 shell 已经处在 source/ 目录下了
