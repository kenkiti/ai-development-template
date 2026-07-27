# Template Update Runbook

既存プロジェクトへテンプレートの共通ルールを反映する手順です。プロジェクト固有設定を単純上書きせず、差分と検証証拠を残します。

## 入力情報

```yaml
template_repository: kenkiti/ai-development-template
target_repository: <owner/repository>
target_local_path: <absolute path>
template_version_from: <current version or commit>
template_version_to: <new version or commit>
```

## 事前確認とrollback

次を実行し、未コミット変更、対象、更新元commitを確認します。

```powershell
git status --short
git branch --show-current
git remote -v
git worktree list
```

対象、パス、更新元が不明、予期しない差分がある、破壊的上書きが必要、または固有値を維持できない場合は停止します。更新用ブランチまたはworktreeを使い、開始前commitをrollback pointとして記録します。dirty worktreeを強制処理せず、`git reset --hard`や強制削除を標準rollbackにしません。

## ファイル分類

単純上書きしない:

- `README.md`
- `CLAUDE.md`
- `DESIGN.md`
- `docs/HANDOFF.md`
- `CHANGELOG.md`

差分確認後に更新:

- `AGENTS.md`
- `docs/DEVELOPMENT.md`
- `.gitignore`
- `docs/ADR/README.md`
- `docs/ADR/0000-template.md`
- `docs/research/README.md`

テンプレート保守用:

- `tools/NEW_PROJECT.md`
- `tools/UPDATE_TEMPLATE.md`
- `tools/RELEASE.md`
- `tools/init-project.ps1`
- `LICENSE`

## 更新手順

1. 更新元の`CHANGELOG.md`を読む。
2. 対象バージョン間の変更を抽出する。
3. 共通ルールとプロジェクト固有変更を分類する。
4. 対応ファイルとdiffを確認する。
5. 固有値を維持して手動マージし、古い重複ルールを削除する。
6. プレースホルダーと相対リンクを確認する。
7. Markdown差分とプロジェクト固有build/testを確認する。
8. `docs/HANDOFF.md`へ更新結果と未確認事項を記録する。
9. 品質ゲートを実施する。
10. commitはプロジェクトポリシーに従う。
11. pushはそのpushへの明示許可がある場合だけ実行する。

## 検証と最終報告

```powershell
git status --short
git diff --check
git diff --stat
git diff
```

利用可能ならMarkdown lint、リンクチェック、PowerShell構文確認、build、targeted test、full test、E2Eを実行し、未実行は`NOT RUN`と記録します。

```markdown
## Template update result
### Source
- Repository:
- From:
- To:
### Target
- Repository:
- Worktree:
- Branch:
### Changed files
- ...
### Preserved project-specific values
- ...
### Checks
- PASS:
- FAIL:
- NOT RUN:
### Commit
- Hash:
- Push:
### Remaining risks
- ...
### Unverified
- ...
### Rollback point
- ...
```

