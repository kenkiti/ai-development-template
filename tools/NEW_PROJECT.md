# New Project Bootstrap

`kenkiti/ai-development-template`から新規プロジェクトを作成し、安全に初期化するための日本語runbookです。機械的な処理には`tools/init-project.ps1`を使用できます。

## 入力値

```yaml
project_name: <repository-name>
description: <repository description>
visibility: private
local_parent: C:\Users\<username>\Github
owner: kenkiti
```

未確定値は次の形式で分類します。

- `TBD-REQUIRED-BEFORE-IMPLEMENTATION`: 実装開始前に確定必須
- `TBD-REQUIRED-BEFORE-RELEASE`: 公開、配布、デプロイまたはリリース前に確定必須
- `TBD-OPTIONAL`: 適用しない場合に削除可能

少なくともbase branch、worktree root、required working directory、protected paths、build command、targeted test command、acceptance conditionは実装開始前に確定します。不明なコマンドを推測して記載しません。

## 推奨フロー

1. 入力値と作成権限を決定する。
2. `init-project.ps1`でGitHubリポジトリ作成、clone、機械的な確認を行う。
3. `README.md`、`CLAUDE.md`、`DESIGN.md`、`docs/HANDOFF.md`をプロジェクト固有値へ初期化する。
4. `init-project.ps1 -ValidateOnly`で再検証する。
5. 品質ゲートを実施する。
6. 検証合格後、プロジェクトポリシーに従って初期commitを作成してよい。
7. pushは、そのpushをユーザーが明示的に許可した場合だけ実行する。push未許可でもローカル初期化は完了できる。

作成例:

```powershell
./tools/init-project.ps1 `
  -ProjectName "example-project" `
  -Description "Example project" `
  -LocalParent "C:\Users\<username>\Github"
```

検証例:

```powershell
./tools/init-project.ps1 `
  -ProjectName "example-project" `
  -Description "Example project" `
  -LocalParent "C:\Users\<username>\Github" `
  -ValidateOnly
```

Public作成は監査後に`-AllowPublic`を付けて実行します。スクリプトを使わない場合も、`gh repo view`、重複確認、templateからのclone、remote確認、必須ファイル確認を同じ順序で実施します。clone時に`--include-all-branches`は使用しません。

## 初期化規則

### DESIGN.md

- テンプレートに存在する章構成を維持する。
- 得られた情報を対応する章へ記入する。
- 未確定項目は分類付きTBDとして残す。
- 既存の章を削除せず、簡略化した別形式へ全面置換しない。
- 設計情報がない場合に大規模な設計を推測して確定しない。
- 適用しない章は理由を明記して`Not applicable`とするか、ユーザーの明示判断で削除する。

### docs/HANDOFF.md

次の見出し構造を維持します。

1. 現在の状態
2. 検証マトリクス
3. 既知の問題と技術的負債
4. 恒久的な事実
5. 恒久的な方針
6. 再発するバグパターン
7. 解決済みまたは置き換え済みの項目
8. セッション終了チェックリスト

新規プロジェクトの初期値を記入し、不明な値は分類付きTBDにします。存在しない問題や事実を推測して追加しません。説明文を生成先向けに置き換える場合も見出しを維持し、空の表や例示行はプレースホルダーであることを保ちます。

## tools/の扱い

`docs/DEVELOPMENT.md`は生成先にも残します。`tools/`はテンプレート保守および新規作成用です。生成先でもテンプレート更新を行う場合は残し、行わない場合は初期化完了後に次の一覧だけを削除できます。

- `tools/NEW_PROJECT.md`
- `tools/UPDATE_TEMPLATE.md`
- `tools/RELEASE.md`
- `tools/init-project.ps1`

推測で他のファイルを削除しません。

## 検証

```powershell
git status --short
git branch --show-current
git remote -v
git diff --check
```

プレースホルダー検索では`.git`、生成物、依存関係を除外し、分類付きTBD、`<...>`、テンプレート名を確認します。`TBD-REQUIRED-BEFORE-IMPLEMENTATION`が残る場合は実装を開始できず、`TBD-REQUIRED-BEFORE-RELEASE`が残る場合はリリースできません。

## Commit、push、完了条件

明示したファイルだけをstageします。`git add .`は使用しません。push、merge、tag push、GitHub Release作成は、それぞれの明示許可が必要です。

完了条件:

- GitHubリポジトリがテンプレートから作成されている。
- ローカルcloneが成功している。
- `origin`が新規リポジトリを指している。
- 必須ファイルとディレクトリが存在する。
- プロジェクト固有ファイルが初期化されている。
- `git diff --check`が成功している。
- 秘密情報が含まれていない。
- 初期commitが作成されている。
- pushが明示許可された場合はpushが成功している。
- pushが許可されていない場合はローカル初期化完了・push未実施と報告されている。
- 未確認事項が明示されている。

最終報告のPush状態は`PUSHED`、`NOT PUSHED — not authorized`、`FAILED`のいずれかです。`FAILED`では実行コマンド、終了状態、関連エラーを記録します。

## 最終報告

```markdown
## Result
- Repository:
- Local path:
- Visibility:
- Branch:
- Commit:
- Push: PUSHED / NOT PUSHED — not authorized / FAILED

## Evidence
- `gh auth status`:
- `git remote -v`:
- `git status --short`:
- `git diff --check`:
- Unverified / TBD:
```
