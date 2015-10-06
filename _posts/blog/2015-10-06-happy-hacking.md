---
layout: post
date: 2015-10-06 16:40:14
title: Coding during National's Day
category: blog
description: 在国庆节中遇到的问题的一些小结
---
## Day1

第一天完成了第一个系统里面的一些小问题，以及奇奇怪怪的需求，总之是一些simple tasks，边吃边喝边玩写完了。devise登陆跳转，加一个按钮，或者一些显示上面的问题，其中印象比较深刻的就是超长字符串会出现css is awesome的效果，这个在上一遍博客中就已经写过了。另外就是sweet alert的按钮，sweet alert confirm这个gem其实封装的挺好的，能够满足大部分的alert的需求，样式上面也比较可爱。    

## Day2

第二天，在搭建第二个系统，写一些cap的task，然后把不必要的部分给去掉了，第二个系统其实并不需要用rails这么庞大的东西，不过为了图方便，就直接用上了，想vc这两块其实基本上没有怎么用，不过以后的功能扩展起来会比较方便。毕竟Rails大法好，第二个系统是为了替代之前使用搜索接口而存在的，接口并不能搜索到那些小号所发的微博，所以为了保证能够获取到微博的数量，就改成了订阅接口，第二天在系统的设计上面尝试了很多次，而且我只能在服务器上面调试，这个其实挺坑爹的，部署一下会浪费很多的时间。而且我自己也不能保证我写的代码就一定按照我想象中的那样运行。    
总之第二个系统主要用了线程，sidekiq的worker，以及一个观察者。之前大老板写好的获取微博内容的方法丢在类里面，变成了一个对象，这样我可以通过observer来观察这个instance的变化情况，在Sub这个类初始化的时候加上一个observer，然后在连接断开的时候去通知SubObserver，这样我就可以重新生成一个instance不断地重复的执行自己。理想情况下，everything is under control。可是后来还是出现了问题，当时写之前就是感觉线程必定死锁，这个是后话了。

## Day3

第三天，把之前第一个系统里面的类都搬了过来，所以当我修改一个想同的类的时候，我需要改两份代码，通常可以把想同的部分单独写成一个gem，在需要使用的地方引用就可以了。当然这一天主要的问题并不是为了重构代码，而是为了解决问题，接着第二天说，写完了Sub和SubObserver之后，在connection close的时候我让observer去重新生成一个instance继续运行，看起来一点问题都没有。在吃晚饭之前能够获取到微博，也能够重新连接，但是过了一段时间之后，这个链接就不见了，一个奇怪的地方就是我observer重新生成了instance，但是执行方法的时候没有一点反应，log里面也没有任何的输出。然后一直写到12点多，并没有发现问题是什么。    
然后这一天也就过去了。


## Day4

起来之后，就开始写代码，在爆站上面逛着逛着，我发现了这样子的一段代码：

```ruby
q = Queue.new
q << "a"
q << "b"
q << "c"
t = Thread.new do
  while q.pop
    puts q
  end
end
t.join
```

这段代码看起来一点都没有问题，运行的话，就会有一个死锁。把Queue改成Array之后并不会有问题，然后我意识到我的http persistent connection其实应该也是一个类似Queus的东西，而不是简单的Array，和这个问题会有异曲同工之妙。然后给出的解决方案其实也很简单，把t.join改成t.join 1之后便不会有这样子的问题，但是始终觉得这个不是一个production的解决方案。造成这个阻塞的原因，其实是httpclient没有设置等待响应时间的参数，于是就变成了默认的时间，把响应时间设置成10分钟之后就可以了。其实这个死锁是由两个问题造成的，当时能够写出来就感觉是在撞大运。

```clojure
(ns weibo-collector.weibo
  (:require [clojure.core.async :as async]
            [clj-http.client :as client])
  (:import [java.io DataInputStream]))
(def url "http://c.api.weibo.com/datapush/status?subid=10542")

(defn reading-from-url
  [url out-chan]
  (with-open [stream (DataInputStream. (:body (client/get url {:as :stream})))]
    (loop []
      (let [next-byte (.readByte stream)]
        (when-not (= -1 next-byte)
          (async/>!! out-chan next-byte)
          (recur))))))

(defn printing-stuff-out
  [url]
  (let [out-chan (async/chan)]
    (async/thread (reading-from-url url out-chan))
    (async/go-loop [current-read-bytes []]
                   (let [[v port] (async/alts! [out-chan (async/timeout 5000)])]
                     (if (= port out-chan)
                       (recur (conj current-read-bytes v))
                       (do
                         (when (seq current-read-bytes)
                           (println (String. (byte-array (map byte current-read-bytes)) "UTF-8")))
                         (recur [])))))))
```

这个是lo姐当时教我写的代码，然后我后来仔细一看，确实有一个等待的时间在out-chan上面，`(async/alts! [out-chan (async/timeout 5000)])`，因为如果只是从out-chan上面拿东西的时候会出问题，因为read-from-url的在等的时候，这个拿的行为也在等，所以需要判断是否在等待，如果拿到了timeout，那就说明上一批读完了，把之前存起来的东西打印出来，如果不是timeout，那就说明还在读bytes，继续读下去。然后瞬间五体投地。真大神。    

于是解决了如何重启这个persistent connection的问题，剩下的就是处理这些stuff的一些简单的任务了。然后基本上Weibo这个类没有很大的修改，加上了一个scope的validate uniqueness用来判断微博是否mid和user_id都重复，这样就保证了多个账号有相同的微博但是不同的账号不会有相同的微博。然后生成的东西只需要处理一下里面的数据然后把这个给save就好，之前的hook都不需要去修改。    

总之，这一天才是everything is under control，吃完晚饭过后，把微博商业接口更新订阅的api写成了一个gem，这样我只需要调用一个方法，加上两个参数就可以更新订阅了。因为老的系统只需要负责更新，新的系统负责查询，然后重新连接就可以了。

## Day 5

今天的工作比较轻松，把新写好的gem放到旧的系统中，然后更新订阅，暂时还没有一个同步订阅的机制，不过我后来发现了如果只是单纯的增加新的去掉旧的，这样其他的账号并不能够收到这个keyword的推送了，所以这样不妥，然后我想到其实我只需要做一次query，把所有的topic做成一个数组，看看旧的在不在里面，如果在里面我就不去做操作，如果不在里面，我就去把订阅上面的这个keyword也删除掉。    

今天，遇到比较奇怪的问题就是，处理字符串的时候我没有去判断字符串是否正确，所以在收到一条微博之后，就不能获取到下一条的微博，于是做了begin rescue和判断字符串是否是以指定的结尾结束。然后重启了服务，然后到目前为止，everything is under control。    

然后昨天就特别想写一下这几天开发中遇到的灵异事件，虽然每天都写到很晚，但是收获还是挺大的。    

以上。
