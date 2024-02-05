---
layout: "page"
title: "Blog archive"
---

<!-- 注意，baseurl是config中的变量并不能自适应环境 -->

<ul>
  {% for post in site.posts %}
    <li>
      <!-- https://shopify.github.io/liquid/filters/date/ -->
      <a href="{{ site.baseurl }}{{ post.url }}">{{ post.title }} --{{ post.date | date: "%F" }}</a>
    </li>
  {% endfor %}
</ul>
