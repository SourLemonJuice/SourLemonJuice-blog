# Page variables

常用或重要的非常规**页面**变量合集\
它们可能来自某个扩展，也可能是自己写的

表格中布尔（boolean）值都可以理解为 **是否 + 用处**\
默认值中的 `(if)` 代表变量被用在了 Liquid 的 if 语句中

## Sheet

|变量|类型|默认值|用处|提供者|
|--|--|--|--|--|
|sitemap|boolean|true|添加至网站地图|jekyll-sitemap|
|noindex|boolean|false (if)|声明禁止搜索引擎添加至索引|blog|
