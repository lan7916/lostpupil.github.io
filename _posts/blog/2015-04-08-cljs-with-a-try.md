---
layout: post
title: cljs小玩
category: blog
description: 尝试使用cljs写js
date: 2015-04-08 17:00:12
---
##准备
首先你需要安装Java8，cljs本身并不需要Java8，只需要用Java7，但是因为这个standalone需要用到其他一些东西，而其他一些东西需要用到Java8，如果使用lein构建工程的话，你需要安装leiningen，一般来说人们都是和Clojure一起用的，但是JavaScript实在是写烦了，于是就换个新鲜玩意。其实这个github wiki上面是有详细介绍的。上班闲着也没事，就照着做了一遍。感觉还是挺有趣的。    
下载安装好之后，把这个cljs.jar放在新建的目录下面。
##一些代码咯
这一段代码用来把目录下面scr中的jquerytest.cljs输出到main.js，生成的代码并不能够看懂，只是知道用了google closure。一定程度上，对源代码的保护还是非常好的。当然这个命令是会watch的，并不是只build一次，所以这个在开发的时候非常有用的，当然，还有很多其他东西没有加上去。

```clojure
(require 'cljs.closure)

(cljs.closure/watch "src"
  {:main 'hello-world.jquerytest
   :output-to "out/main.js"})
; java -cp cljs.jar:src clojure.main watch.clj
```    
```html
<html>
    <head>
      <script type="text/javascript" src="javascripts/jquery-1.11.2.min.js"></script>
      <script type="text/javascript" src="out/main.js"></script>
    </head>
    <body>  
     <div class="meat">Replace me, jquery.</div>
     <li class="numbers">1</li>
     <li class="numbers">2</li>
     <li class="numbers">3</li>
     <li class="numbers">4</li>
     <li class="numbers">5</li>
    </body>
</html>
```    

```clojure
(ns hello-world.jquerytest)
(enable-console-print!)
(def jquery (js* "$"))

(defn x []
  (-> 
    (jquery ".meat")
      (.html "yes")))

(jquery
  (fn []
    (x)
    (-> (jquery "li.numbers")
      (.html "pink")
      (.append "banana"))))
```
以上。    
当然我遇到了一个问题，就是我不知道如何去获取dom元素的值，只能够替换掉他的值，这个让我费解了很久，也没有找到一个好办法。
源代码在[coding](https://coding.net/u/sevenbanana/p/cljs-example/git)
