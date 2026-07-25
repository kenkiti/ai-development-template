# HANDOFF.md

現在の実行状態と、将来の作業に役立つ恒久的な知識を記録する。簡潔で、最新かつ重複のない、証拠に基づく内容に保つ。

このファイルを時系列のチャットログにしない。コード、Git履歴、`DESIGN.md`から明らかな情報は繰り返し記録しない。

## 1. 現在の状態

- 現在のフェーズ: <phase>
- 作業中のタスク: <task or none>
- タスクブランチ: `<branch or none>`
- Worktree: `<absolute path or none>`
- 最後に完了したMilestone: <milestone>
- 次に安全に実行できる作業: <single concrete next action>
- 最終更新日: <YYYY-MM-DD>

## 2. 検証マトリクス

| 領域 / 要件 | 状態 | 証拠 | 最終確認日 |
|---|---|---|---|
| <item> | PASS / FAIL / UNVERIFIED / NOT APPLICABLE | <command, output, screenshot, artifact, or reason> | <date> |

## 3. 既知の問題と技術的負債

| ID | 問題 | 影響 | 証拠 | 次の対応 | 状態 |
|---|---|---|---|---|---|
| KI-001 | ClaudeからWindows版Codex CLIを起動した際、PowerShell 7のセッション起動に失敗することがある | Codexプロセスが実装を開始せず、Claude側の監視が長時間継続する | `Windows error 1312`、`CreateProcessAsUserW failed`、PowerShell session startup failure。直接のPowerShellから同じ作業ディレクトリで実行したread-only smoke testは成功 | 同じエラーが2回発生した時点でリトライを止める。Codexのプロセス状態、ログ時刻、worktreeを確認し、必要に応じてCodex一時ディレクトリの権限を修復するかWSL2実行へ切り替える | Open |

## 4. 恒久的な事実

検証済みで、プロジェクト固有であり、コードからは明らかでなく、今後のセッションで重要になる事実だけを記録する。

- **FACT-001** — <fact>  
  証拠: <source, command, file, or observed behavior>
  確認日: <YYYY-MM-DD>

## 5. 恒久的な方針

今後の実装や検証の判断を変えるルールを記録する。

- **POLICY-001** — <decision rule>  
  理由: <why this policy exists>
  適用範囲: <scope>

## 6. 再発するバグパターン

複数回観測したパターン、または将来に明確な価値がある重大なパターンだけを記録する。

- **PATTERN-001** — Claude経由のCodex実行でPowerShell 7起動が不安定になる
  症状: Codexプロセスは生存し、`Responding=True`でもCPU使用時間・ログ・worktreeに変化がない。
  原因: ClaudeからWindows版Codexを起動する経路で、PowerShell 7のプロセス生成またはCodex一時ディレクトリの権限処理が失敗している可能性がある。根本原因は環境依存のため、未確定とする。
  再発防止: 起動直後に対象worktreeで`Get-Location`と`Get-ChildItem -Force`だけを実行するsmoke testを行う。3分間隔でプロセス、出力時刻、worktreeを確認し、3回連続で進展がなければCodexと監視を停止する。`Windows error 1312`、`CreateProcessAsUserW failed`、PowerShell起動失敗が2回発生した場合は即時に環境障害として扱う。
  復旧策: `%USERPROFILE%\.codex\tmp`のユーザー権限を確認・修復し、改善しなければ同じworktreeをWSL2側から実行する。
  証拠: `codex exec -C "$PWD" --sandbox workspace-write`によるClaude経由の実行で発生。直接PowerShellからのread-only smoke testは成功した。
  最終確認日: 2026-07-25

## 7. 解決済みまたは置き換え済みの項目

現在の制約を説明したり、同じ調査の繰り返しを防いだりする項目だけを残す。

- <YYYY-MM-DD> — <item> — <decision, fix, or ADR> により解決 / 置換

## 8. セッション終了チェックリスト

- [ ] 現在の状態と次の安全な作業が正確である。
- [ ] 検証済みの証拠と未検証の項目を記録した。
- [ ] 既知の問題に重複がない。
- [ ] 新しい恒久的事実を証拠で裏付けた。
- [ ] 新しい方針が説明ではなく実行可能な内容になっている。
- [ ] 再発パターンに症状だけでなく防止策を記載した。
- [ ] 誤った情報や古い情報を修正した。
- [ ] 日常的な進捗ノイズを追加していない。
