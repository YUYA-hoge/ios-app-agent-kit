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
test "$(find "$test_root/project/.codex/agents" -name '*.toml' | wc -l | tr -d ' ')" = "9"
grep -q 'ExampleApp' "$test_root/project/AGENTS.md"
! grep -R -q '{{APP_NAME}}' "$test_root/project"

if "$kit_root/scripts/install.sh" "$test_root/project" >/dev/null 2>&1; then
  printf '%s\n' 'Expected conflict detection to fail.' >&2
  exit 1
fi

"$kit_root/scripts/install.sh" --force --app-name "ExampleApp" "$test_root/project" >/dev/null
test -f "$test_root/project/.ios-app-agent-kit-backup"/*/AGENTS.md

printf '%s\n' 'Installer tests: PASS'
