---
layout: post
title: "CAS码的验证算法"
date: 2014-09-22 21:12:00
category: blog
description: "使用coffeescript对cas码进行验证"
---
##CAS码是什么
CAS编号（CAS Registry Number或称CAS Number, CAS Rn, CAS #），又称CAS登录号或CAS登记号码，是某种物质（化合物、高分子材料、生物序列（Biological sequences）、混合物或合金）的唯一的数字识别号码。    
一个CAS编号以连字符“-”分为三部分，第一部分有2到6位数字，第二部分有2位数字，第三部分有1位数字作为校验码。CAS编号以升序排列且没有任何内在含义。校验码的计算方法如下：CAS顺序号（第一、二部分数字）的最后一位乘以1，最后第二位乘以2，依此类推，然后再把所有的乘积相加，再把和除以10，其余数就是第三部分的校验码。举例来说，H2O 的CAS编号前两部分是7732-18，则其校验码= ( 8×1 + 1×2 + 2×3 + 3×4 + 7×5 + 7×6 ) mod 10 = 105 mod 10 = 5（mod为求余运算符），所以水的CAS为7732-18-5。
##使用代码进行验证
这里使用Coffeescript，代码如下：

``` coffeescript
cas_valid = (a, b, result) ->
	str = a + b
	sum = 0
	len = str.length
	for i in [1..len]
		sum = sum + a.charAt(len-i) * i
	return sum % 10  == +result
```
等价与map reduce版本

```coffeescript
cas_valid = (a, b, result) ->
	start = (a + b).split("").reverse()
	return((start.map (x,i) -> x * (i + 1)).reduce (x,y) -> x + y) % 10 is +result
```

上面代码中还没有添加代码保证a，b，result为数字。这边都是对字符串进行处理，所以最后匹配结果的时候result前面多了一个‘+’号，用来对这个字符串进行类型转换，调用方法如下。

``` coffeescript
cas_valid('10','00','4') # true or false
```

Prodcution Version

```coffeescript
#cas validation
  cas_rule = (a,b,result) ->
    start = (a + b).split("").reverse()
    return((start.map (x,i) -> x * (i + 1)).reduce (x,y) -> x + y) % 10 is +result

  cas_vaild = (target) ->
    $(target).on "keydown keyup blur", (e) ->
      val = $(this).val().split('-')
      bool_val = cas_rule(val[0],val[1],val[2])
      if bool_val
        $(this).css('border-color', '#4ebcec')       
      else
        $(this).css('border-color', 'red')
        
  ##add elements if you want to add fields to vaild
  target = "#chemical_cas" 
  valid_arrs = target.split " "
  valid_arrs.map (t) ->    
    cas_vaild(t)
    return
```