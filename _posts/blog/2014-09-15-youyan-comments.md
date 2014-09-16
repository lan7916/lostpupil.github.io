---
layout: post   
title: "Jekyll中添加评论功能"    
date: 2014-09-15 20:15:00   
category: blog        
description: "关于如何在网站中添加评论功能。"
---
##如何在jekyll博客中添加评论组件
在post的单独的layout中或许需要添加的地方加入以下代码。    
[友言](http://www.uyan.cc/getcode)    
在_config.yml文件中添加  
<pre>
comments :
  provider : uyan	
</pre>    
其它无任何配置需求，用起来还是非常简单的。然后直接push代码就可以很方便的部署了。
 
