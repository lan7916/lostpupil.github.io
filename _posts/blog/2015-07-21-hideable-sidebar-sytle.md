---
layout: post
date: 2015-07-21 14:35:59
title: 固定在左侧的侧边栏
category: blog
description: 固定在左侧的侧边栏以及动画效果。
---
#可显示隐藏的侧边栏

##HTML

```html
<div id="wrapper">
  <div id="sidebar-wrapper">
  </div>
  <div id="page-content-wrapper">
    <a href="#menu-toggle" id="menu-toggle">Show/Hide</a>
  </div>
</div>
```

##CSS

```css
#wrapper {
    padding-left: 0;
    -webkit-transition: all 0.5s ease;
    -moz-transition: all 0.5s ease;
    -o-transition: all 0.5s ease;
    transition: all 0.5s ease;
}

#wrapper.toggled {
    padding-left: 250px;
}
@media(min-width:768px) {
  #wrapper {
        padding-left: 250px;
    }

    #wrapper.toggled {
        padding-left: 0;
    }
}
```

##JS

```javascript
// 可以在document ready中执行
// 或者在page最底部加载
$("#menu-toggle").click(function(e) {
  e.preventDefault();
  $("#wrapper").toggleClass("toggled");
});
```

##用法摘要

一个div的wrapper分为了左右两个部分，sidebar-wrapper和page-content-wrapper，用css区分这两块，关键就是多了一个`.toggle`的class，这是用jquery添加上去的。    
在wrapper没有`toggle`这个class的时候，所展示的样式是有两种情况的，在media query中写的屏幕宽最小为768像素的时候，wrapper的padding-left为250px，在小于768像素的时候padding就会收缩为0。同理，在添加了`toggle`这个class之后，padding变成了250px。

##来源
[startbootstrap](http://startbootstrap.com/template-overviews/simple-sidebar/)
