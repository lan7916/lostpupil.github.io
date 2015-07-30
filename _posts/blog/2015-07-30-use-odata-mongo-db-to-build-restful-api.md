---
layout: post
date: 2015-07-30 22:07:21
title: use odata mongo db to build restful api
category: blog
description: 如题
---
#MongoDB together with Odata

##安装MongoDB

只针对OSX 优胜美地，其他的我不造。安装MongoDB很简单：

```bash
brew updata
brew install mongodb
```

好了，装完了，然后就是开起来运行了。代码页很简单，一点都不难：

```bash
# open mongod
mongod
# start mongo client
mongo
```

如果你发现，他报错了，找不到/data/db这个文件夹的话，那很简单：

```bash
sudo mkdir -p /data/db
sudo chmod 0755 /data/db
Give yourself permission to the folder.
sudo chown `id -u` /data/db
```

以上。    

##安装node-odata

```bash
npm install node-odata
```

以上。

#把他们使用起来

##准备index.js文件

```javascript
var odata = require('node-odata');

var server = odata('mongodb://localhost/qq-app');

server.resource('users', { username: String, password: Number });

server.listen(3000);
```

##url访问

```javascript
localhost:3000/users => User.all
localhost:3000/users?oid = User.find id
localhost:3000/users/?filter=username eq banana
```

然后就会返回相应的结果。

POC。
