---
name: ios-app-agent-workflow
description: Install and coordinate a project-scoped Codex subagent team for native iOS product discovery, requirements, architecture, SwiftUI implementation, QA, privacy, App Store release, and growth marketing. Use when setting up this kit, planning an end-to-end iOS feature, or routing work across the installed iOS agents.
---

# iOS App Agent Workflow

Use this skill to install or operate the project-scoped iOS development team supplied by this plugin.

## Install into a project

1. Resolve the plugin root from this `SKILL.md` location.
2. Run `scripts/install.sh --dry-run --app-name <name> <target>` first.
3. Report conflicts without overwriting them.
4. Run without `--dry-run` only after the target and app name are known. Use `--force` only when the user explicitly authorizes replacement; the installer creates backups.
5. Tell the user to open a new Codex task rooted at the target repository so project configuration and custom agents are discovered.

## Coordinate feature work

Read the installed `AGENTS.md` and `docs/AI_DRIVEN_DEVELOPMENT.md` completely before delegating.

- Route product ambiguity to `concept_engineer` or `product_design_engineer`.
- Route codebase mapping to `ios_explorer`.
- Use `ios_architecture_engineer` for architecture, persistence, StoreKit, notifications, or migration changes.
- Give one bounded implementation slice to `ios_implementation_engineer`.
- Require independent `qa_engineer` verification after implementation.
- Add `security_privacy_engineer` when data, permissions, networking, third-party SDKs, logging, or purchases change.
- Use `app_store_release_engineer` only after QA and privacy gates pass.
- Use `growth_marketing_engineer` for accurate release messaging and measurable distribution plans.

Never assign the same file to multiple write agents at the same time. Use separate worktrees for parallel code edits. External posts, App Store Connect writes, uploads, submissions, invitations, and release actions require explicit authorization in the current request.
