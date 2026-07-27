# Template Release Runbook

対象は`kenkiti/ai-development-template`です。これは手順書であり、作成中にcommit、push、tag、GitHub Releaseは実行しません。

## 事前確認

```powershell
git status --short
git branch --show-current
git remote -v
git log -1 --oneline
```

未確認差分、対象branch、version、CHANGELOG記載、秘密情報混入、必須検証のいずれかに問題があれば停止します。

## Semantic Versioning

- PATCH: 誤記修正、表現修正、互換性のある明確化
- MINOR: 新しい任意ルール、テンプレート、runbook、補助スクリプトの追加
- MAJOR: 役割分担、ファイル責務、標準ワークフローの非互換変更

runbook、補助スクリプト、LICENSE、規則明確化の追加は原則MINOR候補ですが、実際の変更内容を確認して決定します。

## CHANGELOGと検証

`Unreleased`を確認し、`Added`、`Changed`、`Fixed`へ実際の変更だけを分類します。リリース時はversionと日付を追加し、空の`Unreleased`を先頭へ作成します。

最低限、次を確認します。

```powershell
git status --short
git diff --check
git diff --stat
git diff
```

README構成、責務表、相対リンク、LICENSE、分類付きTBD、個人情報、ローカルパス、秘密情報、PowerShell構文、3つのrunbook間のcommit/push/merge/tag規則を確認します。

## リリース操作

品質ゲート合格後に次を行います。

1. CHANGELOGと必要文書を更新する。
2. リリースcommitを作成する。
3. pushはユーザーがそのpushを明示許可した場合だけ行う。
4. version確定後、tag作成の明示許可がある場合だけ作成する。
5. tag pushは明示許可がある場合だけ行う。
6. GitHub Releaseは明示依頼がある場合だけ作成する。

```powershell
git tag -a "v<version>" -m "Release v<version>"
```

公開済みtagの削除・付け替え、履歴改変、force pushは行いません。修正は原則として新しいPATCH releaseにします。

## 最終報告

```markdown
## Release result
### Version
- Previous:
- New:
- Type:
### Changes
- Added:
- Changed:
- Fixed:
### Checks
- PASS:
- FAIL:
- NOT RUN:
### Git
- Branch:
- Commit:
- Push:
- Tag:
- Tag push:
- GitHub Release:
### Remaining risks
- ...
### Unverified
- ...
```

