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

Read the installed `AGENTS.md` and `docs/AI_DRIVEN_DEVELOPMENT.md` completely before deciding whether to delegate. The main agent is the default executor.

- Keep 1–3 file changes, simple fixes, small UI changes, and short documentation updates in the main agent when it already has the needed context.
- Delegate only when parallelism, context isolation, specialist review, or an independent high-risk QA pass clearly outweighs rereading and coordination costs.
- Give agents only the necessary files, goal, constraints, and completion evidence; never ask them to relearn the whole repository.
- Keep concurrent subagents to 2–3 by default and do not parallelize dependent work.
- Route product ambiguity to `concept_engineer` or `product_design_engineer` only when separating that work adds value.
- Route independent or long-running codebase mapping to `ios_explorer`.
- Use `ios_architecture_engineer` for a bounded architecture document when persistence, StoreKit, notifications, or migration design needs separation.
- Give one clearly bounded implementation slice to `ios_implementation_engineer` only when it can work independently.
- Use `qa_engineer` for data loss, date calculations, notifications, persistence, migration, purchases, authentication, multi-screen changes, major refactors, or explicit independent review requests. The main agent may validate low-risk changes itself.
- Add `security_privacy_engineer` when data, permissions, networking, third-party SDKs, logging, or purchases change.
- Use `app_store_release_engineer` only after QA and privacy gates pass.
- Use `growth_marketing_engineer` for accurate release messaging and measurable distribution plans.

Never assign the same file to multiple write agents at the same time. Work in the user's current checkout by default; do not automatically create a worktree or another directory. If the current checkout cannot safely accommodate the work, explain why and ask the user how to proceed. External posts, App Store Connect writes, uploads, submissions, invitations, and release actions require explicit authorization in the current request.
