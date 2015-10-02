---
layout: post
date: 2015-09-24 21:36:31
title: Wrap long text when css is awesome!
category: blog
description: 也许你见过很长很长的文字，但是他不断句。
---

##css is awesome

场景：你肯定遇到过很长很长很长很长但是他不断句的句子或者单词，例如qwertyuiopasdfghjklzxcvbnmasdfghjkartyuiozxcdfghjkwertysdfghjertyusdfghjsdfghjwertyuixc    
简直不正常，都不想说什么。  

自行脑补那个杯子图片，然后今天在fix联客尚墙的时候，遇到了这个问题，顺便把两种解决方式总结一下。

##第一种方法

通常情况下面，white-space这个东西会是normal，所以你会看见css is awesome的效果![css is awesome](http://rlv.zcache.com/css_is_awesome_classic_white_coffee_mug-r2b2e63ffaa0a46628fb84f0844e7bf9d_x7jg9_8byvr_512.jpg)    
然后这这些特技效果会在block-level的元素中展现出来，div，p，pre所以我们这边需要一个不一样的white-space。通常会有这么几种可以供你选择：
* normal
* nowrap
* pre
* pre-line
* pre-wrap
* inherit
在理想情况下我们通常这样写

```css
pre {
  white-space: pre-line;
  width: 300px;
}
```

当然这个是不考虑各种浏览器兼容性的写法，如果你要考虑兼容性，你可以这样写：

```css
pre {
  white-space: pre;           /* CSS 2.0 */
  white-space: pre-wrap;      /* CSS 2.1 */
  white-space: pre-line;      /* CSS 3.0 */
  white-space: -pre-wrap;     /* Opera 4-6 */
  white-space: -o-pre-wrap;   /* Opera 7 */
  white-space: -moz-pre-wrap; /* Mozilla */
  white-space: -hp-pre-wrap;  /* HP Printers */
  word-wrap: break-word;      /* IE 5+ */
}
```

##第二种方法

这个是在css trick上面看到的

```scss
@mixin word-wrap() {
  overflow-wrap: break-word;
  word-wrap: break-word;
  -ms-word-break: break-all;
  word-break: break-word;
  -ms-hyphens: auto;
  -moz-hyphens: auto;
  -webkit-hyphens: auto;
  hyphens: auto;
}
.bound{
  @include word-wrap();
}
```

写成一个mixin可以很方便在需要用到的地方include，这样写比较DRY，顺便学习了如何使用@mixin和include。第二种方式是用了word-wrap，有些浏览器是overflow-wrap，they are literally alternate names for each other。另一个hyphen属性翻译是连字符，所以不解释。
