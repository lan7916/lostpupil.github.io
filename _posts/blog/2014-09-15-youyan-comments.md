---
layout: post
title: "Jekyll中添加评论功能"
date: 2014-09-15 20:15:00
category: blog
description: "关于如何在网站中添加评论功能。"
---
##如何在jekyll博客中添加评论组件
这里使用的是[友言](http://www.uyan.cc/getcode)，使用方法很简单，只需要在post的单独的layout中或许需要添加的地方加入以下代码。

``` html
{% include comment.html %}
<!-- UY BEGIN -->
<div id="uyan_frame"></div>
<script type="text/javascript" src="http://v2.uyan.cc/code/uyan.js?uid=1967006"></script>
<!-- UY END -->

```

在_config.yml文件中添加

``` yaml
comments :
  provider : uyan
```

其它无任何配置需求，用起来还是非常简单的。然后直接push代码就可以很方便的部署了。

