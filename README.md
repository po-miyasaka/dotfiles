# dotfiles

新しいmacの初期設定を自動化するためのdotfiles一式です。

## 使い方

1. `ghq get`などでリポジトリを取得します。
2. 必要であればXcode Command Line Toolsをインストールします（`xcode-select --install`）。
3. Homebrewが入っていることを確認してから`./setup.sh`を実行します。
4. 新しいシェルを開いて設定が反映されているか確認します。

## setup.sh 後の手動セットアップ

### Claude Code

```bash
# Claude Code CLI をインストール（~/.local/bin に配置される）
# https://docs.anthropic.com/en/docs/claude-code
npm install -g @anthropic-ai/claude-code
# または公式インストーラ:
# curl -fsSL https://claude.ai/install.sh | sh

# 認証
claude auth login
```

### GitHub CLI

```bash
gh auth login
```

### multi-agent-shogun

```bash
# リポジトリ取得（private fork）
ghq get git@github.com:po-miyasaka/multi-agent-shogun.git

# upstream（OSS版）を追加
cd ~/ghq/github.com/po-miyasaka/multi-agent-shogun
git remote add upstream https://github.com/yohey-w/multi-agent-shogun.git

# 初回セットアップ
./first_setup.sh

# 出陣
csst                  # 全軍起動
css                   # 将軍の本陣にアタッチ
csm                   # 家老・足軽の陣にアタッチ
csk                   # クリーンスタート（キューリセット）
csttyd                # ブラウザ監視起動（localhost:7681, 7682）
```

### Xcode

```bash
# xcodes で Xcode をインストール
xcodes install --latest
```

## エイリアス一覧

| エイリアス | 内容 |
|-----------|------|
| `csst` | shogun 出陣（全軍起動） |
| `css` | shogun セッションにアタッチ |
| `csm` | multiagent セッションにアタッチ |
| `csk` | クリーンスタート（キューリセット） |
| `csttyd` | ttyd ブラウザ監視起動 |

## 注意事項

- `setup.sh`は既存の設定ファイルがあればバックアップを作成してからシンボリックリンクに差し替えます。
- `.gitconfigbk`が存在する場合でも、既に`~/.gitconfig`があれば上書きしません。必要に応じて手動でマージしてください。
