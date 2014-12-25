---
layout: post
title: 前端task runner gulp 在项目中的应用
category: blog
description: eurus home以及wobbly-slideshow中gulp的使用心得。
date: 2014-12-25 13:12:14
---
##Gulp！Gulp！大口的来！
写这篇文章一边是为了分享一些东西，另一方面是上次去给荣荣的团队普及phonegap的时候，他们看到我用CLI，说一下子就回到解放前，当时我竟然无言以对。
[Gulp](http://gulpjs.com/),gulp's use of streams and code-over-configuration makes for a simpler and more intuitive build.
以上是官网上面的介绍，官网上面宣传的就是简单高效，方便学习。而且确实学习起来很方便嘛，能够简化前端很多无用的手动操作。比如说编译sass，coffee，压缩图片等等任务。这一条龙服务下来，绝对是前端标配的大宝剑啊，写代码起来直接就是飞起来。
当然以前也知道有Grunt还有Yeoman这些东西，只是体验过yeoman，grunt的配置文件和Gulp比起来确实会多一些。Gulp的核心概念就是一次做一件事情，并且做好一件事情，就是流水线的工作，简化了很多人力，这个就是科技的进步！而且这个流水线是可以配置的，非常容易扩展出你想要的功能。
##Set Up the ENV
首先你需要nodejs这个环境，不多说，去[Nodejs](http://nodejs.org/)这边看。然后就是安装一些需要的模块了，比如说sass，coffee，autoprefixer，rename之类的模块了。

```javascript
> npm install -g gulp
> npm install gulp-ruby-sass gulp-autoprefixer gulp-minify-css gulp-jshint gulp-concat gulp-uglify gulp-imagemin gulp-clean gulp-notify gulp-rename gulp-livereload gulp-cache gulp-util tiny-lr -save-dev
```
上面便是基本的需要用到的东西了，然后它上面用到的东西会写到package.json中，下次使用的时候只需要npm install就可以了。

```javascript
var gulp = require('gulp'),
coffee = require('gulp-coffee'),
gutil = require('gulp-util'),
uglify = require('gulp-uglify'),
imagemin = require('gulp-imagemin'),
cache = require('gulp-cache'),
sass = require('gulp-ruby-sass'),
autoprefixer = require('gulp-autoprefixer'),
minifycss = require('gulp-minify-css'),
rename = require('gulp-rename');
var tinylr;
gulp.task('livereload', function() {
  tinylr = require('tiny-lr')();
  tinylr.listen(4002);
});

function notifyLiveReload(event) {
  var fileName = require('path').relative(__dirname, event.path);
  tinylr.changed({
    body: {
      files: [fileName]
    }
  });
}
gulp.task('coffee', function() {
  gulp.src('public/client/coffee/*.coffee')
    .pipe(coffee({bare: true}).on('error', gutil.log))
    .pipe(gulp.dest('public/client/js'))
    .pipe(rename({suffix: '.min'}))
    .pipe(uglify())
    .pipe(gulp.dest('public/client/js'))
});

gulp.task('styles', function() {
  return gulp.src('public/client/sass/*.scss')
  .pipe(sass({ style: 'expanded',"sourcemap=none": true }))
  .pipe(autoprefixer('last 2 version', 'safari 5', 'ie 8', 'ie 9', 'opera 12.1'))
  .pipe(gulp.dest('public/client/css'))
  .pipe(rename({suffix: '.min'}))
  .pipe(minifycss())
  .pipe(gulp.dest('public/client/css'));
});

gulp.task('images', function() {
  return gulp.src('public/images/**')
    .pipe(cache(imagemin({ optimizationLevel: 3, progressive: true, interlaced: true })))
    .pipe(gulp.dest('public/client/images'));
});

gulp.task('watch', function() {
  gulp.watch('public/client/coffee/*.coffee', ['coffee']);
  gulp.watch('public/client/sass/*.scss', ['styles']);
  gulp.watch('public/images/*', ['images']);
  gulp.watch('cloud/views/*.jade', notifyLiveReload);
  gulp.watch('public/client/js/*.js', notifyLiveReload);
  gulp.watch('public/client/css/*.css', notifyLiveReload);
});

gulp.task('default', ['styles',"coffee","images",'livereload', 'watch'], function() {

});
```
上面是我用到的gulpfile，这个定义了5个函数，分别用来编译sass，编译coffee，压缩图片，以及livereload，还有便是守望者功能了。其实仔细看便很容易知道每个函数具体干了什么东西，第一个sytles函数中执行了了编译，然后加上prefix，然后输出，然后重命名，然后压缩，然后在输出。其他任务都是这样子做的。watch这个函数主要用来查看文件的变化，和去触发浏览器刷新这个动作。当然这边live reload需要在express框架中增加一个middleware，来响应这个功能，当然这个部分用ruby的guard也是可以做到的，可以看我前面的一篇文章，但是后来我想我应该少开一个命令行，所以就都写在了这个gulpfile里面了。加了中间件之后也不需要去安装chrome store的插件了，还是非常方便的。然后可以把server写在gulpfile里面，这样就可以不需要一个express这样子的后台了。目录结构呢也是非常简单的基本上在public目录下面有这些文件夹就可以用了。
##写在后面
写前端也算是有一段时间了，至于我具体是前端还是后端，我也不知道，反正就是老板给我活，我就干，听说大老板接了个iOS的项目，so~就目前来说，前端后端ssh上服务器部署，手机app这些事情我都干过一些，虽然和那些很厉害的FSD比起来，还是有很大的差距，但是我一直在朝这个方向努力，争取早日成为一个挥舞着大宝剑的屠龙战士。
Anyway，我很感谢大老板，能够收留我，对于自己的水平我也很清楚，不过能够教我这么多东西我很感谢，有耐心去带我，当然也是我自己很好学啦。所以我也在不余遗力的去Share。

Last but not least. Merry Christmas!
