# Fortune Summoners WMA Loop Fix (ARM64 / 非公式)

Steam版『フォーチュンサモナーズ』で、BGMが曲の終端に達するとループせず無音になる問題を修正するための、**GE-Proton 11-9ベースのARM64向けカスタムビルド**です。

> **非公式・実験版です。** GloriousEggroll、Valve、Wine、DroidDeckの公式配布物ではなく、各開発元の保証・サポート対象ではありません。ほかのゲームへの影響は未検証です。

## ダウンロード

[**v0.1.0（GitHub Releases）**](https://github.com/pan2marumie3/FortuneSummoners-Proton/releases/tag/v0.1.0)

Assetsで必要なのは原則として次の1ファイルです。

- **`GE-Proton11-9-WMA-Loop-aarch64.tar.gz`**：DroidDeckにインストールする本体。
- `GE-Proton11-9-WMA-Loop-aarch64.sha512sum`：任意のチェックサム検証用。通常の導入では不要です。

ライセンス文書と修正パッチは、このリポジトリの[ライセンス情報](./third_party/NOTICE.md)と[修正パッチ](./patches/wma-loop-zero-seek.patch)にまとめています。

## 何を修正したのか

Wineの `dlls/winedmo/winedmo_quartz_parser.c` の再生開始処理を変更し、**停止状態から0秒で再生し直す場合でも、デマルチプレクサへ実際のシークを要求**するようにしました。

- DroidDeck実機にて、Steam版『Fortune Summoners』の**街のBGMが2周目へ進むことを確認済み**。
- **DroidDeckのWindowsコンポーネントをすべてOFFにした状態でも起動とBGMループを確認済み**。ただし、以前インストールしたDLLが既存のWineプレフィックスに残存している可能性があるため、完全な新規環境での検証は未実施です。
- ゲームのEXEやWMA音源データは変更していません。
- WMAデコーダを追加する修正ではありません。
- 街以外の曲、別ゲーム、長時間の動作は未検証です。

## 導入方法：DroidDeckのKonsoleからインストール

### ① ファイルをAndroidへ保存

[Releases](https://github.com/pan2marumie3/FortuneSummoners-Proton/releases/tag/v0.1.0) の **Assets** から `GE-Proton11-9-WMA-Loop-aarch64.tar.gz` をダウンロードし、Android内部ストレージの **Download（ダウンロード）** フォルダに置いてください。

- **.tar.gzは展開しないでください。**
- GitHub ActionsページにあるZIPではなく、Releaseページのtar.gzを使ってください。
- 展開先の空き容量は目安として4GB以上確保してください。

### ② Konsoleを開く

1. Androidの **DroidDeckアプリのホーム画面**に戻ります。
2. **Desktop & apps** が未インストールなら導入します。
3. **Desktop** を選択し、Linuxのデスクトップ（KDE Plasma）を起動します。
4. 画面下部のタスクバーから **Konsole** を開きます。見当たらない場合は、左下のアプリランチャーで `Konsole` を検索してください。

**KonsoleはWindowsのコマンドプロンプトに相当するアプリ**です。Android用の別のターミナルをインストールする必要はありません。

### ③ コマンドを貼り付けてEnterを押す

Konsoleに次の1行をコピーして貼り付けます。

```sh
droiddeck-proton-extra /root/.local/share/Steam /root/Storage/Download/GE-Proton11-9-WMA-Loop-aarch64.tar.gz
```

- 貼り付けは `Ctrl+Shift+V`、またはKonsoleのメニューから **Paste** を選択します。
- コマンドを入力できたら、**Enter（↵）** で実行します。物理キーボードがなければDroidDeckのセッションメニュー（Backボタン）から **Keyboard** を表示し、仮想キーボードのEnterを押してください。
- 展開が終わるまでKonsoleを閉じないでください。数分かかることがあります。

成功すると次のように表示されます。

```text
droiddeck-proton-extra: installed GE-Proton11-9-WMA-Loop-aarch64
steam-compatibility: adopted GE-Proton11-9-WMA-Loop-aarch64
```

`No such file` と出た場合は、ファイル名と保存場所を確認してください。ZIPのまま、またはDownload以外の場所に保存されているケースがあります。

### ④ Steamで修正版を選択

1. KDEデスクトップの **Return to Gaming Mode** を選び、ゲーム画面へ戻ります。
2. **Steamを再起動**してください。
3. 『Fortune Summoners』の **プロパティ → 互換性**で、特定の互換ツールの使用を強制し、**`GE-Proton11-9-WMA-Loop-aarch64`** を選択します。
4. DroidDeckの**ゲーム別環境変数**に次を指定します。既に同じ変数がある場合は重複登録せず値を統合してください。

   | 変数名 | 値 |
   | --- | --- |
   | `WINEDLLOVERRIDES` | `quartz=b;qasf=b` |

5. ゲームを起動して街のBGMがループするか確認します。

**Windowsコンポーネント設定：** 今回の実機では、DirectX 9などのWindowsコンポーネントを**すべてOFF**にしても起動・ループしました。追加インストールが必須であるとは確認されていません。ただし新規Wineプレフィックスでの再現性は未確認です。

**元のGE-Proton 11-9は削除せず残してください。** ゲームが正常起動しない場合は以前の互換ツールへ戻してください。

## ソース・再現ビルド・ライセンス

- [ベース：GE-Proton 11-9](https://github.com/GloriousEggroll/proton-ge-custom/tree/GE-Proton11-9)
- [今回のWine修正パッチ](./patches/wma-loop-zero-seek.patch)
- [ARM64版のビルド設定](./.github/workflows/build-arm64.yml)
- [ビルド成功履歴](https://github.com/pan2marumie3/FortuneSummoners-Proton/actions/runs/38655835800)
- [NOTICE・上流ライセンス・Wine LGPL 2.1](./third_party/NOTICE.md)
- [リリースノート](./RELEASE_NOTES_v0.1.0.md)

本ビルドは複数のライセンスに従うソフトウェアを含みます。第三者ソフトウェアの著作権とライセンス条件は、[Protonライセンス](./third_party/LICENSE.proton)、[同梱コンポーネントの表示](./third_party/dist.LICENSE)、[Wine LGPL](./third_party/Wine-COPYING.LIB)をご確認ください。

## ソースからビルドする場合

GitHubの **Actions** → **Build experimental ARM64 Proton** → **Run workflow** でGE-Proton 11-9のソース取得、元のパッチ群適用、今回のWMA修正追加、ARM64ビルドを実行できます。
