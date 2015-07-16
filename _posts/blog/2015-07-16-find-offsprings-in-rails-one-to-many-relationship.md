---
layout: post
date: 2015-07-16 22:30:03
title: Rails项目中一对多关系找到所有的孙子
category: blog
description: 在一对多关系中，找到所有的儿子，孙子，重孙。
---
##问题

一对多的关系中，可以表现为一棵树，所以给定树上面任意一个节点，我需要找到下面所有的儿子，孙子，重孙们（叶子节点），于是需要遍历一整棵树，所有首先想到的是BFS和DFS，但是为了获取所有的节点，其实使用哪一种方式都可以。   

##解决方法

很久不接触算法，所以写起来不是很顺手的，光是整理这个关系就想了一天，虽然很多时候都想的发呆去了。   
首先，场景是这样子的：我有一个部门，部门有个老大，然后老大可以创建部门，然后可以选择一个部门的领导，这个只要创建自己的儿子就好了，但是一旦儿子挂了，就要把孙子们一起给挂了。这样root节点就是老大，角色为ceo，首先我们可以找到他的儿子们，然后每个节点都可以用同一个方法去寻找儿子们。

```ruby
  def self.buddies(user)
    if user.role == ”ceo“
      where(supervisor_id: [user.id,nil])
    else
      where(supervisor_id: user.id)
    end
  end
```

这个很简单，就是需要特殊处理一下root节点就可以了。  

接下来便是遍历这个树了，这边用DFS其实更好理解，我一层一层深入下去就好了，就是一个递归调用自己的过程。

```ruby
def self.dfs(node)
    if (User.buddies node).count == 0
      return node
    else
      (User.buddies node).map { |u| User.dfs u }
    end
  end
```

递归的理解方式很简单，调用自己，以及给一个出口就可以了，这边的出口就是我如果我叶子节点的下一级没有叶子节点了，那我就返回了。
