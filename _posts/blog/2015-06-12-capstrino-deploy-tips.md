---
layout: post
title: capstrino部署中遇到的一些问题
category: blog
description: 在部署rails代码到生产环境中的时候遇到的一些问题
date: 2015-06-12 10:34:19
---
##各个环境一些基本的设置以及解释
`config/enviroments/development.rb`中关于assets的两个设置：   
1. `config.assets.debug = false`关闭这个可以提高assets在development中加载的速度    
2. `config.assets.digest = false`关闭这个可以去掉assets中的后缀
`config/enviroments/production.rb`中关于assets的两个设置：   
1. `config.assets.compile = true`如果assets没有compile，会在客户端访问的时候去执行precompile的操作
2. `config.assets.digest = true`打开这个可以添加assets中的后缀，与nginx中资源过期有关
##关于部署的一些配置
`Capfile`中的一些设置

```
# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

# Include tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#   https://github.com/capistrano/passenger
#
require 'capistrano3/unicorn'
require 'capistrano/rvm'
# require 'capistrano/rbenv'
# require 'capistrano/chruby'
require 'capistrano/bundler'
# require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
# require 'capistrano/thin'
# require 'capistrano/passenger'

# Load custom tasks from `lib/capistrano/tasks' if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }

```

`deploy.rb`中

```
# config valid only for current version of Capistrano
lock '3.3.5'
app_name = "linkers-on-wall-rails"
set :application, "#{app_name}"
set :repo_url, 'git@git.coding.net:sevenbanana/linkers-on-wall-rails.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deploy/app/#{app_name}"
set :deploy_via, :remote_cache

set :rvm_type, :system
set :default_env, { rvm_bin_path: '/usr/local/rvm/bin/ '}
# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
set :pty, false
# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/assets')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5
set :rails_env, 'production'
set :migration_role, 'app'            # Defaults to 'db'
set :conditionally_migrate, false           # Defaults to false. If true, it's skip migration if files in db/migrate not modified
namespace :deploy do

  after :restart, :clear_cache do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  desc "Start the Unicorn process when it isn't already running."
  task :start do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      invoke 'unicorn:start'
    end
  end

  desc "Initiate a rolling restart by telling Unicorn to start the new application code and kill the old process when done."
  task :restart do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      invoke 'unicorn:restart'
    end
  end

  desc "Stop the application by killing the Unicorn process"
  task :stop do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      invoke 'unicorn:stop'
    end
  end

  desc "Flat UI Pro installation"
  task :flat_ui_pro do
    on roles(:app), in: :groups, limit: 3, wait: 10 do

    end
  end

  desc "China Region Install"
  task :china_region do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "region:install"
        end
      end
    end
  end

  desc "Assets Precompile On Server"
  task :asp do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
       within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, "assets:precompile"
        end
      end
    end
  end

  after 'deploy', "deploy:migrate"
  # after 'deploy:migrate', "deploy:china_region"
  after 'deploy:migrate','deploy:asp'



  desc "Redeploy the whole application"
  task :redeploy do
    on roles(:app), in: :groups, limit: 3, wait: 10 do
      invoke 'unicorn:stop'
    end
  end

  after 'deploy:redeploy',"deploy"
  after 'deploy:redeploy',"start"
end
```

`cap production deploy`会执行代码部署以及migration的操作，因为在deploy有一个after的hook操作，会在deploy完成之后去执行migrate，`cap prodcution deploy:redeploy`会执行unicorn的关闭，部署源代码，以及unicorn的启动。
其中写了`task asp & task china_region`，这两个任务分别执行assets precompile，以及china城市数据的导入。然后这个是可以执行的，然后unicorn/production.rb就不贴， 在github上面可以找到[example](https://github.com/tablexi/capistrano3-unicorn)。    
以上。

##关于Rails开发的一些吐槽
Well，RoR开发确实快，可以很快的搭建开发环境，以及有着很棒的开发流程，实现产品原型的能力是一级棒，但是在部署的时候就是各种操蛋，有些问题确实非常莫名其妙，以至于我database.yml中production的数据库依旧是hardcode的，然后LC_APP_ID以及LC_APP_KEY还没有测试，因为我还没有加上sidekiq的部署，两天了终于把网站部署好了，感觉这周就在做了这件事情，以及配置VPS。
然后，准备用Docker部署，结果Docker跪了，要去升级Liunx内核，然后我就没有去管了。
