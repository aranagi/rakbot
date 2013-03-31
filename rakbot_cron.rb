#coding:utf-8

require 'rubygems'
require 'user_stream'
require 'twitter'
require 'pp'

consumer_key = 'QWA8YJdY1XS0Ivf9w0DIMg'
consumer_secret = 'CIzv2ArM0689T0JttwBsAyxOdHNcI2WAoMEoi1Cndg'
oauth_token = '970967389-FzADJgbaIua6ZsnPIzfnFymnLobiiJdp3qo945US'
oauth_token_secret = 'NlFGzdl7MylaXQ9ijrUkwtD8r8AqEAwf6uNHDxRMo'

UserStream.configure do |config|
  config.consumer_key = consumer_key
  config.consumer_secret = consumer_secret
  config.oauth_token = oauth_token
  config.oauth_token_secret = oauth_token_secret
end

Twitter.configure do |config|
  config.consumer_key = consumer_key
  config.consumer_secret = consumer_secret
  config.oauth_token = oauth_token
  config.oauth_token_secret = oauth_token_secret
end

client = UserStream.client
max=0

# post.datを読み込み。行数を調べる
#open("post.dat") {|file|
open("/home/arng/www/rakbot/post.dat",'r:utf-8') {|file|
  while file.gets
    max += 1
  end
}

#ランダムに1行選んでツイートする
rand=rand(max)
open("/home/arng/www/rakbot/post.dat",'r:utf-8') {|file|
  Twitter.update(file.readlines[rand])
}

