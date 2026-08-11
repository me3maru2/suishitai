;一番最初に呼び出されるファイル

[title name="水死体"]

[stop_keyconfig]


;ティラノスクリプトが標準で用意している便利なライブラリ群
;コンフィグ、CG、回想モードを使う場合は必須
@call storage="tyrano.ks"

;ゲームで必ず必要な初期化処理はこのファイルに記述するのがオススメ

; CSS読込
[loadcss file="./data/others/user.css"]
; ティラノ側のデフォルト設定も一応合わせておく
[deffont face="MyDotFont"]
[deffont color="0xB5C7C8" size=22]
[resetfont]

[iscript]
    if (sf.endFlg == undefined) {
        sf.endFlg=[0,0,0,0,0];
    }
    if (sf.lightVerFlg == undefined) {
        sf.lightVerFlg=1;
    }
    if (sf.guroFlg == undefined) {
        sf.guroFlg=1;
    }
[endscript]
; メッセージウィンドウ
[position layer=message0 width=1240 height=200 color="0x06222D"]
;メッセージボックスは非表示
@layopt layer="message" visible=false

;最初は右下のメニューボタンを非表示にする
[hidemenubutton]

;マクロファイル読み込み
[call storage="macro.ks"]

[iscript]
    tf.is_mobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
[endscript]
[if exp="tf.is_mobile == true"]
    [bg storage="tap_start.png" time="50"]
[else]
    [bg storage="click_start.png" time="50"]
    [p]
[endif]

[iscript]
(function() {
    // --- 1. 変数確認モーダルの表示関数 ---
    TYRANO.showDebugModal = function() {
        $("#mobile_debug_box").remove();

        // ★デバッグ画面を開いた間は常駐ボタンを非表示にする
        $("#persistent_debug_btn").hide();

        var f = TYRANO.kag.stat.f || {};
        var tf = TYRANO.kag.variable.tf || {};
        var sf = TYRANO.kag.variable.sf || {};

        var text = "=== f (ゲーム変数) ===\n" + JSON.stringify(f, null, 2) + 
                   "\n\n=== tf (一時変数) ===\n" + JSON.stringify(tf, null, 2) + 
                   "\n\n=== sf (システム変数) ===\n" + JSON.stringify(sf, null, 2);

        // ★z-indexをブラウザの最大値(2147483647)にして完全最前面化
        var html = '<div id="mobile_debug_box" style="position:fixed; top:0; left:0; width:100vw; height:100vh; background:#000000; z-index:2147483647; padding:10px; box-sizing:border-box; display:flex; flex-direction:column; pointer-events:auto;">' +
            '<div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:8px;">' +
            '<span style="color:#fff; font-weight:bold; font-size:16px;">🐛 変数デバッグ</span>' +
            '<button id="close_debug_btn" style="padding:8px 20px; font-size:16px; background:#ff4444; color:#fff; border:none; border-radius:6px; font-weight:bold; cursor:pointer;">閉じる</button>' +
            '</div>' +
            '<textarea readonly style="width:100%; height:100%; background:#1e1e1e; color:#00ff66; font-size:13px; font-family:monospace; padding:10px; box-sizing:border-box; border:1px solid #444; border-radius:6px; white-space:pre; word-wrap:normal; overflow:auto; -webkit-overflow-scrolling:touch;">' + text + '</textarea>' +
            '</div>';

        // ゲーム枠の親であるbody直下に入れて重ね順トラブルを完全回避
        $("body").append(html);

        // 操作イベントの伝播防止
        $("#mobile_debug_box").on("click touchstart touchend touchmove wheel mousewheel DOMMouseScroll", function(e) {
            e.stopPropagation();
        });

        // 閉じるボタンの挙動
        $("#close_debug_btn").on("click touchstart", function(e) {
            e.preventDefault();
            e.stopPropagation();
            $("#mobile_debug_box").remove();
            // ★閉じた後に常駐ボタンを再び表示させる
            $("#persistent_debug_btn").show();
        });
    };

    // --- 2. 画面左下に常駐するボタン ---
    if ($("#persistent_debug_btn").length === 0) {
        var btnHtml = '<button id="persistent_debug_btn" style="position:fixed; left:12px; bottom:12px; z-index:999998; background:rgba(0,0,0,0.7); color:#00ff66; border:1px solid #00ff66; border-radius:20px; padding:8px 14px; font-size:12px; font-weight:bold; cursor:pointer;">🐛 変数</button>';
        $("#tyrano_base").append(btnHtml);

        $("#persistent_debug_btn").on("click touchstart", function(e) {
            e.preventDefault();
            e.stopPropagation();
            TYRANO.showDebugModal();
        });
    }
})();
[endscript]
;タイトル画面へ移動
@jump storage="title.ks"

[s]


