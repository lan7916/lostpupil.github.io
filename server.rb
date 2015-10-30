require "cuba"
require "cuba/safe"

require 'yaml'
# database
require 'leancloud-ruby-client'
# dev
require 'awesome_print'
Cuba.use Rack::Session::Cookie, :secret => "__a_very_long_string__"
Cuba.plugin Cuba::Safe


config = YAML.load_file('config/leancloud.yml')["leancloud"]


Cuba.define do
  AV.init :application_id => config["appid"],
    :api_key        => config["appkey"],
    :quiet           => false

  on get do
    on root do
      render 'index'
    end
  end
end
