#coding:utf-8

fullpath=File.dirname(File.expand_path(__FILE__))
$:.unshift fullpath

require 'rubygems'
require 'user_stream'
require 'twitter'

#tokenの設定
require 'token.rb'

#フォロー済みユーザの取得
followings = Twitter.friend_ids("raktoks").ids

#現在のフォロワーの取得
followers = Twitter.follower_ids("raktoks").ids

#未フォローユーザを得る
newfollows = followers - followings

#フォローする
#メッセージを送る
newfollows.each { |id|
	Twitter.follow(id)
	Twitter.update("@"+Twitter.user(id).screen_name+" フォローどうも！俺はラックだ。よろしくな、"+Twitter.user(id).name+"。")
}