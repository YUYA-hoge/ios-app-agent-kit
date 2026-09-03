---
name: ios-app-agent-workflow
description: Install and coordinate a documentation-first, project-scoped Codex workflow for native iOS product discovery, requirements, architecture, SwiftUI implementation, QA, privacy, App Store release, and growth marketing. Use when starting a new iOS product, planning a feature, setting up this kit, or routing work across the installed iOS agents.
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

### Documentation-first gate

Do not begin product implementation until the project has an explicit written basis for the work.

- For a new product, create or complete the numbered documents in `docs/` in order, beginning with `00_INDEX.md` and `01_PRODUCT_CONCEPT.md`. Define the target user, problem, value, non-goals, differentiation, success signals, requirements, UX states, acceptance criteria, technical architecture, data model, roadmap, test/release approach, and open decisions before writing production code.
- Treat concept approval as the first gate. Do not infer a product concept from an implementation request or start scaffolding while the target user, problem, and value remain undefined.
- For a new feature or behavior change, update the existing authoritative requirements, UX, architecture/data, roadmap, test, and decision documents that are affected before implementation. Create a bounded execution plan when the installed rules require one.
- Mark statements as decided, provisional, or open. An open decision that changes product behavior, data safety, architecture, monetization, privacy, or release scope blocks implementation unless the user explicitly accepts a provisional choice.
- Write observable acceptance criteria and a validation plan before code changes. Documentation is not complete merely because files exist.
- A narrow bug fix, test-only change, refactor with no behavior change, or mechanical maintenance task may reuse existing documentation. Confirm that no specification changes are needed and record any discovered mismatch before continuing.
- Keep documents proportional to the product and reuse existing authoritative files instead of creating duplicates.

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
