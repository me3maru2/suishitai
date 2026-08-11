[cm]
[clearfix]
[start_keyconfig]

[stop_bgmovie time="100"]
[bg storage="attention.png" time="100"]

;メッセージウィンドウの設定
[position layer="message0" left=0 top=520 width=1280 height=200 page=fore visible=true]
[config_record_label skip="false"]
;文字が表示される領域を調整
[position layer=message0 page=fore margint="45" marginl="50" marginr="70" marginb="60"]


;メッセージウィンドウの表示
@layopt layer=message0 visible=true

;キャラクターの名前が表示される文字領域
[ptext name="chara_name_area" layer="message0" color="0xB5C7C8" size=28 bold=true x=80 y=530]

;上記で定義した領域がキャラクターの名前表示であることを宣言
[chara_config ptext="chara_name_area"]

;このゲームで登場するキャラクターを宣言

[nolog]
本作品は、世の中にあるたくさんの注意書きに含まれるもの、すべてが含まれるといっても過言ではありません。
[p]さらに、webという不安定な実行環境故、バグが他所に見られます。「バグったな」と思った場合は、ページをロードしなおして（webページを再読み込み）ください。
[l][r]この先については自己責任となります。製作者は一切の責任を負いません。
[p]軽量版、グロゴアフィルター版は設定から選択可能です。
[p]軽量版では動画の再生が無効化され最低限の演出のみとなります。
[l][r]グロゴアフィルター版では画像、テキストを差し替える、また該当イベントを発生させません。
[l][r]作者の意図した表現とは異なる場合があります。ご了承ください。
[glink  color="noon_btn"  storage="main.ks"  x="410"  y="300"  text="軽量版"  target="*LightVerYes"  clickse="bubble01.mp3"]
[glink  color="noon_btn"  storage="main.ks"  x="410"  y="200"  text="通常版"  target="*LightVerNo"  clickse="bubble01.mp3"]
[s]
*LightVerYes
[eval exp="sf.lightVerFlg = 1"]
@jump target="*LightVerelse"
*LightVerNo
[eval exp="sf.lightVerFlg = 0"]
@jump target="*LightVerelse"
*LightVerelse
[glink  color="noon_btn"  storage="main.ks"  x="410"  y="300"  text="フィルター版"  target="*guroflgYes"  clickse="bubble01.mp3"]
[glink  color="noon_btn"  storage="main.ks"  x="410"  y="200"  text="通常版"  target="*guroflgNo"  clickse="bubble01.mp3"]
[s]
*guroflgYes
[eval exp="sf.guroFlg = 1"]
@jump target="*guroflgelse"
*guroflgNo
[eval exp="sf.guroFlg = 0"]
@jump target="*guroflgelse"
*guroflgelse
[cm]

[endnolog]

[init_var]


[pushlog text="*-------------*"]
[pushlog text="   プロローグ   "]
[pushlog text="*-------------*"]

[if exp="sf.lightVerFlg == 1"]
[bgmovie storage="title/title_normal.mp4"]
[else]
[bg storage="event/00.png" time="2000" wait="false"]
[endif]
[play_bgm_title storage="sakana_abk_loop.mp3" title="魚たちの夢"]
#
口もきけぬ阿呆な女の話。[p]

朝日の、最初の光で君は泡になって消えてしまうんだろう。[p]
……[p]
ああ、[l][r]
だったらいっそ＿＿[p]



[fadeoutbgm time=3000]

[refresh_ui config_visible="false"]


[pushlog text="[se:アラームの音]"]
[fadeinse storage=alarm.mp3 loop=false time=2000]
[p]

[set_bg storage="search/day1/noon_room" time="2000"]

[stopse]
…………うるさい[p]
[play_bgm_title storage="natuodayaka.mp3" title="夏の穏やかな海辺で"]
また変な夢を見た気がする[p]
どうやら最近夢見が悪いのだ[p]

#???
ヤナギ～～！！あちぃ～～！！[p]

#
朝から騒がしい同居人[p]
いくら大学生の夏休みが長いと言えど家にこんなのが居たら何も休まらない[p]

#???
あれっ？いまアラーム鳴ってたよな……起きてね～の～？[p]
流石にそれは弛みすぎなんじゃないー？[p]

[pushlog text="???：こんなところまで見に来るなんて変態？嘘だよ。ありがとう"]

#
別に弛んでるつもりはない[p]
たしかに、夏休みに入ってからというもの、レポートにも手を付けず[l][r]
だからと言って遊びに行くわけでもなく[l][r]
だらだらと一日を浪費している[l]が[p]
まったく[l]俺は健康体である[p]
そんな謎の自信が自身を怠惰にしてゆき、気づけばここ数日。[p]
自炊をすると両親に言い切って一人暮らしを始めたというのにカップ麺や冷凍食品という我が家の備蓄を消費し続けている。[p]

#???
なあ～あちぃ～よ～[p]
溶ける～[p]
オレ解けて消えてなくなっちゃうよ良いの～？[p]

#ヤナギ？
(自分で何とかできるだろ…………)[p]
はいはい分かった。[p]

[set_bg storage="talk/day1_noon" time="2000"]

#???
あ。よかった～[p]
死んじゃったかと思ったわ[p]
起きてたんなら返事くらいしろよな～

[p]

#
現在はここまで。

@jump storage="title.ks"
[s]
