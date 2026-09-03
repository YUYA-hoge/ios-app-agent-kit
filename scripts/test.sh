#!/usr/bin/env bash

set -euo pipefail

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
kit_root=$(CDPATH= cd -- "$script_dir/.." && pwd)
test_root=$(mktemp -d)
cleanup() { rm -rf -- "$test_root"; }
trap cleanup EXIT HUP INT TERM

"$kit_root/scripts/install.sh" --app-name "ExampleApp" "$test_root/project" >/dev/null

test -f "$test_root/project/.codex/config.toml"
test -f "$test_root/project/.codex/agents/qa-engineer.toml"
test -f "$test_root/project/.agents/skills/ios-app-agent-workflow/SKILL.md"
test -f "$test_root/project/AGENTS.md"
test -f "$test_root/project/docs/AI_DRIVEN_DEVELOPMENT.md"
test -f "$test_root/project/docs/exec-plans/TEMPLATE.md"
for document in \
  00_INDEX.md \
  01_PRODUCT_CONCEPT.md \
  02_PRODUCT_REQUIREMENTS.md \
  03_UX_UI_SPECIFICATION.md \
  04_TECHNICAL_ARCHITECTURE.md \
  05_DATA_MODEL.md \
  06_DEVELOPMENT_ROADMAP.md \
  07_TEST_AND_RELEASE.md \
  08_DECISIONS_AND_OPEN_QUESTIONS.md; do
  test -f "$test_root/project/docs/$document"
done
test "$(find "$test_root/project/.codex/agents" -name '*.toml' | wc -l | tr -d ' ')" = "9"
grep -q 'ExampleApp' "$test_root/project/AGENTS.md"
! grep -R -q '{{APP_NAME}}' "$test_root/project"
grep -q 'メインエージェントをデフォルトの実行主体' "$test_root/project/AGENTS.md"
grep -q '同時subagent数は原則2〜3' "$test_root/project/AGENTS.md"
grep -q '別worktreeや別ディレクトリを自動作成しません' "$test_root/project/AGENTS.md"
grep -q 'Main Agent First' "$test_root/project/docs/AI_DRIVEN_DEVELOPMENT.md"
grep -q 'Documentation First' "$test_root/project/docs/AI_DRIVEN_DEVELOPMENT.md"
grep -q 'コンセプト承認' "$test_root/project/docs/00_INDEX.md"
grep -q 'Documentation-first gate' "$test_root/project/.agents/skills/ios-app-agent-workflow/SKILL.md"
cmp -s "$kit_root/skills/ios-app-agent-workflow/SKILL.md" "$test_root/project/.agents/skills/ios-app-agent-workflow/SKILL.md"

if "$kit_root/scripts/install.sh" "$test_root/project" >/dev/null 2>&1; then
  printf '%s\n' 'Expected conflict detection to fail.' >&2
  exit 1
fi

"$kit_root/scripts/install.sh" --force --app-name "ExampleApp" "$test_root/project" >/dev/null
test -f "$test_root/project/.ios-app-agent-kit-backup"/*/AGENTS.md

printf '%s\n' 'Installer tests: PASS'
