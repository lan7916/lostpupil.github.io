---
layout: post
title: 大乐透用到的技术以及一些算法
category: blog
description: 关于这个转盘用到的一些算法
date: 2015-01-02 12:59:02
---
##关于开发
首先由于这个网站的特殊性，不能用leancloud，还要我自己部署服务器，简直不能够更加繁琐。所以我还是选择了Rails，一方面网站后台用脚手架搭建会很方便，另一方面，会比较熟悉这个开发流程以及很多gem可以使用。
Devise用来负责用户登录，Thin用来做Server，slim做模板引擎，还有guard用来做live reload。这一套东西会节省很多时间。
##关于转盘前端
```html
  #main
    .msg
    .demo
      #disk
      #start
        =image_tag("start.png",id: 'startbtn',"data-target"=>"#lotteryModal", "data-toggle"=> "modal")
```
这个是转盘的骨架，然后是样式部分。

```css
.demo{
  width:420px;
  height:420px;
  position:relative;
}
#disk{width:440px; height:440px; background:url(back.png) no-repeat}
#start{
  width:163px;
  height:320px;
  position:absolute;
  top:63px;
  left:135px;
  img{
    cursor:pointer
  }
}
```
这个便是前端部分了，当然客户要求说要用modal来调触发这个转圈的事件，这边便坑了一下，因为这边我就需要自己去为这个事件触发后的动作来写一些代码，

```coffeescript
$ ->
  sw = true
  $("#loresult").html ""
  ang = "<%= angle %>"
  price = "<%= price %>"
  $('#lotteryModal').modal('hide')
  $("#lotteryModal").on "hidden.bs.modal", (e) ->
    if sw
      $("#startbtn").rotate
        duration: 9000
        angle: 90
        animateTo: 5400 + +ang
        easing: $.easing.easeOutSine
        callback: ->
          alert "恭喜您中得了#{price}"
          return
      sw = false
```
这边是成功之后的操作，如果不成功只是很简单的append一句话上去。这边因为modal只要一消失就会去触发hidden这个事件，所以我会重复的旋转转盘，不能保证只有一次，所以我在这边加入了一个sw的switch，在操作之后把sw设置为false，这样就只能操作一次，简直机智啊。
然后rotate这个东西是一个jquery插件，它能够跨浏览器的旋转图片，所以我就用它了，可以设置角度以及什么旋转时间，旋转效果。
##关于转盘的后台
Actually,this is a tricky part.

```ruby
  def big_lottery
    @user = User.find_by(username: params[:user][:username])
    @wheel = Wheel.find(params[:wid].to_i) rescue nil
    ## cond check
    cond = lottery_check @user
    if @wheel
      wid = @wheel.id
    else
      wid = Wheel.first.id
    end
    respond_to do |format|
      case cond
      when 'good_to_go'
        result = angle_and_price(@user,wid)
        ap result
        format.js {
          render action: 'big_lottery_success',
          locals:{angle: result[:angle], price: result[:price]}
        }
      when 'good_but_no_count'
        format.js {
          render action: 'big_lottery_fail',
          locals: {count: true}
        }
      else 'breakingbad'
        format.js {
          render action: 'big_lottery_fail',
          locals: {count: false}
        }
      end
    end
  end

  private

  def angle_and_price(user,wid)
    if user.user_ratio.ratios == Array
      ap "array"
      ap ur = user.user_ratio.ratios*","
    else
      ap "string"
      ap ur = user.user_ratio.ratios.split(",")
    end
    length = ur.length
    if length >= 10
      ap price = ur.take(10).map {|x| x.to_f * 100}
    else
      sum = ur.map{|x| x.to_f}.reduce(:+)
      lst = "#{1 - sum}"
      mid = (9-length).times.collect{|x| "0.0"}
      ap price =(ur.concat mid << lst).map {|x| x.to_f * 100}
    end
    #range 100
    ap seed = rand(100)
    result = []
    (1..10).each do |x|
      lol =  seed >  price.take(x).inject(:+)
      result << lol
    end

    price_level = (result.find_index false)+1
    angle = Price.find_by(level: price_level).angle
    price_content= Price.find_by(level: price_level).name

    user.count = user.count-1
    user.save
    PriceHistory.create(price_content: price_content,user_id: user.id,
                        wheel_id:wid,price_id:Price.find_by(level: price_level).id)
    return {angle: angle, price: price_content}
  end

  def lottery_check(user)
    if @user
      if @user.count > 0
        cond = 'good_to_go'
      else
        cond = 'good_but_no_count'
      end
    else
      cond = 'breakingbad'
    end
    cond
  end
```
上面`lottery_check`用来判断用户是否符合抽奖的条件，然后`angle_and_price`用来返回根君用户给定的概率返回角度以及获得的奖品。
所以抽奖都是骗人的么，这边每个可以抽奖的用户都有自己的概率记录，这个是一个string然后用逗号隔开，就变成了一个数组，然后因为有十个奖品，所以需要去凑满十个奖品，如果用户输入不满十个，那其他都是零，最后一个就是十等奖，他的值就是1减去前面的那些值得和，然后产生一个随机数，然后判断是否在每个数组的区间里面，因为奖品都是单独的概率，所以需要生成一个新的数组，来存储最大值，这个时候只需要去判断产生的随机数是否比数组里面的最大值大就可以了，接着找到第一个值为true的下标，这个时候就可以去数据库查询奖品等级和奖品的内容了。传回给controller中的入口，以此返回给前端。
##然后差不多了
就分享下，随便看。没了。
