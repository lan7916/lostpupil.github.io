---
layout: post
date: 2015-08-12 16:34:45
title: 在summernote中上传图片到七妞
category: blog
description: summernote中的本地图片上传到qiniu，在文本中插入图片的链接。
---
##一些说明

Rails环境，其他同理。

##准备

首先是Gemfile，添加summernote，bootstrap，qiniu的sdk之后bundle install，在application.js和application.scss中添加相应的require，然后在页面中便可以正常使用summernote了，`= f.text_area :content,id: 'summernote',token: @uptoken, urlhead: 'http://xxxxxx.com1.z0.glb.clouddn.com/',class:"form-control"`。    

和七牛交互，需要获取到uptoken，根据七牛官方文档可以很方便的知道如何在Rails项目中使用sdk。    

```ruby
before_action :uptown, only: [:new, :edit]
def uptoken
     put_policy = Qiniu::Auth::PutPolicy.new("iamdesigner")
     @uptoken = Qiniu::Auth.generate_uptoken(put_policy)
end

```

如上，这样可以在new和edit这两个action中获得uptoken，然后填到对于的textarea的属性中，上面需要说明的是，textarea多了token，urlhead这两个属性，一个用来存放token，urlhead用来存放七牛给的自定义域名。    

##Tricky Part

```javascript
$('#summernote').summernote({
      height: 400,
      onImageUpload: function(files) {
           sendFile(files[0], $(this));
      }
});

function sendFile(file, editor) {

    var filename = false;
    try {
        filename = file['name'];
    } catch (e) {
        filename = false;
    }
    if (!filename) {
        $(".note-alarm").remove();
    }
    //以上防止在图片在编辑器内拖拽引发第二次上传导致的提示错误
    var ext = filename.substr(filename.lastIndexOf("."));
    ext = ext.toUpperCase();
    var timestamp = new Date().getTime();
    var name = timestamp + ext;
    //name是文件名，自己随意定义，aid是我自己增加的属性用于区分文件用户
    data = new FormData();
    data.append("file", file);
    data.append("key", name);
    data.append("token", $("#summernote").attr('token'));
    $.ajax({
        data: data,
        type: "POST",
        url: "http://upload.qiniu.com",
        cache: false,
        contentType: false,
        processData: false,
        success: function(data) {
            var url = $("#summernote").attr('urlhead') + data['key'];
            editor.summernote('insertImage', url);
        },
        error: function() {

        }
    });
}
```

以上是和页面的交互，summernote会有一个onImageUpload事件，这个事件只接受一个参数！只有一个!参数！重要的话，要强调一下，之前在爆站上面看到的有三个参数，sendFile(files[0], $(this));这句话把文件还有当前editor这个对象作为参数处理，对照着七牛的API可以知道需要发送什么样的数据到七牛，这边用ajax处理，在成功之后获取文件名加上之前textarea中的urlhead便是这个文件的地址，然后调用`editor.summernote('insertImage', url);`这个方法，爆站上面的方法过期了！过期了！过期了！

以上。


