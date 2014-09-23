---
layout: post
title: "面试的时候遇到的一个算法"
date: 2014-09-23 16:05:00
category: blog
description: "今天面试过程中的一个算法"
---
##今天面试的一个算法
题目是：一个数组，例如（1，2，3，0，6），把数组分成两部分，使得两边的和相同，返回其下标。
（1，2，3）和（6），应该返回0的下标，算法如下：

``` clojure
(def vect [1 2 1 2 0 1 2 3])
(def rvec (reverse vect))
(def nt (count vect))

(for [x (range 1 (+ 1 nt))
      :let [a (reduce + (take x vect))
            b (reduce + (butlast (take (- nt x) rvec)))]
      :when (= a b)]
  x)
```
