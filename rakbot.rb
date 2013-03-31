#coding:utf-8

#フルパスをロードマップに追加
#requireのときに参照する先を増やしている
#openのときに見るとこもこうやって変えたいな
fullpath=File.dirname(File.expand_path(__FILE__))
$:.unshift fullpath

require 'rubygems'
require 'user_stream'
require 'twitter'

#tokenの設定
require 'token.rb' #./が必要

max=0

#post.datを読み込み。行数を調べる
#↓こんな感じでかけたらいいのにな～
#open(Pathname('post.dat').expand_path,'r:utf-8') {|file|
open(fullpath+"/post.dat",'r:utf-8') {|file|
  while file.gets
    max += 1
  end
}

#ランダムに1行選んでツイートする
rand=rand(max)
open(fullpath+"/post.dat",'r:utf-8'){ |file|
  Twitter.update(file.readlines[rand])
}

