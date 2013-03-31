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
lastid=0

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
  if id <= lastid #既に返信済みのTweetのときスキップ 
    next
  else
    #lastidを更新
    lastid=id
    #返信する
    reply = "@" + mention.user.screen_name + " "
    open(fullpath+"/reply.dat",'r:utf-8'){ |file|

    rand=rand(max) #0からmax未満までの乱数を生成する

      begin
        puts rand
        twt=file.readlines[rand]
        puts twt
        Twitter.update( reply + twt )
      #ツイート重複した場合
      rescue Twitter::Error::Forbidden => error
        puts error.to_s
        if rand<max-1
          rand+=1
        else 
          rand=0
        end
        retry
      end

    }
    #lastid.dat更新
    open(fullpath+"/lastid.dat",'w:utf-8') {|file|
      file.write(lastid)
    }
  end
}
