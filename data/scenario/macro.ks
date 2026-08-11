; 探索回数のリセットマクロ
[macro name="sCntReset"]
    [iscript]
    if(f.searchCnt>0){
        f.searchCnt=0;
    }
    // SAN値に応じて回数を計算
    if (f.reiya.san > 40) {
        f.searchCnt += 49;
    } else if (f.reiya.san > 30){
        f.searchCnt += 38;
    } else if (f.reiya.san > 20){
        f.searchCnt += 27;
    } else {
        f.searchCnt += 16;
    }
    [endscript]
[endmacro]

; 霊也SANチェック
[macro name="SANc"]
    [eval exp="mp.sDCnt = mp.sDCnt || 0, mp.sDSiz = mp.sDSiz || 1"]
    [eval exp="mp.fDCnt = mp.fDCnt || 1, mp.fDSiz = mp.fDSiz || 3"]
    [if exp="f.reiya.san >= Math.floor(Math.random()*100)+1"]
        [roll cnt=mp.sDCnt siz=mp.sDSiz]
    [else]
        [roll cnt=mp.fDCnt siz=mp.fDSiz]
    [endif]
        [eval exp="f.reiya.san -= f.dice_result"]
[endmacro]

; ダイスロール
[macro name="roll"]
    [iscript]
        var x = parseInt(mp.cnt);
        var y = parseInt(mp.siz);
        var total = 0;
        for (var i = 0; i < x; i++) {
            total += Math.floor(Math.random() * y) + 1;
        }
        f.dice_result = total;
    [endscript]
[endmacro]

;部屋の探索可否のフラグ変更
[macro name="sFlgedit"]
    [iscript]
    // 引数で受け取った部屋と場所のフラグを1（探索済）にする
    var day  = f.currInfo.day;
    var room = f.currInfo.room;
    var place = mp.place;
    switch(day){
        case 1:
            f.searchFlg_day1[room][place] += 1;
            break;
        case 2:
            f.searchFlg_day2[room][place] += 1;
            break;
        case 3:
            f.searchFlg_day3[room][place] += 1;
            break;
        default:
            break;
    }
    [endscript]
[endmacro]


;変数初期化
[macro name="init_var"]
    [iscript]
    f.rootFlg=[0,0,0,0,0];  //end順
    f.currInfo={day:1,time:'noon',room:0};
    f.eventFlg=[//day1
                [1,1,1,1,1,1,0,1],          //回想1,就寝1,就寝2,空腹1,電話1,ニュース1,調理1,冷蔵庫1
                //day2
                [0,0,0,0,0,0,0,0,0,0,0,0],  //回想2,回想3,就寝3,就寝4,空腹2,空腹3,電話2,セイレーン,ニュース2,調理2,夕立,冷蔵庫2
                //day3
                [0,0,0,0,0,0,0,0]           //回想4,就寝5,就寝6,空腹4,空腹5,空腹6,ニュース3,冷蔵庫3
                ];
    f.searchFlg_day1 = [
        [0, 0, 0, 0, 0, 0, 0, 0, 0, 0], // 0.風呂（窓昼,窓夕,窓夜,浴槽昼,浴槽夕,浴槽夜,同居人昼,同居人夕,同居人夜,蛇口）
        [0, 0, 0, 0],                   // 1.ランドリー（洗面台昼,洗面台夕,洗濯かご,観葉植物）
        [0, 0, 0, 0, 0, 0],             // 2.玄関（扉昼,扉夕,扉夜,傘立て,ポスト夕,ポスト夜）
        [0],                            // 3.キッチン（冷蔵庫）
        [0],                            // 4.リビング１（ソファ）
        [0, 0, 0],                      // 5.リビング２（TV昼,TV夕,TV夜）
        [0, 0, 0, 0, 0, 0, 0, 0, 0]    // 6.寝室（ベッド昼,ベッド夕,ベッド夜,本棚昼,本棚夕,本棚夜,写真立て昼,写真立て夕,写真立て夜）
    ];
    f.searchFlg_day2 = [
        [0, 0, 0, 0],   // 0.風呂（蛇口、窓、浴槽、同居人）
        [0],            // 1.ランドリー
        [0, 0, 0],      // 2.玄関（扉、傘立て、ポスト）
        [0],            // 3.キッチン（冷蔵庫）
        [0],            // 4.リビング１
        [0],            // 5.リビング２
        [0]             // 6.寝室
    ];
    f.searchFlg_day3 = [
        [0, 0, 0, 0],   // 0.風呂（蛇口、窓、浴槽、同居人）
        [0],            // 1.ランドリー
        [0, 0, 0],      // 2.玄関（扉、傘立て、ポスト）
        [0],            // 3.キッチン（冷蔵庫）
        [0],            // 4.リビング１
        [0],            // 5.リビング２
        [0]             // 6.寝室
    ];
    // 話題フラグ（0:未取得, 1:取得済）
    f.topicFlg = [
        [0, 1, 1, 0, 0, 0, 0, 0, 0, 0], // day1
        [0],                            // day2
        [0]                             // day3
    ];
    //霊也初期値
    f.reiya={san:45,memory:0};
    //新二
    f.shinji={san:60,lv:1};
    //探索回数
    f.searchCnt=0;
    [endscript]
[endmacro]

[macro name="enable_click_effect"]
    [iscript]
    var event_layer = $(".tyrano_base");
    event_layer.off("click.effect");

    event_layer.on("click.effect", function(e) {
        // --- 1. 座標の変換処理 ---
        // ゲーム画面の拡大率を取得
        var scale = TYRANO.kag.tmp.base_scale || 1;
        
        // 画面の左上端からの距離を取得
        var offset = event_layer.offset();
        
        // ブラウザの座標から、拡大率を考慮したゲーム内座標に変換
        var x = (e.pageX - offset.left) / scale;
        var y = (e.pageY - offset.top) / scale;

        // --- 2. 中心点の調整 ---
        // 画像サイズ 60x60 の半分（30）を引いて中心をクリック位置に合わせる
        var final_x = x - 30;
        var final_y = y - 30;

        var storage = "click_effect.png";
        var name = "click_anim_" + new Date().getTime();
        
        TYRANO.kag.ftag.startTag("image", {
            layer: "0",
            page: "fore",
            storage: storage,
            x: Math.floor(final_x),
            y: Math.floor(final_y),
            name: name,
            visible: "true",
            zindex: "9999"
        });

        setTimeout(function() {
            $("." + name).fadeOut(300, function() {
                $(this).remove();
            });
        }, 200);
    });
    [endscript]
[endmacro]

[macro name="disable_click_effect"]
    [iscript]
        $(".tyrano_base").off("click.effect");
    [endscript]
[endmacro]

;bmg表示、再生
[macro name="play_bgm_title"]
    [playbgm storage="&mp.storage" loop="true"]
    [free layer="2" name="bgm_cutin" wait="false"]
    [iscript]
    if(f.currInfo.time == 'noon'){
        tf.edge ='#B5C7C8';
    }else if(f.currInfo.time == 'evening'){
        tf.edge ='#FFA17E';
    }else{
        tf.edge ='#70C2C0';
    }
    [endscript]
    [ptext name="bgm_cutin" layer="2" text="&'♪ '+mp.title" x="90" y="20" size="20" color="0x06222D" edge="&tf.edge" time="0"]
    [layopt layer="2" visible="true"]

    [anim name="bgm_cutin" left="+=20" opacity="255" time="500"]
    
    [iscript]
    setTimeout(function(){
        // スキップ中でなければアニメーションを実行
        if (TYRANO.kag.stat.is_skip != true) {
            TYRANO.kag.ftag.startTag("anim", {
                name: "bgm_cutin",
                opacity: "0",
                time: "1000"
            });
            setTimeout(function(){
                TYRANO.kag.ftag.startTag("free", { layer: "2", name: "bgm_cutin", wait: "false" });
            }, 1100);
        } else {
            // スキップ中の場合は即座に消去
            TYRANO.kag.ftag.startTag("free", { layer: "2", name: "bgm_cutin", wait: "false" });
        }
    }, 3000);
    [endscript]
[endmacro]

[macro name="refresh_ui"]
  [freeimage layer="0"]
  [clearfix name="role_button"]
  [clearfix name="vol_btn"]
  [freeimage layer="2"]
    ; オートボタン
    [button name="role_button" role="auto" graphic="&'button/'+f.currInfo.time+'_auto.png'" enterimg="&'button/'+f.currInfo.time+'_auto2.png'" clickse="bubble01.mp3" x="1010" y="480"]
    ; スキップボタン
    [button name="role_button" role="skip" graphic="&'button/'+f.currInfo.time+'_skip.png'" enterimg="&'button/'+f.currInfo.time+'_skip2.png'" clickse="bubble01.mp3" x="1095" y="480"]
    ;メッセージウィンドウ非表示ボタン
    [button name="role_button" role="window" graphic="&'button/'+f.currInfo.time+'_close.png'" enterimg="&'button/'+f.currInfo.time+'_close2.png'" clickse="bubble01.mp3" x="1180" y="480"]

    ;セーブボタン
    [button name="role_button" role="save" graphic="&'button/'+f.currInfo.time+'_save.png'" enterimg="&'button/'+f.currInfo.time+'_save2.png'" clickse="bubble01.mp3" x="10" y="20"]
    ;ロードボタン
    [button name="role_button" role="load" graphic="&'button/'+f.currInfo.time+'_load.png'" enterimg="&'button/'+f.currInfo.time+'_load2.png'" clickse="bubble01.mp3" x="10" y="105"]
    ;バックログボタン
    [button name="role_button" role="backlog" graphic="&'button/'+f.currInfo.time+'_log.png'" enterimg="&'button/'+f.currInfo.time+'_log2.png'" clickse="bubble01.mp3" x="10" y="190"]
    ;コンフィグボタン
    [button name="role_button" role="sleepgame" graphic="&'button/'+f.currInfo.time+'_config.png'" enterimg="&'button/'+f.currInfo.time+'_config2.png'" clickse="bubble01.mp3" x="10" y="275" storage="config.ks"]


    [if exp="mp.config_visible == 'true' || mp.config_visible == true"]
        [image layer="0" storage="&tf.dayfile" x=980 y=10 width=300 visible="true"]
        [ptext layer="0" name="day_text" text="&f.currInfo.day" x=1135 y=12 size=70 color="#06222d" edge="#06222d"]
    [endif]
[endmacro]


[macro name="set_bg"]

    ; パラメータの取得（時間やwaitのデフォルト値を設定）
    [eval exp="tf.bg_storage = mp.storage"]
    [eval exp="tf.bg_time = mp.time !== undefined ? mp.time : 2000"]
    [eval exp="tf.bg_wait = mp.wait !== undefined ? mp.wait : 'false'"]

    [iscript]
        var path = tf.bg_storage || "";
        // 既存の拡張子（.mp4や.png等）を取り除く
        var basePath = path.replace(/\.(mp4|webm|png|jpg|jpeg)$/i, "");

        tf.bg_movie_path = basePath + ".mp4";
        tf.bg_image_path = basePath + ".png";
    [endscript]

    ; フラグ判定と表示処理
    [if exp="sf.lightVerFlg == 0"]
        [stop_bgmovie time="&tf.bg_time" wait="false" ]
        [bgmovie storage="&tf.bg_movie_path" time="&tf.bg_time"]
    [else]
        [stop_bgmovie time="&tf.bg_time" wait="false" ]
        [bg storage="&tf.bg_image_path" time="&tf.bg_time" wait="&tf.bg_wait"]
    [endif]

[endmacro]

[macro name="show_variables"]
    [iscript]
    (function() {
        // 既存のウィンドウがあれば消去
        $("#debug_var_window").remove();

        var f_vars = TYRANO.kag.stat.f || {};
        var tf_vars = TYRANO.kag.variable.tf || {};
        var sf_vars = TYRANO.kag.variable.sf || {};

        // オブジェクトをHTML用リストに整形する関数
        function formatVars(obj, prefix) {
            var keys = Object.keys(obj);
            if (keys.length === 0) return '<div style="color:#888; margin-left:10px;">(なし)</div>';
            var html = '<ul style="list-style:none; padding-left:10px; margin:5px 0; word-break:break-all;">';
            for (var i = 0; i < keys.length; i++) {
                var k = keys[i];
                var val = JSON.stringify(obj[k]);
                html += '<li style="margin-bottom:3px;"><b style="color:#aaffaa;">' + prefix + '.' + k + '</b> : <span style="color:#fff;">' + val + '</span></li>';
            }
            html += '</ul>';
            return html;
        }

        // 表示用ウィンドウのHTML
        var content = '<div id="debug_var_window" style="position:fixed; top:5%; left:5%; width:90%; height:90%; background:rgba(0, 0, 0, 0.92); color:#fff; z-index:999999; padding:20px; box-sizing:border-box; overflow-y:auto; font-family:monospace; font-size:14px; border:2px solid #555; border-radius:8px;">';
        content += '<div style="display:flex; justify-content:space-between; align-items:center; border-bottom:1px solid #555; padding-bottom:10px; margin-bottom:15px;">';
        content += '<h2 style="margin:0; font-size:18px; color:#fff;">🐛 現在の変数一覧</h2>';
        content += '<button onclick="$(\'#debug_var_window\').remove();" style="padding:6px 16px; font-size:14px; cursor:pointer; background:#e74c3c; color:#fff; border:none; border-radius:4px; font-weight:bold;">閉じる</button>';
        content += '</div>';

        content += '<h3 style="color:#55ffff; margin:10px 0 5px; border-left:4px solid #55ffff; padding-left:8px;">■ f (ゲーム変数)</h3>' + formatVars(f_vars, 'f');
        content += '<h3 style="color:#ffbb55; margin:15px 0 5px; border-left:4px solid #ffbb55; padding-left:8px;">■ tf (一時変数)</h3>' + formatVars(tf_vars, 'tf');
        content += '<h3 style="color:#ff77ff; margin:15px 0 5px; border-left:4px solid #ff77ff; padding-left:8px;">■ sf (システム変数)</h3>' + formatVars(sf_vars, 'sf');

        content += '</div>';

        $("body").append(content);
    })();
    [endscript]
[endmacro]

[return]
