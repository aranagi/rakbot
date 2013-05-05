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
    option = {"in_reply_to_status_id"=>mention.id}

    #特定ワード反応
    if /.*(おはよ)|(おは).*/ =~ mention.text then
      twt = ["おはよう。いい天気だな！","おはよう、#{mention.user.name}。","おはよう。よく眠れたか？"]
      rand=rand(twt.length)
      Twitter.update( reply + twt[rand] , option)
      
    elsif /.*(おやす)|(寝|ねる).*/ =~ mention.text then
      twt = ["おやすみ。いい夢が見られるといいな。","おやすみ、#{mention.user.name}。","良い夢見れるといいな。","見張っといてやるからしっかり寝とけ。"]
      rand=rand(twt.length)
      Twitter.update( reply + twt[rand] , option )

    elsif /.*(こんに*ちは|わ)|(どう|ーも).*/ =~ mention.text then
      twt = ["よう、#{mention.user.name}。","こんちわ。"]
      rand=rand(twt.length)
      Twitter.update( reply + twt[rand] , option )

    elsif /.*(ただいま)|(帰宅)|(きたく).*/ =~ mention.text then
      twt = ["おつかれさん！","おかえり。","家か。懐かしいな・・・"]
      rand=rand(twt.length)
      Twitter.update( reply + twt[rand] , option)

    elsif /.*(元気)|(げんき)？*.*/ =~ mention.text then
      twt = ["俺は元気だぞ。","調子悪いんだ・・・ごほっ"]
      rand=rand(twt.length)
      Twitter.update( reply + twt[rand] , option )
 
    elsif /.*(肉).*/ =~ mention.text then
      twt = ["ぐう、肉が食べたいぞ。","肉くれるのか！？"]
      rand=rand(twt.length)
      Twitter.update( reply + twt[rand] , option )
 
    elsif /.*(ドラゴン)|(竜)|(龍).*/ =~ mention.text then
      twt = ["赤いドラゴンを探しているんだ！知っていることがあれば教えてくれ！"]
      rand=rand(twt.length)
      Twitter.update( reply + twt[rand] , option )

    elsif /.*((なで)|(ﾅﾃﾞ)|(ナデ)){2,}.*/ =~ mention.text then
      twt = ["な、なんだよ・・・照れるだろ。","くすぐったいな・・・"]
      rand=rand(twt.length)
      Twitter.update( reply + twt[rand] , option )

    elsif /.*(翼)|(羽)|(羽根).*/ =~ mention.text then
      twt = ["俺のなかのドラゴンの力がもっと強かったら、空を飛べたんじゃないかと思っているんだ。"]
      rand=rand(twt.length)
      Twitter.update( reply + twt[rand] , option )

    elsif /.*髪.*/ =~ mention.text then
      twt = ["髪は毎朝結い直してるんだぜ。"]
      rand=rand(twt.length)
      Twitter.update( reply + twt[rand] , option )

    elsif /.*(す|好き).*/ =~ mention.text then
      twt = ["なにが好きだって？"]
      rand=rand(twt.length)
      Twitter.update( reply + twt[rand] , option )

    elsif /.*眠|(ねむ)い.*/ =~ mention.text then
      twt = ["疲れてるのか？見張っててやるから寝ておけ。","無理は良くないぞ。"]
      rand=rand(twt.length)
      Twitter.update( reply + twt[rand] , option )
    
    elsif /.*ラクトクス.*/ =~ mention.text then
      twt = ["ん？ 長いだろ、ラックって呼んでいいぞ。"]
      rand=rand(twt.length)
      Twitter.update( reply + twt[rand] , option )
    
    elsif /.*ラック.*/ =~ mention.text then
      twt = ["おう、呼んだか？","おう、#{mention.user.name}。","#{mention.user.name}ー！！"]
      rand=rand(twt.length)
      Twitter.update( reply + twt[rand] , option )
    
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
