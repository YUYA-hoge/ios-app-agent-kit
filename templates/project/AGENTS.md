# {{APP_NAME}} AI開発ルール

このファイルは、人間とCodexエージェントがこのリポジトリで開発するときの共通ルールです。実装を始める前に、実際のリポジトリ構成、build、test、リリース手順を調査してこの文書へ追記してください。

## オーケストレーション

- AI駆動開発の設計: `docs/AI_DRIVEN_DEVELOPMENT.md`
- 進行中の実行計画: `docs/exec-plans/active/`
- 完了済みの実行計画: `docs/exec-plans/completed/`
- プロジェクト固有subagent: `.codex/agents/`

メインエージェントは開発マネージャーとして、要求整理、担当選択、作業範囲の分離、成果物の統合、完了判定を担います。

- read-heavyな探索、調査、レビューは独立している場合だけ並列化します。
- 同じファイルを複数のwrite agentに同時割り当てません。
- 並列のコード変更は1タスク1worktreeに分離します。
- 実装担当とQA担当を分離し、QA担当は不具合を直接修正しません。
- subagentには目的、正本となる入力、変更可能範囲、完了条件、必要な証跡、次の担当を明示します。

## 変更と検証

1. 作業前に`git status --short --branch`を確認します。
2. 既存の未コミット変更をユーザーの作業として保護します。
3. 要件を観測可能な受け入れ条件にしてから実装します。
4. 対象のbuild、自動テスト、Simulator操作、アクセシビリティ確認をリスクに応じて実行します。
5. 検証できなかった項目は理由と残存リスクを報告します。
6. 変更後に無関係なファイル、秘密情報、生成物が含まれていないことを確認します。

## 外部操作

App Store Connectへの保存、identifier・capability変更、build upload、TestFlight招待、審査提出、公開、SNS・コミュニティ投稿、返信、DM、フォロー、広告出稿は、現在の依頼でその操作が明示的に許可された場合だけ実行します。提出許可を公開許可として扱いません。

## プロジェクト固有情報

- Source directories: <!-- TODO: fill for this repository -->
- Test targets and directories: <!-- TODO: fill for this repository -->
- Build command or tool: <!-- TODO: fill for this repository -->
- Simulator/device matrix: <!-- TODO: fill for this repository -->
- Specification index: <!-- TODO: fill for this repository -->
- Branch and PR rules: <!-- TODO: fill for this repository -->
