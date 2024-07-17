---
title: "Ncurses 库中不调用 refresh() 也会显示打印内容的原因"
has_modified: true
---

在 [tldp的文档](https://tldp.org/HOWTO/NCURSES-Programming-HOWTO/helloworld.html) 中说道，refresh 会刷新 printw 的内容从缓冲区到真正的终端屏幕。\
但在我的测试中似乎只要一 printw 了，它们就会被立即显示。虽然这不是什么大问题，但不知道为什么是很恐怖的。

测试代码:

```c
#include <ncurses.h>

int main(void)
{
    initscr();
    cbreak();
    noecho();

    printw("Hello World\n");
    refresh();

    char ch;
    while (true) {
        ch = getch();
        printw("%c", ch);
        if (ch == 'q')
            break;
    }

    endwin();
    return 0;
}
```

## 原因

在搜索后，比较可能的答案是这个:\
<https://stackoverflow.com/a/53253175/25416550>

getch() 会隐式的调用 refresh()\
想要证明的话可以把带有 getch() 的循环改成绝对的循环锁死程序观察输出:

```c
/* main function */
{
    /* ... */
    printw("Hello World\n");
    // refresh();

    while (true) {}
    /* ... */
}
```

此时就可以清晰的观察在注释了 refresh() 前后 printw() 出的内容有没有被刷新了
