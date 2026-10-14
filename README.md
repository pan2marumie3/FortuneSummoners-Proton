# FortuneSummoners-Proton

『Fortune Summoners』のWMA BGMループ問題を調査するための実験的ARM64 Protonビルドです。

## ビルド方法
1. **Actions** から **Build experimental ARM64 Proton** を選択。
2. **Run workflow** で main ブランチを実行。
3. 成功したら実行ページの **Artifacts** から `GE-Proton11-9-WMA-Loop-aarch64` を取得。

修正は仮説に基づく試験版です。ビルド成功およびDroidDeckでの動作は未確認です。既存のGE-Proton11-9は上書きせず残してください。ゲームの `WINEDLLOVERRIDES=quartz=b;qasf=b` も維持してください。
