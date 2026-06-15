# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


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
