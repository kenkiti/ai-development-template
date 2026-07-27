# ai-development-template

Claude Codeをオーケストレーター、Codexを実装担当として運用するための、再利用可能なAI開発テンプレートです。

このリポジトリは、次の課題を減らすことを目的としています。

- AIが確認を繰り返して作業を止める
- 同一タスクでブランチやworktreeが増殖する
- 「完了しました」という報告に証拠がない
- 実装担当と検証担当の責務が曖昧になる
- プロジェクト固有ルールと共通ルールが混在する
- 過去の失敗や判断が次回へ引き継がれない

## Structure

```text
project/
├── AGENTS.md
├── CLAUDE.md
├── DESIGN.md
├── CHANGELOG.md
├── LICENSE
├── tools/
│   ├── NEW_PROJECT.md
│   ├── UPDATE_TEMPLATE.md
│   ├── RELEASE.md
│   └── init-project.ps1
└── docs/
    ├── DEVELOPMENT.md
    ├── HANDOFF.md
    ├── ADR/
    │   ├── README.md
    │   └── 0000-template.md
    └── research/
        └── README.md
```

## Responsibility map

| File | Responsibility |
|---|---|
| `AGENTS.md` | すべてのAIエージェントが最初に読む短い入口 |
| `CLAUDE.md` | ビルド、テスト、環境、Gitなどのプロジェクト固有設定 |
| `DESIGN.md` | アーキテクチャ、境界、主要フロー、ADR索引 |
| `docs/DEVELOPMENT.md` | Claude Code・Codex・worktree・品質ゲートの共通運用本体 |
| `docs/HANDOFF.md` | 現在の状態、検証証拠、未解決事項、再発防止の学び |
| `docs/ADR/` | 重要な設計判断と、その理由・影響 |
| `docs/research/` | 調査、比較、技術検証、根拠資料 |
| `tools/NEW_PROJECT.md` | テンプレートから新規リポジトリを作成し、初期化する手順 |
| `tools/UPDATE_TEMPLATE.md` | 共通テンプレートの更新を既存プロジェクトへ安全に反映する手順 |
| `tools/RELEASE.md` | テンプレートのバージョン確定、CHANGELOG、タグおよび公開手順 |
| `tools/init-project.ps1` | 新規プロジェクト作成時の機械的な事前確認と初期化補助 |

## Usage

1. GitHubでこのリポジトリをTemplate repositoryとして設定するか、内容を新規プロジェクトへコピーします。
2. `CLAUDE.md`の分類付きTBDを、実装開始またはリリースの前提に従って解消します。
3. `DESIGN.md`へ最初の設計とスコープを記載します。
4. `docs/HANDOFF.md`へ現在の状態と最初の次アクションを記載します。
5. 不要な例や適用しない項目を削除します。
6. AIへ実装を依頼する前に、ビルド・テストコマンドが実際に動くことを確認します。

この公開リポジトリはテンプレートの配布元です。リポジトリへの変更は、使用するツールの能力ではなく、本テンプレートで定めた承認ルール、Git運用ルール、変更範囲に従って制御します。

生成先では、`docs/DEVELOPMENT.md`を残し、`tools/`はテンプレート保守および新規作成用として扱います。テンプレート更新を生成先でも行う場合は`tools/`を残し、行わない場合は次の明示した一覧を初期化完了後に削除できます: `tools/NEW_PROJECT.md`、`tools/UPDATE_TEMPLATE.md`、`tools/RELEASE.md`、`tools/init-project.ps1`。推測で他のファイルを削除しないでください。

## Core workflow

```text
Claude Code inspects repository state
→ creates or reuses one task worktree
→ delegates implementation to one Codex thread
→ Codex implements and reviews its own diff
→ Claude Code independently verifies the actual diff and behavior
→ score 90/100 or higher with no critical defect
→ update documentation
→ commit according to project policy
→ push only when the specific push has already been explicitly authorized
```

既定は直列運用です。

```text
one task = one branch = one worktree = one Codex thread
```

レビュー不合格を理由に、新しいブランチ、worktree、Codexスレッドを作りません。同じ作業単位へ具体的な不具合を返して修正します。

## First customization checklist

- [ ] `TBD-REQUIRED-BEFORE-IMPLEMENTATION`が残っていない
- [ ] リリース前に`TBD-REQUIRED-BEFORE-RELEASE`を解消した
- [ ] base branch、worktree root、branch prefixを指定した
- [ ] build、targeted test、full test、lint、E2Eのコマンドを指定した
- [ ] 本番API、実データ、破壊的テストの制限を指定した
- [ ] 完了を証明する観測可能なacceptance conditionを指定した
- [ ] 変更禁止パスと既知の落とし穴を指定した
- [ ] `DESIGN.md`のスコープと非スコープを記載した
- [ ] `docs/HANDOFF.md`の未確認事項を記載した
- [ ] 公開する場合はライセンスと公開範囲を決定した

## Maintenance policy

このテンプレートへ追加するルールは、複数プロジェクトで再利用できるものに限定します。個別プロジェクトのコマンドや制約は、そのプロジェクトの`CLAUDE.md`へ置きます。

未確定値は次の形式で分類します。`TBD-REQUIRED-BEFORE-IMPLEMENTATION`は実装開始前、`TBD-REQUIRED-BEFORE-RELEASE`は公開・配布・デプロイ前に確定必須です。`TBD-OPTIONAL`は適用しない場合に削除できます。不明なコマンドを推測して記載しません。

```powershell
Get-ChildItem -Recurse -File |
  Where-Object { $_.FullName -notmatch '[\\/]\.git[\\/]' } |
  Select-String -Pattern '<[^>]+>|TBD-REQUIRED-BEFORE-IMPLEMENTATION|TBD-REQUIRED-BEFORE-RELEASE|TBD-OPTIONAL|ai-development-template'
```

ルールを追加する前に、次を確認します。

- 同じ内容が別ファイルに重複していないか
- AIが実際に誤る可能性を減らすか
- 毎回読むトークン量に見合うか
- 実行可能で、検証可能な表現になっているか

## Versioning

テンプレート自体はSemantic Versioningで管理します。

- PATCH: 表現修正、誤記修正、互換性のある明確化
- MINOR: 新しい任意ルール、テンプレート、セクションの追加
- MAJOR: 役割分担、ファイル責務、標準フローの非互換変更

変更内容は`CHANGELOG.md`へ記録します。

ライセンスは[MIT License](LICENSE)です。テンプレートを利用する生成先のライセンスと公開範囲は、各プロジェクトで決定してください。
