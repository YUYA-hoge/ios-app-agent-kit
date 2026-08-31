# {{APP_NAME}} AI駆動開発設計

## 目的

要求、仕様、技術設計、実装、検証、App Store提出、マーケティングを、Codexのメインエージェントとプロジェクト固有subagentで安全に分担します。会話だけを正本にせず、仕様、実行計画、コード、テスト、Git履歴へ判断と証跡を残します。

## 決定事項

- メインエージェントを開発マネージャー兼オーケストレータとします。
- custom subagentは`.codex/agents/*.toml`でプロジェクト管理します。
- モデルとreasoning effortは親エージェントから継承します。
- 同じworktreeでwrite agentを並列実行しません。
- 実装者とQAを分離します。
- App Store Connect変更、提出、公開、外部投稿は明示許可を必要とします。
- 同時に開くsubagent threadは最大4本とし、実運用で見直します。

## チーム

| Agent | 成果物 | 権限 |
|---|---|---|
| `concept_engineer` | 対象ユーザー、課題、価値、差別化 | read-only |
| `product_design_engineer` | 要件、UX、状態、受け入れ条件 | docs-only write |
| `ios_explorer` | 影響範囲、ファイル、symbol、依存関係 | read-only |
| `ios_architecture_engineer` | 技術設計、データモデル、移行、テスト境界 | docs-only write |
| `ios_implementation_engineer` | Swift実装、自動テスト | scoped workspace-write |
| `qa_engineer` | build/test結果、Simulator証跡、finding、PASS判定 | test-only write |
| `security_privacy_engineer` | データ・権限・課金・Privacy監査 | read-only |
| `app_store_release_engineer` | リリース準備、TestFlight、審査状態 | scoped workspace-write |
| `growth_marketing_engineer` | ASO、コンテンツ、素材、計測計画 | scoped workspace-write |

## 標準フロー

### 新規機能

```text
development manager
  -> product_design_engineer
  -> ios_explorer
  -> ios_architecture_engineer（技術設計、データ、移行に影響する場合）
  -> ios_implementation_engineer
  -> deterministic validation
  -> qa_engineer
  -> security_privacy_engineer（データ、権限、通信、依存、課金の変更時）
  -> PR
```

### 不具合

```text
qa_engineer or ios_explorer reproduces and scopes
  -> ios_implementation_engineer applies a bounded fix
  -> deterministic validation
  -> qa_engineer independently re-verifies
```

### App Store

```text
qa_engineer PASS
  -> security_privacy_engineer PASS
  -> app_store_release_engineer verifies candidate and metadata
  -> user explicitly authorizes the exact external action
  -> execute that action
```

提出、承認、公開を別の状態として扱います。

## subagent依頼契約

```text
Role:
Goal:
Authoritative inputs:
Allowed files or read-only boundary:
Constraints and prohibited actions:
Done when:
Required evidence:
Next owner:
```

## subagent結果契約

```text
status: PASS | CONDITIONAL_PASS | FINDING | BLOCKED | FAIL
summary:
artifacts_changed:
evidence:
commands_run:
findings:
uncertainties:
external_state_changed:
recommended_next_action:
```

findingにはseverity、file・symbol・screen、期待値、観察結果、再現手順を含めます。

## 実行計画

複数ファイル、データ移行、課金、通知、リリース、長時間作業は、実装前に`docs/exec-plans/active/`へ計画を作成します。完了時に実行コマンド、検証結果、残存リスクを追記し、`completed/`へ移動します。

## 完了ゲート

1. 受け入れ条件が文書化されている。
2. 実装と影響する仕様が一致している。
3. 対象のbuildと自動テストが成功している。
4. 必要なSimulator操作とアクセシビリティ確認が完了している。
5. QAと、必要なSecurity/Privacy監査にblocking findingがない。
6. 最終diffに無関係な変更、秘密情報、生成物がない。
7. 未実行の検証と残存リスクがPRへ記録されている。
