---
layout: post
date: 2015-09-04 10:02:56
title: Swift的一些小tips
category: blog
description: 
---
##UI
修改UITabBar的颜色以及选中之后的颜色，下面面代码是为了让TabBar变成一个半透明的背景，然后选择了之后是白色的东西。

{%highlight swift%}
UITabBar.appearance().barTintColor = UIColor.clearColor()
UITabBar.appearance().backgroundImage = UIImage(named: "tablayer")
UITabBar.appearance().shadowImage = UIImage()
UITabBar.appearance().tintColor = UIColor.whiteColor()
{%endhighlight%}

让一个UITextField下边框有底部的黑线,然后可以有各种各样的线。

{%highlight swift%}
func UITextFieldBottomStyle(textfield: UITextField){
    let border = CALayer()
    let width = CGFloat(1.0)
    border.borderColor = UIColor.lightGrayColor().CGColor
    border.frame = CGRect(x: 0, y: textfield.frame.size.height - width, width:  textfield.frame.width, height: textfield.frame.size.height)
    border.borderWidth = width
    textfield.layer.addSublayer(border)
    textfield.layer.masksToBounds = true
}
{%endhighlight%}

然后上面如果把这个方法加载在viewDidLoad之后，会让这个线变短，具体的解决方法就是把这些代码放在viewDidLayoutSubviews里面，如果是手写代码写出来的则不会有问题，用Storyboard并且加上了constrain就会出现这种情况。

##Bluethoth
在导入了CoreBluetooth库之后，用一个controller继承CBCentralManagerDelegate，

{%highlight swift%}
var bluetoothManager: CBCentralManager?

func centralManagerDidUpdateState(central: CBCentralManager!){
    println(bluetoothManager?.state.hashValue)
}
{%endhighlight%}

当前VC其实可以获取到bluetoothManager的状态，self.bluetoothManager?.state.hashValue这个可以获取到当前的值，蓝牙开着就是5关着就是4，
