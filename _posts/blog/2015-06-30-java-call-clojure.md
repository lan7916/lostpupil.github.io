---
layout: post
title: Call Clojure jar in Java
category: blog
description: 
date: 2015-06-30 10:16:19
---

##在Java中使用Clojure

在Java中使用Clojure有一些方法，在这里我演示把一个Clojure项目打包成了一个Standalone的jar包，然后在Java中import之后，就可以使用在Clojure中定义的一些方法了。

###Step One

```bash
mkdir java-call-clj && cd java-call-clj
lein new force-you
#edit project.clj in your editor
```

Clj项目只有两个文件需要被编辑，一个是core.clj，另一个是project.clj，在这边core.clj中，代码如下：

```clojure
(ns force-you.core
  (:gen-class
    :methods [#^{:static true} [foo [String] void]]))

(defn -foo
  "I don't do a whole lot."
  [x]
  (println x "Hello, World!"))

(defn -main [] 
  (println "Hey, Stupid Java!" ))
```

其中指定了main方法，这样产生的standalone的jar包依旧可以输出，Hey, Stupid Java! 这边在ns中指定了生成的class的方法，以及调用方式，可以看到这是一个静态的方法，foo是方法名称，String是参数类型，void是返回值类型。    

然后-foo这个方法很简单，就是lein new之后生成的，我在这边加上了一个-，不过我一直很好奇这个-号的意思是什么。    

在project.clj中：

```clojure
(defproject force-you "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :url "http://example.com/FIXME"
  :license {:name "Eclipse Public License"
            :url "http://www.eclipse.org/legal/epl-v10.html"}
  :dependencies [[org.clojure/clojure "1.6.0"]]
  :aot [force-you.core]
  :main force-you.core)
```

其中这边有两个key需要关心，一个是:aot，另一个是:main，其中:main的声明，使我们能够有一个默认的方法，就是输出愚蠢的Java，在console中输入`java -jar xxx.jar`就可以得到，另一个:aot的声明，就是告诉我们提前编译这些类，不然我们就需要用另一种方式去调用Clojure。另一个种方式我也不是很熟悉，所hi这边就不多做赘述。    

###Step Two

```bash
lein uberjar
# 复制生成的standalone jar到HelloClj.java同一个目录下
```

这边HelloClj.java中的代码如下：

```java
import force_you.*;

class HelloClj {
    public static void main(String[] args) {
        System.out.println("Hello from Java!");
        core.foo ("Banana");
    }
}
```

这边需要注意的是force_you.*这里是下划线而不是减号，我很久不写Java，所以对于命名习惯不是很熟悉了。但是在Clojure中，大部分都是用减号作为连接符。

###Step Three

```bash
javac -cp '.:force-you-0.1.0-SNAPSHOT-standalone.jar' HelloClj.java
java -cp '.:force-you-0.1.0-SNAPSHOT-standalone.jar' HelloClj
```

Boom, Shakalaka.这边需要注意的是有个-cp的参数，-cp <目录和 zip/jar 文件的类搜索路径>。

##总结

大概很长时间不写Clojure和Java了，到现在其实一直都是很喜欢Clojure的，Ruby还不是最真爱的。然后这边文章的源代码[coding](https://coding.net/u/sevenbanana/p/java-call-clj/git)可以到这边看到源代码。


