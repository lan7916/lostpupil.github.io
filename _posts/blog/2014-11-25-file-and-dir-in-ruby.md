---
layout: post
title: check file or directory in ruby
category: blog
description: 用来检查文件或者文件夹是否存在的代码
date: 2014-11-25 20:24:47
---
##Ruby用来判断文件或者文件夹是否存在的代码
很多时候需要判断一个文件是否存在，然后执行对应的操作，今天在写看守男的时候，发现需要判断一个git的目录是否存在，如果不存在就不需要去读取目录。   
 
```ruby
	if Dir.exists?("/home/git/#{@project.ename}")
      git = Git.open("/home/git/#{@project.ename}", {repository:"/home/git/#{@project.ename}"})
      @logs = git.log
    else
      @logs = []
    end
```   

这段代码用来判断git仓库中对应的git目录是否存在，如果不存在则返回空。其中`Dir.exists?`就是需要使用到的函数。同样的，判断一个文件是否存在。可以用下面的代码。    

```ruby
	 if FileTest.exists?(Rails.root + "public/assets/chemicals/#{id}.png")
      tag('img',src: "/assets/chemicals/#{id}.png",class:"pure-img chemical #{klass}")
    else
      content_tag :span, class: "" do
        Chemical.find(id).cas
     end
   
   
```    

可以看到`FileTest.exists?`这个函数，其实调用起来都很简单。
