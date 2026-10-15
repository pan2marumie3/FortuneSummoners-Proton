# Fortune Summoners WMA Loop Fix v0.1.0 (ARM64・非公式試験版)

**GE-Proton 11-9を基にした、DroidDeck（ARM64）向けの非公式ビルドです。** GloriousEggroll・Valve・Wine・DroidDeckの各開発元とは無関係で、公式サポート対象ではありません。

Steam版『フォーチュンサモナーズ』で、BGMが曲の終端に到達するとループせず無音になる問題への修正を試したものです。

## 変更点と検証結果

- ベース：GE-Proton 11-9（ARM64）。
- Wine内蔵DirectShowの `winedmo_quartz_parser.c` を小規模修正。停止状態からの再生時、要求位置が0秒でもデマルチプレクサへシークを指示します。
- **DroidDeck実機で街のBGMのループ再生を確認済み**です。
- **DroidDeckのWindowsコンポーネントをすべてOFFにした状態でも起動・BGMループを確認済み**です。ただし過去にインストールしたDLLがWineプレフィックスに残存する可能性があり、完全な新規環境での不要性はまだ未検証です。
- ゲーム本体やWMAファイルは変更していません。**WMAデコーダの追加ではなく、DirectShow再生位置処理の修正**です。
- 別の曲・別ゲーム・長時間連続再生は未検証です。

## ダウンロードするファイル

Assetsの **`GE-Proton11-9-WMA-Loop-aarch64.tar.gz`** がインストール用です。
`.sha512sum` は任意の破損チェック用です。その他のライセンスやパッチは[リポジトリ内](https://github.com/pan2marumie3/FortuneSummoners-Proton)で公開しています。

## DroidDeckへの導入手順（初めてKonsoleを使う方向け）

### 1. ファイルをAndroidに保存する

ReleaseのAssetsから `GE-Proton11-9-WMA-Loop-aarch64.tar.gz` をダウンロードし、Androidの内部ストレージの **Download（ダウンロード）** フォルダへ保存してください。

- **`.tar.gz` は展開しないでください。**
- GitHub Actionsの成果物ZIPではなく、**このReleaseページの`.tar.gz`** を使用します。
- DroidDeck側に展開用の空き容量が必要です。目安として4GB以上確保してください。

### 2. Linuxデスクトップを開く

1. **DroidDeckアプリのホーム画面**に戻ります。
2. **Desktop & apps** が未導入ならインストールします。
3. **Desktop** を起動してKDE Plasmaのデスクトップを開きます。
4. 画面下部のタスクバーにある **Konsole（ターミナル）** のアイコンをタップします。見つからなければ左下のアプリメニューを開き、`Konsole` と検索して起動してください。

※ここで使用するのはAndroidのターミナルアプリではなく、**DroidDeck内のLinuxデスクトップにあるKonsole** です。

### 3. Konsoleにインストールコマンドを入力する

以下を **1行そのまま** コピーしてKonsoleに貼り付けます。

```sh
droiddeck-proton-extra /root/.local/share/Steam /root/Storage/Download/GE-Proton11-9-WMA-Loop-aarch64.tar.gz
```

- 貼り付けはKonsoleの右クリックメニューの **Paste**、または `Ctrl+Shift+V` を使用できます。
- 入力できたら **Enter（↵）** で実行します。物理キーがない場合は、DroidDeckのセッションメニュー（Backボタン）から **Keyboard** を開き、仮想キーボードのEnterを押してください。
- 数分程度、展開処理が進みます。完了までKonsoleを閉じないでください。

### 4. 成功表示を確認する

次のような出力があれば導入成功です。

```text
droiddeck-proton-extra: installed GE-Proton11-9-WMA-Loop-aarch64
steam-compatibility: adopted GE-Proton11-9-WMA-Loop-aarch64
```

`No such file` と表示された場合は、ファイルの**保存先・ファイル名**を確認してください。ZIPのまま保存されていないかも確認が必要です。

### 5. Steamで選択してゲームを起動する

1. デスクトップの **Return to Gaming Mode** でゲーム画面に戻り、**Steamを再起動**します。
2. ライブラリで『Fortune Summoners』を開き、**プロパティ → 互換性**へ進みます。
3. 互換ツールを強制使用する設定を有効にし、**`GE-Proton11-9-WMA-Loop-aarch64`** を選びます。
4. DroidDeckの**ゲーム別環境変数**で、以下を指定してください。

   - 変数名：`WINEDLLOVERRIDES`
   - 値：`quartz=b;qasf=b`

   すでに同じ変数がある場合は重複登録せず、値を統合してください。これはWine内蔵DirectShowを使うために必要な設定です。
5. ゲームを起動し、街のBGMが2周目に入るか確認します。

**Windowsコンポーネントについて：** 検証環境では、DirectX 9などのWindowsコンポーネント設定を全部OFFにしたままゲームが起動し、BGMもループしました。追加コンポーネントのインストールが必須とは確認されていません（新規Wineプレフィックスでの検証は未実施）。

**既存のGE-Proton 11-9は削除しないでください。** 本ビルドは独立した互換ツールとして使用します。

## ソースコード・ライセンス

- [改変パッチ](https://github.com/pan2marumie3/FortuneSummoners-Proton/blob/main/patches/wma-loop-zero-seek.patch)
- [ビルド方法（GitHub Actions）](https://github.com/pan2marumie3/FortuneSummoners-Proton/blob/main/.github/workflows/build-arm64.yml)
- [GE-Proton 11-9の元ソース](https://github.com/GloriousEggroll/proton-ge-custom/tree/GE-Proton11-9)
- [ライセンス・著作権表記と改変ソース案内](https://github.com/pan2marumie3/FortuneSummoners-Proton/tree/main/third_party)

Protonは複数のソフトウェアで構成され、コンポーネントごとに別のライセンスが適用されます。配布時はその条件を守ってください。非公式改変版に対する各開発元の保証・サポートはありません。
