---
layout: post
title: "NodeJs的入门"
date: 2014-09-24 13:15:00
category: blog
description: "安装、更换源、以及框架"
---
##Windows下面安装NodeJs
由于新项目的需求，需要手机与PC进行及时通讯，类似微信网页版的功能，所以这边放弃采用RoR这个框架，
所以我提出了AvosCloud，近期也正好发布了及时通信的JS SDK，所以可以很好的满足这个项目对于PC以及手机
端之间的通信需求，但是这边后台就肯定需要NodeJs了，以前只是粗粗的运行过Hello World之类的运动，然后电脑
重装之后就需要重新配置环境了。
Windows下面安装NodeJs很简单，只需要去官网下载，然后点下一步。Piece of Cake~
##更换NodeJs的源
众所周知，由于墙的缘故，<pre>npm install -g xxx</pre>会很慢，所以等你装好了，估计天都黑了。这边可以使用淘宝提供的源
<pre>$ npm install -g cnpm --registry=https://registry.npm.taobao.org</pre>这个也很简单。或者提供alias的方法

``` bash
alias cnpm="npm --registry=https://registry.npm.taobao.org \
--cache=$HOME/.npm/.cache/cnpm \
--disturl=https://npm.taobao.org/dist \
--userconfig=$HOME/.cnpmrc"

#Or alias it in .bashrc or .zshrc
$ echo '\n#alias for cnpm\nalias cnpm="npm --registry=https://registry.npm.taobao.org \
  --cache=$HOME/.npm/.cache/cnpm \
  --disturl=https://npm.taobao.org/dist \
  --userconfig=$HOME/.cnpmrc"' >> ~/.zshrc && source ~/.zshrc
```

然后你安装别的包的时候就有一种飞起来的感觉了。<pre>cnpm install -g express</pre>不用谢我~
##接下来就是安装express时候遇到的问题
express 3.5之前可以在cmd下面运行<pre>express xxx</pre>的命令，
但是自从4开始就需要安装[express-generator](https://github.com/expressjs/generator).
运行`cnpm install -g express-generator`就可以在cmd中使用这个命令了。
新建项目也很简单，只需要`express yourapp`就可以了，默认是stylus和jade。
##运行NodeJs App
Well, I will recommend you to follow the official documentation.
[Check this out](http://expressjs.com/guide.html#intro)
好了，结束了。又是一个坑，又要深蹲。明天或者后天来写AvosCloud吧。
