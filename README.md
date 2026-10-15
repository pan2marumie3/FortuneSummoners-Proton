# Fortune Summoners WMA Loop Fix (ARM64, Unofficial)

Steam版『フォーチュンサモナーズ』のBGMが1周すると無音になる問題を検証するため、**GE-Proton 11-9（ARM64）** にWineのDirectShowパーサーの修正を加えた非公式ビルドです。

> **重要**：本プロジェクトはGloriousEggroll、Valve、Wine、DroidDeckの公式配布物ではなく、各開発元の保証・サポート対象外です。他のゲームでの動作や互換性は未検証です。

## ダウンロード

[**Releases: v0.1.0（ARM64試験版）**](https://github.com/pan2marumie3/FortuneSummoners-Proton/releases/tag/v0.1.0)

- `GE-Proton11-9-WMA-Loop-aarch64.tar.gz`：DroidDeck向けのカスタムProton本体
- `GE-Proton11-9-WMA-Loop-aarch64.sha512sum`：検証用SHA-512
- ソース差分、上流ライセンス表記、著作権情報もReleaseに収録

## 変更内容と確認状況

`dlls/winedmo/winedmo_quartz_parser.c` の `dmo_parser_init_stream()` において、停止状態から再生を開始するときに要求位置が**0秒**でも実際のシーク処理を呼び出すよう変更しています。従来は0秒の場合、実際のシークが省略され、曲が終端（EOF）に残ることがありました。

- DroidDeckでSteam版『Fortune Summoners』の**街BGMのループ再生成功**（ユーザー実機報告）。
- **WMAデコード処理そのものを追加・変更したものではありません。**
- WMA音源ファイルやゲームのEXEには変更を加えていません。
- 他の曲、他のゲーム、長時間運用は未検証。既存のProtonを残して導入してください。

## DroidDeckへの導入

1. Releaseから `GE-Proton11-9-WMA-Loop-aarch64.tar.gz` を入手し、AndroidのDownloadフォルダに保存（.tar.gzは展開不要）。
2. DroidDeckのデスクトップで **Konsole** を開き、以下を実行。

   ```sh
   droiddeck-proton-extra /root/.local/share/Steam /root/Storage/Download/GE-Proton11-9-WMA-Loop-aarch64.tar.gz
   ```

3. Steamを再起動し、ゲームのプロパティ > 互換性で `GE-Proton11-9-WMA-Loop-aarch64` を選択。
4. ゲーム別の環境変数で `WINEDLLOVERRIDES=quartz=b;qasf=b` を設定（既存の変数がある場合は統合）。

このDLL設定がない場合、Wine内蔵DirectShowが選ばれず、BGMが無音になることがあります。空き容量は余裕をもって確保してください。

## ソース・再現ビルド・ライセンス

- **オリジナル**：[GE-Proton 11-9](https://github.com/GloriousEggroll/proton-ge-custom/tree/GE-Proton11-9) （ソース・依存コンポーネント・パッチ一式）
- **変更箇所**：[WMAループ修正パッチ](./patches/wma-loop-zero-seek.patch)
- **ビルド定義**：[ARM64 GitHub Actions](./.github/workflows/build-arm64.yml)
- **成功したビルド**：[Actions run #2](https://github.com/pan2marumie3/FortuneSummoners-Proton/actions/runs/38655835800)
- **ライセンス・著作権・改変ソースの参照先**：[third_party/NOTICE.md](./third_party/NOTICE.md)、[LICENSE.proton](./third_party/LICENSE.proton)、[dist.LICENSE](./third_party/dist.LICENSE)、[Wine LGPL 2.1](./third_party/Wine-COPYING.LIB)
- [リリースノート](./RELEASE_NOTES_v0.1.0.md)

Protonは複数のライセンスからなるソフトウェア集合体です。配布条件は[GE-Protonのライセンス](https://github.com/GloriousEggroll/proton-ge-custom/blob/GE-Proton11-9/LICENSE.proton)と各コンポーネントのライセンスに従います。

## Build from source

Actions > **Build experimental ARM64 Proton** > **Run workflow**。GE-Proton11-9の固定タグに公式パッチ群を適用し、このリポジトリの修正パッチを追加してARM64向けにビルドします。

GitHub Actionsは公開済みのテストビルドを再構築できますが、構成を変更した新しいビルドは改めてテストしてください。
