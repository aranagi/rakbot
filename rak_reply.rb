#coding:utf-8

#フルパスをロードパスに追加
fullpath=File.dirname(File.expand_path(__FILE__))
$:.unshift fullpath

require 'rubygems'
require 'user_stream'
require 'twitter'

#tokenの設定
require 'token.rb'

max=0
lastid=0 #最後に返信したtweetのid

#lastid.dat読み込み
open(fullpath+"/lastid.dat",'r:utf-8') {|file|
  lastid=file.readlines[0].to_i
}

#reply.datの行数を数える
open(fullpath+"/reply.dat",'r:utf-8') {|file|
  while file.gets
    max += 1
  end
}

#reply読み込み
Twitter.mentions.reverse_each { |mention| #古いものから処理するためにreverse_each
  id=mention.id.to_i
  if id <= lastid #既に返信済みのtweetのときスキップ 
    next
  else #返信済みでないtweetのとき
  
    #lastidを更新
    lastid = id
    reply = "@" + mention.user.screen_name + " "
    option={"in_reply_to_status_id"=>mention.id}

    #特定ワード反応
    if /.*おはよ.*/ =~ mention.text then
      twt = "おはよう。いい天気だな！"
      Twitter.update( reply + twt , option)
      
    elsif /.*おやす.*/ =~ mention.text then
      twt = "おやすみ。しっかり寝ておけ。"
      Twitter.update( reply + twt , option )
    
    elsif /.*ラクトクス.*/ =~ mention.text then
      twt = "ん？ 長いだろ、ラックって呼んでいいぞ。"
      Twitter.update( reply + twt , option )

    elsif /.*ラック.*/ =~ mention.text then
      twt = "おう、呼んだか？"
      Twitter.update( reply + twt , option )


    else #ランダム返信
      rand=rand(max) #0からmax未満までの乱数を生成する

      begin
        open(fullpath+"/reply.dat",'r:utf-8'){ |file|
          twt=file.readlines[rand]
          Twitter.update( reply + twt , option )
        }
      #ツイート重複した場合
      rescue Twitter::Error::Forbidden => error
        puts error.to_s
        rand=rand(max) #乱数生成しなおし
        retry
      end

    end

    #lastid.dat更新
    open(fullpath+"/lastid.dat",'w:utf-8') {|file|
      file.write(lastid)
    }
  end
}
