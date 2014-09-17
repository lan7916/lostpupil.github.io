---
layout: post
title: "Jekyll中添加代码高亮"
date: 2014-09-16 23:00:00
category: blog
description: "如何使用highlight js来进行代码高亮"
---
##Windows使用方法
在post的layout中添加以下代码

``` html
<link rel="stylesheet" href="http://cdnjs.cloudflare.com/ajax/libs/highlight.js/8.2/styles/default.min.css">
<script src="http://cdnjs.cloudflare.com/ajax/libs/highlight.js/8.2/highlight.min.js"></script>
<script>hljs.initHighlightingOnLoad();</script>
```

在_config.yml中添加以下代码

``` yaml
pygments: false
highlighter: rouge
# highlighter: pygments
extensions: [fenced_code_blocks]
```

这里是使用了rouge代替了pygments，因为windows上面安装这个很麻烦。本来只需要使用highlightjs就可以进行代码高亮，但是因为所有代码都需要自己手动换行以及格式化。所以这里采用了rouge+highlightjs混合方案.
在网上搜索解决方案的时候遇到如下问题：
> Update: As of August 1, commiting a _config.yml that uses rouge now causes "Page build failure" on GitHub with a misleading error message like "The file _posts/2014-08-01-blah.md contains syntax errors." Before you commit & push, you must set highlighter: pygments in _config.yml, even if you don't care to install pygments locally.

##Linux使用方法
在_config.yml中修改成以下样式

``` yaml
# pygments: false
# highlighter: rouge
highlighter: pygments
extensions: [fenced_code_blocks]
```
然后在代码中直接使用fenced code block就可以了。就可以直接使用代码高亮了。


