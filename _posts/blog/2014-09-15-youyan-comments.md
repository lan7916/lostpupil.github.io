---
layout: post   
title: "新版博客主题的选择"    
date: 2014-09-15 20:15:00   
category: blog        
description: "关于如何在网站中添加评论功能。"
---
##如何在jekyll博客中添加评论组件
在post的单独的layout中或许需要添加的地方加入以下代码。    
{% highlight html %}
<div id="uyan_frame">
</div>
<script type="text/javascript" src="http://v2.uyan.cc/code/uyan.js?uid=xxxxxxx"></script>
{% endhighlight %}
在_config.yml文件中添加    
{% highlight yml %}
comments :
  provider : uyan
{% endhighlight %}
 
