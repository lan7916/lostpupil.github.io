---
layout: post
date: 2015-07-28 23:19:58
title: 关于turbolinks的Tips
category: blog
description: 关于如何在rails中使用turbolinks
---
#turbolinks使用的注意事项

##奇怪的地方

昨天在qq群里面正好看到有人问了turbolinks的一个问题，layout切换页面的时候，js不会重新加载，只是返回了页面内容以及css样式。这个问题我在之前一个星期遇到过，原因就是turbolinks，之前的解决方案是把turbolinks关闭，这样每一次layout点击，都是一次redirect，其实这样就会cause服务器额外开销。在用户体验方面并不是很友好。

##解决方式

有两种解决方案，第一种，如上面所说，关闭turbolinks，就可以正常的使用document ready的时候执行各种各样的代码；
第二种方式，就比较tricky了，是给window bind了page:change事件，就会和document ready表现的一样。

```ruby
$(window).bind 'page:change', ->
  $(".project-btn").click (e) ->
    pid = $(this).attr("value")
    $("#projectModalBody").html  $("#project#{pid}").html()
```

示例代码如上图，然后在[turbolinks的github](https://github.com/rails/turbolinks)，有详细的事件，来介绍各种各样的行为。
