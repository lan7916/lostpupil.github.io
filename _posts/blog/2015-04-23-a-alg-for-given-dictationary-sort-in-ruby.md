---
layout: post
title: a alg of sort in ruby
category: blog
description: 一个排序算法
date: 2015-04-23 12:59:34
---
##问题
昨天在群里聊天发现的一个题目，觉得很有意思，是要用Ruby来写。
给出一个输入文件，如下：

```
8 UVWXYZNOPQRSTHIJKLMABCDEFG
ANTLER
ANY
COW
HILL
HOW
HOWEVER
WHATEVER
ZONE
5 ZYXWVUTSRQPONMLKJIHGFEDCBA
GO
ALL
ACM
TEAMS
GO
10 ZOTFISENWABCDGHJKLMPQRUVXY
THREE
ONE
NINE
FIVE
SEVEN
ZERO
TWO
FOUR
EIGHT
SIX
0
```
其中的8，5，10代表了下面的单词个数，0代表输入的结束，所以就是8下面的单词从ANTLER->ZONE是第一块需要排序的单词，8后面的一串字符是新的字典顺序，要求输出格式，如下：

```
year 1
WHATEVER
ZONE
HOW
HOWEVER
HILL
ANY
ANTLER
COW
year 2
TEAMS
GO
GO
ALL
ACM
year 3
ZERO
ONE
TWO
THREE
FOUR
FIVE
SIX
SEVEN
EIGHT
NINE
```
##思路
首先这个文件可以看到规律就是分成了一块一块，如果想要对其中每一块排序就是相当于apply一个方法，所以我这个问题就被分解成了对于一块输入排序，如下：

```
8 UVWXYZNOPQRSTHIJKLMABCDEFG
ANTLER
ANY
COW
HILL
HOW
HOWEVER
WHATEVER
ZONE
```
这里，我们的新的字典序是`dict = "UVWXYZNOPQRSTHIJKLMABCDEFG"`，然后需要排序的数组就是接下来的八个单词，这里定义为`test_array`，Ruby当中有一个sort的内置方法
会接受一个block，其中应该是0，-1，1这三个返回值。所以这里需要构造一个comparator，如下：

```ruby
def comparator (a, b, dict)
  length = a.length < b.length ? a.length : b.length
  length.times.each do |x|
    next if a[x] == b[x]
    return value =  dict.rindex(a[x]) <  dict.rindex(b[x]) ? 1 : -1
  end
  return 0
end
```
这边的思想就是对a，b两个单词逐位比较，如果每一位都相同，就返回0，如果a[x]在字典中的index比b[x]在字典中的index小，则返回1，否则返回-1。然后就有了comparator这个方法。就可以用`test_array.sort { |a,b| comparator(a,b,dict)}`来调用，最后对这个东西reverse，因为这个是倒序的。这样，就得到了排序好的数组。
接下来，就是构造等待排序的数组，以及字典数组。

```ruby
f = File.open("sortme.in", "r")
fread = f.read
word_array =  fread.split(" ")
word_array -= ["0"]
# 这边是每一个数组中单词的个数
number_array = word_array.select{ |i| i[/^\d*$/] }.map { |e| e.to_i }
# 这边是需要处理的单词
remain_array = word_array.select { |e|  e.length < 26 and e[/^\D*$/] }
# 这边是字典顺序
dict = word_array.delete_if { |e| e.length < 26 }
f.close
```
这边代码就是对文件进行了一些处理得到了我们需要得到的数据。以下是最后一段的输出：

```ruby
opt_array = []
number_array.each do |x|
  opt_array << remain_array.take(x)
  remain_array = remain_array.drop(x)
end

opt_array.each_with_index do |x,i|
  puts "year #{i+1}"
  x.sort { |a, b| comparator(a,b,dict[i]) }.reverse.map { |e| puts e  }
end
```
以上。










