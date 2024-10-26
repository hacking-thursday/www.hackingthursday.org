---
layout: default
title: Blog
---
# Blog

<ul>
  {% for post in site.categories.blog %}
    <li>
      <span>{{ post.date | date: "%Y-%m-%d" }}</span>
      <a href="{{ post.url }}">{{ post.title }}</a>
    </li>
  {% endfor %}
</ul>
