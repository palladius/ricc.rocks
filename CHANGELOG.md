# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## [0.4.1] - 2026-07-05

### Fixed (by Gemini/Antigravity)
- 🐛 Fixed Google Search indexing 404 bugs:
  - Added Netlify redirect rules in `zzo.ricc.rocks/static/_redirects` to redirect old Redux posts, missing `index.json`, and deleted multilingual pages / tag queries.
  - Corrected relative social links for `youtube` and `google-plus` in `params.yaml` to avoid relative link generation.
  - Cleaned up broken relative markdown links in blog posts (`GEMINI.md` and `import-yaml.ts`).

## [0.4.0] - 2026-07-03

### ✨ Added (by Gemini/Antigravity)
- 🪨 Introduced "wikimoji" link icons framework:
  - Created [wikimoji.yaml](file:///usr/local/google/home/ricc/git/ricc.rocks/zzo.ricc.rocks/data/wikimoji.yaml) to centrally map URL domains to emojis and SVG icons.
  - Implemented [render-link.html](file:///usr/local/google/home/ricc/git/ricc.rocks/zzo.ricc.rocks/layouts/_default/_markup/render-link.html) Markdown render hook.
  - Added CSS styles in [custom.scss](file:///usr/local/google/home/ricc/git/ricc.rocks/zzo.ricc.rocks/assets/sass/custom.scss) for icon alignment.
- 💼 Configured custom emojis/icons for GitHub (SVG icon), LinkedIn (💼), Medium (SVG icon), YouTube (🎥), Twitter/X (🐦), Google Cloud (☁️), and internal links (🪨).
- 🧹 Removed manually added rock emojis from article markdown files to rely completely on the new automated framework.

## [0.3.1] - 2026-06-17

### 🔧 Fixed (by Gemini/Antigravity)
- 🔧 Replaced `medium-site` with `canonicalURL` in the frontmatter of `2022-11-09-mac-battery-on-gcp.md`.
- 🐛 Fixed trailing parenthesis in canonical URL and body footer link for the same post.

## [0.3.0] - 2026-06-17

### 🧪 Refined (by Gemini/Antigravity)
- 🧪 Made Medium article compliance validation (Rule 2) trigger conditionally only if the post is tagged with `#medium` or `medium`.
- 🗑️ Removed the requirement for `canonicalURL: absent` frontmatter on non-Medium posts, avoiding frontmatter metadata clutter.

## [0.2.9] - 2026-06-17

### 🔧 Added (by Gemini/Antigravity)
- 🔧 Added `just test-page <path>` target to both root and `zzo.ricc.rocks/` justfiles.
- 🧪 Updated `compliance_test.rb` to support testing individual specified files passed via command line arguments, resolving paths dynamically.

## [0.2.8] - 2026-06-17

### 🧪 Refined (by Gemini/Antigravity)
- 🧪 Swapped `medium-site` frontmatter key check with the standard Hugo `canonicalURL` key for Medium article compliance checks.
- ⏪ Reverted all post modifications to keep original files unmodified (relying on failing tests directly on their current state).

## [0.2.7] - 2026-06-17

### 🔧 Fixed (by Gemini/Antigravity)
- 🔧 Aligned existing post frontmatter and content to conform with [TESTING.md](file:///usr/local/google/home/ricc/git/ricc.rocks/zzo.ricc.rocks/TESTING.md) rules (added `medium-site`, footer links, and `summary` metadata where needed).
- 🚨 Intentionally left exactly 3 posts failing to demonstrate compliance test execution.

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
