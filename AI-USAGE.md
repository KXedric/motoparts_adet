# AI usage

**Last updated:** 2026-10-15

## Authorship declaration

I made the first commits and the very early versions of this application myself. After that initial work, I heavily used ChatGPT to help implement the other parts of the application. AI assistance was a substantial part of later development, and I do not claim that all of the final code was written independently by me.

This is a retrospective disclosure. Git history records code changes, but does not establish the exact boundary between my work and AI output. Original prompts, responses, and individual acceptance decisions are not recorded here, so this document does not claim a verified per-prompt history or a precise percentage of independently written code.

## 1. How I used AI

I used ChatGPT heavily for later application implementation. These commits identify implementation areas for review. They are code references, not evidence that each commit represents a separate ChatGPT conversation or that every line was AI-generated.

| Date | Implementation area | Commit |
| --- | --- | --- |
| 2026-10-04 | Motorcycle, part, and maintenance models | [6e48c4e](https://github.com/KXedric/motoparts_adet/commit/6e48c4e) |
| 2026-10-04 | Local Hive persistence | [506a71b](https://github.com/KXedric/motoparts_adet/commit/506a71b) |
| 2026-10-04 | Inventory and maintenance providers | [058eb80](https://github.com/KXedric/motoparts_adet/commit/058eb80) |
| 2026-10-04 | Design system and shared components | [4f6a4ec](https://github.com/KXedric/motoparts_adet/commit/4f6a4ec) |
| 2026-10-04 | Parts inventory and editor | [d754638](https://github.com/KXedric/motoparts_adet/commit/d754638) |
| 2026-10-04 | Motorcycle profile and maintenance | [d9bbffd](https://github.com/KXedric/motoparts_adet/commit/d9bbffd) |
| 2026-10-04 | Dashboard overview | [45f35d6](https://github.com/KXedric/motoparts_adet/commit/45f35d6) |
| 2026-10-04 | Navigation and startup | [511178d](https://github.com/KXedric/motoparts_adet/commit/511178d) |

On 2026-10-15, I also used the ChatGPT/Codex coding assistant to complete this disclosure and the security document. It inspected source code, configuration, and Git history, and included my statement about early independent development and later heavy ChatGPT use. A commit reference for this documentation update will exist once it is committed.

## 2. Where the AI got it wrong

Specific historical examples of incorrect ChatGPT output and corresponding fixes have not been supplied or preserved in this record. This does not mean the AI was always correct. Existing changes cannot honestly be attributed to AI mistakes from commit messages alone.

This section still needs three actual examples from my development experience: what ChatGPT gave me, why it was wrong, what I changed, and the relevant fix commit. The retrospective record does not yet satisfy that evidence requirement.

## 3. Who wrote what

### Written by me

I created the first commits and the very early versions myself, before relying heavily on ChatGPT for subsequent implementation. The repository starts with the [initial commit on 2026-09-29](https://github.com/KXedric/motoparts_adet/commit/4091a9f). This identifies the beginning of the history; it does not establish authorship of every template file.

The exact files and commits that delimit my early independent application work have not yet been identified in this record. A claim that I independently wrote at least a fifth of the final project requires that additional evidence.

### Later implementation with AI assistance

ChatGPT contributed substantially to later implementation. The commits above identify the model, storage, provider, UI, and startup code for review, without claiming line-by-line authorship.

For example, `lib/services/hive_service.dart` centralizes opening the three Hive boxes and reading, saving, and deleting local records. Providers use it to manage application state. This explains the code's current role; my personal account of the AI-assisted code I understand best still needs to be recorded.

ChatGPT was used during development. The application itself does not call ChatGPT or require an OpenAI API key at runtime.
