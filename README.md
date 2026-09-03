# iOS App Agent Kit

CodexでネイティブiOSアプリを開発するための、プロジェクト単位のAI開発チームテンプレートです。

9つのcustom subagent、Main Agent Firstの運用を定義する`AGENTS.md`、プロジェクトSkill、長時間作業用の実行計画をリポジトリ内に導入します。ユーザー全体の`~/.codex`や`~/.agents`は変更しません。

メインエージェントが通常の作業を直接進め、subagentは独立した探索、限定実装、高リスクQAなど、委譲の利益が明確な場合だけ利用します。小さな変更のたびに9つのagentを順番に起動するパッケージではありません。

## 1コマンドで導入

対象のiOSリポジトリ直下で実行します。

```bash
kit_dir=$(mktemp -d) && git clone --depth 1 https://github.com/YUYA-hoge/ios-app-agent-kit.git "$kit_dir" && "$kit_dir/scripts/install.sh" --app-name "MyApp" .
```

`MyApp`を対象アプリ名に変更してください。`--app-name`を省略すると、リポジトリのディレクトリ名を使います。

既存ファイルと衝突する場合、インストーラーは何も変更せず終了します。内容を確認したうえで上書きする場合だけ`--force`を使ってください。上書き対象は`.ios-app-agent-kit-backup/`へ退避されます。

## 導入されるチーム

| Agent | 担当 |
|---|---|
| `concept_engineer` | 対象ユーザー、課題、価値、差別化 |
| `product_design_engineer` | 要件、UX、受け入れ条件 |
| `ios_explorer` | コードと仕様の影響範囲調査 |
| `ios_architecture_engineer` | SwiftUI、SwiftData、StoreKit、移行の技術設計 |
| `ios_implementation_engineer` | 限定された機能実装と自動テスト |
| `qa_engineer` | build、test、Simulator、アクセシビリティの独立検証 |
| `security_privacy_engineer` | データ、権限、通信、課金、Privacy申告の監査 |
| `app_store_release_engineer` | TestFlight、メタデータ、審査、公開状態 |
| `growth_marketing_engineer` | ASO、SNS、コミュニティ、素材、計測 |

## 使い方

導入後、対象リポジトリをCodexで信頼して新しいタスクを開きます。例:

```text
この機能を実装して。必要な場合だけプロジェクトのsubagentを使い、ビルドとテストまで完了して。
```

Codexは`AGENTS.md`と`.codex/agents/*.toml`を読み、まずメインエージェントで完了できるかを判断してから必要な担当だけを選びます。複数ファイル、データ移行、課金、通知、リリースなどは`docs/exec-plans/active/`に実行計画を作成します。

### 運用方針

- 1〜3ファイルの変更、単純な修正、軽微なUI、短い文書変更は原則としてメインエージェントが担当します。
- subagentは独立した並列作業、長時間のread-heavy調査、明確に限定できる実装、高リスク変更の独立QAで利用します。
- 同時subagent数は原則2〜3までです。
- 通常作業では、ユーザーが開いているcheckoutを使い、worktreeや別ディレクトリを自動作成しません。
- QAの独立性が必要なのは、データ消失、日付計算、通知、永続化、移行、課金、認証、複数画面変更、大規模リファクタリングなどです。

## ローカルから導入

```bash
./scripts/install.sh --app-name "MyApp" /path/to/MyApp
```

導入内容だけを確認するには:

```bash
./scripts/install.sh --dry-run --app-name "MyApp" /path/to/MyApp
```

既存導入を更新するときは、対象プロジェクトの変更を先にコミットし、`--dry-run`で衝突を確認してください。`--force`は既存の`AGENTS.md`やプロジェクト固有設定も置き換えるため、バックアップとの差分を確認して必要な変更を統合してください。

## プラグインとして使う

このリポジトリはCodexプラグイン形式も備えています。プラグインを追加した場合でも、subagentと`AGENTS.md`は対象プロジェクト側に導入する必要があります。Skillに「このプロジェクトにインストールして」と依頼してください。

## 安全設計

- 同じファイルを複数のwrite agentに同時割り当てません。
- 高リスク変更では実装者とQAを分離します。
- 通常の機能実装で別worktreeを自動作成しません。
- App Store Connectの書き込み、審査提出、公開、SNS投稿は、現在の依頼で明示許可された場合だけ実行します。
- `sandbox_mode`だけを安全境界とせず、親セッションの権限も確認します。

## 必要環境

- Git
- Bash 3.2以降
- Codexのcustom subagent対応版
- iOS実行確認にXcodeと対応Simulator

## 検証

```bash
./scripts/test.sh
```

## License

[MIT](./LICENSE)
