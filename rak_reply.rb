#coding:utf-8

#フルパスをロードパスに追加
fullpath=File.dirname(File.expand_path(__FILE__))
$:.unshift fullpath

require 'rubygems'
require 'user_stream'
require 'twitter'
require 'csv'

#tokenの設定
require 'token.rb'

UserStream.configure do |config|
  config.consumer_key = Consumer_key
  config.consumer_secret = Consumer_secret
  config.oauth_token = Oauth_token
  config.oauth_token_secret = Oauth_token_secret
end

client = Twitter::REST::Client.new do |config|
  config.consumer_key = Consumer_key
  config.consumer_secret = Consumer_secret
  config.access_token = Oauth_token
  config.access_token_secret = Oauth_token_secret
end

max=0
lastid=0 #最後に返信したtweetのid

#lastid.dat読み込み
open(fullpath+"/lastid.dat",'r:utf-8') {|file|
  lastid=file.readlines[0].to_i
}

#randomreply.datの行数を数える
open(fullpath+"/randomreply.dat",'r:utf-8') {|file|
  while file.gets
    max += 1
  end
}

#reply.csv読み込み
specialReplyList = CSV.open("reply.csv", "r")

#reply読み込み
client.mentions_timeline.reverse_each { |mention| #古いものから処理するためにreverse_each
  id=mention.id.to_i

  if id <= lastid #既に返信済みのtweetのときスキップ 
    next
  else #返信済みでないtweetのとき

    #リプライ内容が決定したらtrue
    skip = false
  
    #lastidを更新
    lastid = id
    reply = "@" + mention.user.screen_name + " "
    option = {"in_reply_to_status_id"=>mention.id}

    #特定ワード反応
    specialReplyList.each do |row|
      
      #1つめの要素は正規表現をあらわす
      regexp = Regexp.new(row.first)
      row = row.drop(1)

      #条件に一致すれば特定ワード返信
      if regexp =~ mention.text then
        skip = true
        rand = rand(row.length)
        Twitter.update( reply + row[rand] , option)
        break
      end
    
    end
    
    #ランダム返信
    if skip != true then
      rand=rand(max) #0からmax未満までの乱数を生成する

      begin
        open(fullpath+"/randomreply.dat",'r:utf-8'){ |file|
          twt=file.readlines[rand]
          client.update( reply + twt , option )
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
