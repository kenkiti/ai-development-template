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
| <KI-ID> | <problem> | <impact> | <evidence> | <next action> | Open / Closed |

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

- **PATTERN-<NNN>** — <recurring bug pattern>
  症状: <symptoms>
  原因: <verified cause or explicitly unconfirmed inference>
  再発防止: <prevention>
  証拠: <source, command, or observation>
  最終確認日: <YYYY-MM-DD>

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
