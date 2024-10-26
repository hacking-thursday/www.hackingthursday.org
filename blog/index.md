---
layout: default
title: Blog
---
# Blog

{% for post in site.categories.blog %}
- {{ post.date | date: "%Y-%m-%d" }} [{{ post.title }}]({{ post.url }})
{% endfor %}
