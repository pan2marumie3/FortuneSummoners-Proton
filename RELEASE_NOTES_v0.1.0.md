# v0.1.0: WMA BGM Loop Fix (ARM64, Experimental)

**Unofficial, community-built variant of GE-Proton 11-9.** This build is not affiliated with or endorsed by GloriousEggroll, Valve, Wine, or the DroidDeck team.

『Fortune Summoners』（Steam版）のBGMが1周したあと無音になる症状に対する、DroidDeck（ARM64）向け試験ビルドです。

### 変更点
- Base: [GE-Proton 11-9](https://github.com/GloriousEggroll/proton-ge-custom/tree/GE-Proton11-9), ARM64.
- Wine DirectShow parser (`dlls/winedmo/winedmo_quartz_parser.c`): when restarting playback from the stopped state, call the demuxer seek function even when the requested position is 0 seconds.
- 音声ファイルやゲームのEXEには変更を加えていません。
- この変更は**WMAデコード機能の追加ではありません**。DirectShowの再生位置制御の変更です。

### 実機で確認された内容
- DroidDeckでSteam版『Fortune Summoners』を起動。
- Wine内蔵DirectShowを使うとBGMが再生される。
- 修正版Protonで街のBGMのループ再生に成功。

### 導入・使用方法
1. `GE-Proton11-9-WMA-Loop-aarch64.tar.gz` をダウンロードしてAndroidの `Download` フォルダへ保存。
2. DroidDeckのKonsoleで次を実行：

   ```sh
   droiddeck-proton-extra /root/.local/share/Steam /root/Storage/Download/GE-Proton11-9-WMA-Loop-aarch64.tar.gz
   ```

3. Steamを再起動し、『Fortune Summoners』のプロパティ > 互換性から `GE-Proton11-9-WMA-Loop-aarch64` を選択。
4. ゲーム環境変数に `WINEDLLOVERRIDES=quartz=b;qasf=b` を設定（既存の値があれば統合）。

**元のProtonは残してください。** 他の曲・ゲームでの互換性や長時間動作は未確認です。

### ソース・ライセンス
- [この改変版のソース差分とビルド定義](https://github.com/pan2marumie3/FortuneSummoners-Proton)
- [ベースのGE-Proton 11-9ソース](https://github.com/GloriousEggroll/proton-ge-custom/tree/GE-Proton11-9)
- [Valve Wineベースの固定リビジョン](https://github.com/ValveSoftware/wine/tree/981e2f0b9007fd70a6e0ed6119cb18f4164e26f9) （GEのパッチ群適用前）
- [同梱ソフトのライセンス情報](https://github.com/pan2marumie3/FortuneSummoners-Proton/tree/main/third_party)
- [改変点のパッチ](https://github.com/pan2marumie3/FortuneSummoners-Proton/blob/main/patches/wma-loop-zero-seek.patch)
- [再現ビルドのワークフロー](https://github.com/pan2marumie3/FortuneSummoners-Proton/blob/main/.github/workflows/build-arm64.yml)

Protonは複数のソフトウェア・ライセンスで構成されています。Wineの改変部分はLGPL 2.1の条件に従います。著作権・ライセンス情報を削除しないでください。
