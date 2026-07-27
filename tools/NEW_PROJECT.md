# New Project Bootstrap

このファイルは、GitHub Template Repository
`kenkiti/ai-development-template` から新規プロジェクトを作成し、
ローカルへcloneして初期設定するための実行手順です。

Claude CodeなどのAIエージェントへ、このファイルを読ませて実行してください。

---

## 使い方

次の項目を指定してから、AIエージェントへ渡します。

```yaml
project_name: <repository-name>
description: <repository description>
visibility: private
local_parent: <absolute parent directory>
```

例:

```yaml
project_name: market-signal-system
description: MARKETSPEED RSSを利用したリアルタイム市場監視システム
visibility: private
local_parent: C:\Users\<username>\Github
```

---

## 固定設定

```yaml
template_repository: kenkiti/ai-development-template
owner: kenkiti
default_visibility: private
include_all_branches: false
```

---

## 実行方針

以下を自律的に実行すること。

確認のためだけに作業を停止しない。

ただし、次の場合は実行前に停止してユーザーへ確認すること。

- 同名のGitHubリポジトリがすでに存在する
- 同名のローカルディレクトリがすでに存在する
- 指定された保存先が不明、またはアクセスできない
- Publicリポジトリとして作成する
- 既存ファイルの削除・上書きが必要
- 認証情報、秘密鍵、トークンなどをファイルへ保存する必要がある
- テンプレートの範囲を超える設計判断が必要

次の場合は確認せずに進めてよい。

- GitHub CLIとGitの状態確認
- テンプレートからのPrivateリポジトリ作成
- 新規リポジトリのclone
- プレースホルダーの検索
- 新規プロジェクト用ドキュメントの初期化
- 可逆的なローカル編集
- build/testコマンドが未確定であることの明記
- 初期設定差分の表示

---

## 前提確認

最初に以下を実行すること。

```powershell
gh --version
git --version
gh auth status
```

いずれかが失敗した場合は、成功したように扱わず停止する。

確認できていない事項は必ず「未確認」と報告する。

---

## 重複確認

リポジトリ作成前に、次を確認すること。

```powershell
gh repo view "kenkiti/<project_name>"
```

リポジトリが存在した場合は停止する。

ローカル保存先も確認すること。

```powershell
Test-Path "<local_parent>\<project_name>"
```

`True`の場合は停止し、既存ディレクトリを削除・上書きしない。

---

## リポジトリ作成とclone

次の形式で実行すること。

```powershell
Set-Location "<local_parent>"

gh repo create "kenkiti/<project_name>" `
  --template "kenkiti/ai-development-template" `
  --private `
  --description "<description>" `
  --clone
```

`visibility: public`が明示された場合でも、実行前に確認を取ること。

通常はテンプレートのデフォルトブランチだけを使用し、
`--include-all-branches`は付けない。

---

## 初期設定

clone後、作成されたプロジェクトへ移動する。

```powershell
Set-Location "<local_parent>\<project_name>"
```

次を確認する。

```powershell
git status --short
git branch --show-current
git remote -v
Get-ChildItem -Force
```

以下のファイルが存在することを確認する。

```text
README.md
AGENTS.md
CLAUDE.md
DESIGN.md
docs/DEVELOPMENT.md
docs/HANDOFF.md
docs/ADR/
docs/research/
```

不足があれば、勝手に推測して完了扱いにせず報告する。

---

## プロジェクト固有ファイルの初期化

### README.md

最低限、以下を新規プロジェクト用に更新する。

- タイトル
- 概要
- 現在の状態
- 開発開始手順

テンプレート自体の説明は削除する。

### CLAUDE.md

以下をプロジェクト固有値へ置き換える。

- プロジェクト名
- buildコマンド
- testコマンド
- lint/formatコマンド
- 対象プラットフォーム
- 環境変数
- base branch
- worktree root
- branch prefix
- entry point

未確定の項目は推測せず、明示的に次の形式で残す。

```text
TBD: <確認が必要な内容>
```

実行不能な架空コマンドを記載しない。

### DESIGN.md

最低限、次の見出しを用意する。

```markdown
# <project_name>

## Purpose

## Goals

## Non-goals

## Constraints

## Architecture

## Milestones

## Open questions
```

ユーザーから設計内容が渡されていない場合は、空欄または`TBD`とし、
勝手に大規模な設計を確定しない。

### docs/HANDOFF.md

テンプレートの説明を残さず、初期状態として次を記録する。

- Current status
- Verified facts
- Decisions
- Open issues
- Next actions
- Recurring bug patterns

---

## 検証

編集後に次を実行する。

```powershell
git status --short
git diff --check
git diff
```

次を確認する。

- テンプレート名が不要な場所に残っていない
- プレースホルダーが意図せず残っていない
- 秘密情報が含まれていない
- Markdownリンクが明らかに壊れていない
- 作成対象以外のファイルを編集していない

プレースホルダー検索例:

```powershell
Get-ChildItem -Recurse -File |
  Select-String -Pattern '<[^>]+>|TBD|ai-development-template'
```

`TBD`を残す場合は、その理由を最終報告に記載する。

---

## コミットとpush

検証に合格した場合のみ、次を実行する。

```powershell
git add README.md CLAUDE.md DESIGN.md docs/HANDOFF.md
git commit -m "Initialize project from development template"
```

初期commitは自動で実行してよい。`git push`はユーザーが明示的に依頼した場合だけ実行する。

追加で編集したファイルがある場合は、内容を確認してから明示的に追加する。

`git add .`は使用しない。

---

## 完了条件

以下をすべて満たした場合のみ完了とする。

- GitHubリポジトリがテンプレートから作成されている
- ローカルcloneが成功している
- `origin`が新規リポジトリを指している
- 必須ファイルとフォルダが存在する
- プロジェクト固有ファイルが初期化されている
- `git diff --check`が成功している
- 秘密情報が含まれていない
- 初期コミットがpushされている
- 未確認事項が明示されている

---

## 最終報告形式

```markdown
## Result

- Repository:
- Local path:
- Visibility:
- Branch:
- Commit:

## Evidence

- `gh auth status`:
- `git remote -v`:
- `git status --short`:
- `git diff --check`:
- Push result:

## Initialized files

- README.md:
- CLAUDE.md:
- DESIGN.md:
- docs/HANDOFF.md:

## Unverified / TBD

- ...

## Remaining risks

- ...
```

主張はツールの実行結果と照合すること。

実行していない確認を「成功」と報告してはならない。
