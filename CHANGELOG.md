# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## [0.2.6] - 2026-06-17

### 🧪 Refined (by Gemini/Antigravity)
- 🧪 Refined snippet-extracting logic in compliance tests to mirror Hugo's actual logic (`summary` frontmatter, `<!--more-->`, and 70-word fallback).
- 🚨 Added snippet word count similarity validation (10 to 120 words).
- 🔗 Correlated Medium links detection by parsing both frontmatter (`canonicalURL`/`medium-site`) and post content to check that the end of page points to the Medium article.

## [0.2.5] - 2026-06-17

### 🚨 Added (by Gemini/Antigravity)
- 🚨 Added failing compliance tests executed via `just test` (`cd zzo.ricc.rocks && just test`).
- 🧪 Implemented checks for ZZO post compliance rules defined in `TESTING.md` (no images in initial snippets, presence of valid `medium-site` frontmatter key).

## [0.2.4] - 2026-06-17

### 🔀 Merged (by Gemini/Antigravity)
- 🔀 Merged branch `origin/main` into local `main`. Resolved conflict in deleted file `content/en/posts/technology/2026-06-05-worktree-multiagent-dev-flow/index.md` by accepting the remote deletion since the article has been split and published as "Crescendo of Agents (Part 1 & Part 2)".

### ⚡ Fixed (by Gemini/Antigravity)
- ⚡ Fixed local development fallback commands in both `zzo.ricc.rocks/justfile` (`just dev`) and `zzo.ricc.rocks/Makefile` (`make run`/`make test`/`make build`) to use `npx -y hugo-extended` instead of standard `hugo-bin`. This ensures the SCSS/TOCSS templates compile successfully when a local global Hugo is not present.
- 🚀 Installed global `hugo` extended edition via Homebrew to support fast local dev builds.


## [0.2.3] - 2026-06-15


### 🔧 Added (by Gemini/Antigravity)
- 🔧 Added fallback support for `npx -y hugo-bin server` in `zzo.ricc.rocks/justfile` to make `just dev` work out of the box when `hugo` is not installed on the system.

### 🐛 Fixed (by Gemini/Antigravity)
- 🐛 Fixed YAML tags syntax error in `2026-06-05-worktree-multiagent-dev-flow/index.md` which was causing RSS generation to fail during site builds.

## [0.2.2] - 2026-06-15


### ✨ Added (by Gemini/Antigravity)
- 💼 Added a flashy "Portfolio" button to the top navigation bar pointing to the user's about page.
- 🔧 Added fallback support for `npx -y hugo-bin` in `zzo.ricc.rocks/Makefile` when `hugo` command is not locally installed.

### 🐛 Fixed (by Gemini/Antigravity)
- 🐛 Fixed several pre-existing Hugo compilation errors:
  - Resolved duplicate `description` keys in Madeira, Photo, Family, and Sport gallery pages.
  - Resolved duplicate `author`/`draft` keys in `math-typesetting.md` and `about-me/index.md`.
  - Fixed YAML tags syntax error in `2026-06-05-worktree-multiagent-dev-flow/index.md` which was causing RSS generation to fail.

## [0.2.1] - 2026-02-04

### Added
- New "Redux" Medium article: "How I coded a Rails 8 CFP app in 30m with Antigravity" (Simplified version of the previous tech post).

## [0.2.0] - 2026-01-25

### Added
- Minor version bump for Netlify migration (Build Image update & Prerendering removal).
- New Blog Article: "How I coded a Rails 8 CFP app in 30m with Antigravity".

## [0.1.0] - 2026-01-14

### ✨ Added (by Gemini/Antigravity)
- 📝 New blog article: "AI-Powered SRE: How Gemini CLI Saved My Netlify Build"
  - Location: `zzo.ricc.rocks/content/en/posts/medium/2026-01-14-troubleshooting-cloud-build-with-gemini-cli/`
  - Documents real-world use case of using Gemini CLI for SRE troubleshooting
  - Covers Netlify build failure resolution and sponsor management workflow
- 📋 Updated `AI_FINDINGS.md` with article creation details
- 🔧 Updated `blueprint.yaml` with prod_url reference

### 🐛 Fixed (by Gemini/Antigravity)
- 🔧 Fixed Hugo build error in zzo2 theme by removing deprecated `google_analytics_async.html` template reference
  - This template was removed in Hugo v0.128+ but zzo2 theme was still referencing it
  - Site now builds successfully with Hugo v0.150.1

### 🎯 Changed (by Gemini/Antigravity)
- 📚 Enhanced `GEMINI.md` with commit guidelines (gitmoji, VERSION, CHANGELOG)
