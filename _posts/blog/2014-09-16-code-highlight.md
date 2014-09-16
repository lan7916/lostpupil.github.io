---
layout: post   
title: "Jekyll中添加代码高亮"    
date: 2014-09-16 23:00:00   
category: blog        
description: "如何使用highlight js来进行代码高亮"
---
##使用方法
在post的layout中添加以下代码
{%highlight html%}
<link rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/highlight.js/8.2/styles/default.min.css">
<script src="http://cdnjs.cloudflare.com/ajax/libs/highlight.js/8.2/highlight.min.js"></script>
<script>hljs.initHighlightingOnLoad();</script>
{%endhighlight%}
在_config.yml中添加以下代码
{%highlight yml%}
pygments: false
highlighter: rouge
{%endhighlight%}
这里是使用了rouge代替了pygments，因为windows上面安装这个很麻烦。本来只需要使用highlightjs就可以进行代码高亮，但是因为所有代码都需要自己手动换行以及格式化。所以这里采用了rouge+highlightjs混合方案。
