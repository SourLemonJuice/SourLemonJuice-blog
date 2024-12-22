---
title: "C# 中的语言集成查询（LINQ）的基本使用"
date: 2024-12-23 02:20 +0800
---

C# 中的 [语言集成查询 (LINQ)](https://learn.microsoft.com/zh-cn/dotnet/csharp/linq/) 将一系列**查询过程**转换为了对于查询本身的**描述**，并在需要的时候由运行时以高效的方式进行计算。\
文档中说类似于各种数据库的查询语言，不过我连数据库都没用过就是了（

希望以后不会回来抓虫ww，记得一定要去看微软的文档哦（放在最后了）

## 例子

这是 Microsoft Learn 官网的例子（有修改）：

```csharp
// 定义数据源
int[] scores = { 97, 92, 81, 60 };

// 定义查询表达式
IEnumerable<int> scoreQuery =
    from score in scores
    where score > 80
    select score;

// 执行查询
foreach (int i in scoreQuery)
    Console.Write(i + " ");
```

其中 `scoreQuery` 用来描述这一条查询，这并不执行查询操作。\
`from score in scores` 与 `foreach` 的表现形式类似，都是遍历一个可迭代的数据（`scores` ），并用一个变量（`score`）表示迭代时当前正在处理的元素

随后 `where` 定义了一个表达式 `score > 80`，符合这个表达式的元素将通过筛选进入到最后的 `select` 语句中被返回出去

## 排序

查询中的关键字 `orderby` 可以将查询结果排序，比如：

```csharp
IEnumerable<int> query =
    from score in scores
    where score > 60
    orderby score descending /* 降序 */
    select score
// ...
```

这样一来查询的结果将变为倒叙排序。而且不仅如此，`orderby` 语句还可以指定多个排序对象。比如一个对象内有两个 int 元素，首先依照元素 .a 排序，如果 .a 的大小相同则使用 .b 的大小辅助排序（文档里的例子好像是 first or last name）：

```csharp
IEnumerable<int> query =
    from obj in objs
    orderby obj.a ascending, obj.b ascending /* 升序 */
    select obj
```

一些文档：

- [查询表达式基础 #orderby 子句](https://learn.microsoft.com/zh-cn/dotnet/csharp/linq/get-started/query-expression-basics#orderby-clause)
- [orderby 子句（C# 参考）](https://learn.microsoft.com/zh-cn/dotnet/csharp/language-reference/keywords/orderby-clause)

## 有用的文档

- [C# 中的 LINQ 查询简介](https://learn.microsoft.com/zh-cn/dotnet/csharp/linq/get-started/introduction-to-linq-queries)
- [Language Integrated Query (LINQ) and IEnumerable [Pt 15]](https://youtu.be/4ro5UCqU0P4)
