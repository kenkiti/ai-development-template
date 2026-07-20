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

## Usage

1. GitHubでこのリポジトリをTemplate repositoryとして設定するか、内容を新規プロジェクトへコピーします。
2. `CLAUDE.md`のすべての`<placeholder>`を実際の値へ置き換えます。
3. `DESIGN.md`へ最初の設計とスコープを記載します。
4. `docs/HANDOFF.md`へ現在の状態と最初の次アクションを記載します。
5. 不要な例や適用しない項目を削除します。
6. AIへ実装を依頼する前に、ビルド・テストコマンドが実際に動くことを確認します。

## Core workflow

```text
Claude Code inspects repository state
→ creates or reuses one task worktree
→ delegates implementation to one Codex thread
→ Codex implements and reviews its own diff
→ Claude Code independently verifies the actual diff and behavior
→ score 90/100 or higher with no critical defect
→ update documentation
→ commit and push the task branch
```

既定は直列運用です。

```text
one task = one branch = one worktree = one Codex thread
```

レビュー不合格を理由に、新しいブランチ、worktree、Codexスレッドを作りません。同じ作業単位へ具体的な不具合を返して修正します。

## First customization checklist

- [ ] `CLAUDE.md`のプレースホルダーをすべて置換した
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
