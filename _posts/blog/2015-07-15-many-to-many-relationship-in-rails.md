---
layout: post
date: 2015-07-13 22:17:22
title: Rails中多对对的关联
category: blog
author: banana
description: Rails中多对多关联的使用方式
---
#使用方法

##使用场景

在很多情况下我们需要用到多对多的关联，一对多关联比较好理解，举个例子，我有User和Setting这两个model，显然，一个user会有一条单独的setting的记录，这个时候可以通过`user.setting`得到这个user的setting记录。具体是通过`has_many belongs_to`来实现的。现在再考虑两个model，一个叫User，另一个叫Project，这个时候，你就会发现一个user可以参加很多个project，而一个project也可以有很多个user来参加。这个时候便是多对多的关联。

##使用原理

多对多的关系在关系型数据库中表现形式就是通过第三张表来维护的，就以Project和User这两个model为例，这张表（projects_users）只包含了两个字段。

<table>
  <thead>
    <tr>
      <td>project_id</td>
      <td>user_id</td>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>1</td>
      <td>1</td>
    </tr>
    <tr>
      <td>1</td>
      <td>2</td>
    </tr>
  </tbody>
</table>

然后通过在model中添加

{% highlight ruby %}
class User < ActiveRecord::Base
  has_and_belongs_to_many :projects
end
class Project < ActiveRecord::Base
  has_and_belongs_to_many :users
end
{% endhighlight %}

这样，便可以通过`User.first.proejcts`获取第一个用户所参与的projects，同理也可以获取到一个project中所有的users。

##一些技巧

很多时候在编辑migration的时候，很容易少写一个字母，然后就会使得表名或者一栏的名字写错，这个时候应该是执行rollback的操作。

{% highlight bash %}
#rollback a operation
rake db:rollback
#after modify your migration file
rake db:migrate
{% endhighlight %}
