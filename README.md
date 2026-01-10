# dotfiles

新しいmacの初期設定を自動化するためのdotfiles一式です。

## 使い方

1. `ghq get`などでリポジトリを取得します。
2. 必要であればXcode Command Line Toolsをインストールします（`xcode-select --install`）。
3. Homebrewが入っていることを確認してから`./setup.sh`を実行します。
4. 新しいシェルを開いて設定が反映されているか確認します。

## 注意事項

- `setup.sh`は既存の設定ファイルがあればバックアップを作成してからシンボリックリンクに差し替えます。
- `.gitconfigbk`が存在する場合でも、既に`~/.gitconfig`があれば上書きしません。必要に応じて手動でマージしてください。
