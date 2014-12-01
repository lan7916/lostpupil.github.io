---
layout: post
title: 瘦肉云开发环境配置
category: blog
description: 瘦肉的自动化配置
date: 2014-12-01 21:52:31
---
##使用LeanCloud后端开发环境的配置
avoscloud命令行其实很方便，和Rails一样，不需要你重启服务器。能够自动的check你的文件是否有变化，然后重启服务器，这点是非常方便的，但是作为一个优秀的（懒惰的）程序员，能省就省，能不用手写的东西就不手写。能少按一个键就少一个。自动化都是这样出来的，所以这个feature是非常棒的，nodejs本身也有这样子热部署的东西，叫nodemon。本身瘦肉云开发其实并没有很多需求，你下载个项目框架就可以开始了。
因为瘦肉云是基于express的，所以模板上面我选择了jade，反正ejs各种长，而且作为一个Rails程序员，slim才是自己的主场。他们说jade长的像haml，但是我想说，卧槽丧心病狂的haml每个标签前面有一个`%`，jade其实更像slim。jade的模板部分看的还是挺开心的，它用了`block`这个东西，然后写法上面还是很好玩的。文档也有中文版的，所以学起来成本很小。不会的继续去查文档就可以了。
##使用LeanCloud前端开发环境的配置
前端其实用yeoman和grunt和bower，会很方便。但是配置起来也不简单，我就放弃了，而且本身项目大小并没有说要用到很多。这边想在前端用requirejs，过段时间会加上去。前端mvc框架就决定使用backbone了，因为AV就是基于Backbone的。所以没有什么选择困难的。然后上一次打算用coffee写前端的，但是avos一直没有说不用js就直接coffee，后来我找了一个折中的办法，`coffee -o js/ -cw coffee/`这个命令就是用来动态的把coffee/目录下的文件compile到js/目录下面。这样就解决了不能用coffee的问题，当然其他的node包我暂时没有找到，so~
然后，虽然服务器会刷新，但是你还是需要手工去执行刷新这个操作的，对于你的调试还有样式的修改简直丧心病狂了。然后前段时间，找了一个gem叫guard，这东西很好用，配合浏览器端的livereload，可以自动刷新。然后我就试了一下，居然真的可以用。JJ Fly。于是，就有了下面这些命令。

```bash
guard init
guard
```

上面的命令分别干了初始化Guardfile然后执行的事情。

```ruby
guard 'livereload' do
  watch(%r{cloud/.+\.(js|jade)})
  watch(%r{public/.+\.(css|js|html|coffee)})
end
```

然后这个开发环境就配置的差不多妥妥的了。再也不用手动刷新重启服务器了。哦，除了云函数。感觉还是很棒的。至于guard怎么用，可以参看Github。
