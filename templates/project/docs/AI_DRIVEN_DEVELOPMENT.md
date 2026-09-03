# {{APP_NAME}} AI駆動開発設計

## 目的

要求、仕様、技術設計、実装、検証、App Store提出、マーケティングを、Codexのメインエージェントを中心に安全に進めます。会話だけを正本にせず、仕様、実行計画、コード、テスト、Git履歴へ判断と証跡を残します。

本設計はMain Agent Firstを採用します。メインエージェントが保持しているコンテキストで完了できる作業は直接実行し、コンテキスト分離、独立検証、read-heavyな並列化、権限分離の利益が再読込・通信・統合コストを上回る作業だけをsubagentへ委譲します。

## 決定事項

- メインエージェントをデフォルトの実行主体、開発マネージャー兼オーケストレータとします。
- custom subagentは`.codex/agents/*.toml`でプロジェクト管理します。
- モデルとreasoning effortは親エージェントから継承します。
- 通常作業は現在のcheckoutで行い、別worktreeを自動作成しません。
- 独立QAが必要な高リスク変更だけ実装者とQAを分離します。
- App Store Connect変更、提出、公開、外部投稿は明示許可を必要とします。
- 同時に開くsubagent threadは原則2〜3本までとし、必要性がない場合は0本とします。
- 1〜3ファイルの変更、単純な修正、軽微なUI、短い文書変更では原則subagentを使用しません。
- subagentには必要なファイル、目的、制約だけを渡し、リポジトリ全体の再読込を求めません。

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

各subagentは常時通過する工程ではなく、必要条件を満たした場合だけ選ぶ専門ロールです。

## 標準フロー

### 通常の変更

```text
User
  -> Main Agentが調査、実装、検証、統合
  -> 必要な場合だけExplorer / Worker / Reviewer
  -> PR
```

新規機能という理由だけでPlanner、Architect、Implementer、QAを直列起動しません。独立探索、限定実装、高リスクレビューなど委譲の利益が明確な役割だけを追加します。

### 不具合

```text
Main Agentが再現・原因範囲を特定して限定修正
  -> deterministic validation
  -> 高リスクまたは明示要求時だけ独立Reviewer / QA
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

メインエージェントは、subagentが必要と判断した場合だけ次を簡潔に明示します。

```text
Role:
Goal:
Authoritative inputs:
Allowed files or read-only boundary:
Constraints and prohibited actions:
Done when:
Required evidence:
```

入力として指定されたファイルだけを最初に読ませ、追加ファイルは必要になった場合だけ読みます。同じ書き込み対象を複数agentへ同時に割り当てません。通常の実装では別worktreeを自動作成せず、ユーザーが開いているcheckoutを使用します。

## subagent結果契約

```text
result: PASS | CONDITIONAL_PASS | FINDING | BLOCKED | FAIL
changed_files:
tests:
unresolved:
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

## 段階導入

Main Agent Firstを標準とし、専門subagentは必要時だけ利用します。通常作業へ多段のPlanner、Architect、Implementer、QAループを適用しません。常時自律型loop、独自harness、subagent eval、AIによるCI hard gateは、測定可能な必要性が確認されるまで導入しません。
