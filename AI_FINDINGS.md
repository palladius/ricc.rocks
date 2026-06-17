# Netlify build issue
Investigated the cause of Netlify build failures for the zzo.ricc.rocks site.  The issue was related to an update to the hugo-bootstrap-theme submodule.  Attempted to revert to a specific commit (c938be0) but it was not found in the submodule's history. Updated the submodule to the latest commit on main instead.

## Bug in google_analytics_async.html
**FIXED (2026-01-14)**: The zzo2 theme was referencing the deprecated `_internal/google_analytics_async.html` template which was removed in Hugo v0.128+. Fixed by removing the deprecated line from `themes/zzo2/layouts/partials/service/google-analytics.html`. The site now builds successfully with Hugo v0.150.1.

## New Blog Article: AI-Powered SRE (2026-01-14)
Created a new blog article about using Gemini CLI and Antigravity for SRE work. The article documents a real-world case of troubleshooting Netlify build failures for the rubycon.it site. Article location: `zzo.ricc.rocks/content/en/posts/medium/2026-01-14-troubleshooting-cloud-build-with-gemini-cli/index.md`. Title chosen: "AI-Powered SRE: How Gemini CLI Saved My Netlify Build" - more engaging than the original working title. Build tested successfully.

## Netlify Deployment Failure Fix (2026-01-14)
**CRITICAL BUG FIXED**: Netlify deployments for ricc.rocks have been failing since the last successful deploy on commit `53a974c` (6:13 PM, 2026-01-14). All subsequent commits (`5ca7af5`, `3774014`, `b0899cd`) failed with "Build script returned non-zero exit code: 2".

**Root Cause**: 
1. The repo contains multiple Hugo sites (zzo, bootstrap, ananke, etc.) all sharing the same root `.gitmodules` file
2. Netlify site `ricc-zzo` (https://ricc.rocks) was building from the wrong directory or with incorrect configuration
3. Historical issues with submodule `hugo-bootstrap.ricc.rocks/themes/hugo-theme-bootstrap` causing checkout failures (see NETLIFY_LOG.md from June 2025)

**Fix Applied**:
Created `netlify.toml` at repo root with proper configuration:
- Build base: `zzo.ricc.rocks`
- Hugo version: `0.150.1`
- Build command: `hugo --minify`
- Publish directory: `public`

This isolates the ZZO site build from other sites' dependencies and ensures Netlify uses the correct Hugo version and build directory.

**Related**: GitHub issue #2 (https://github.com/palladius/ricc.rocks/issues/2)

## Portfolio Button and Hugo Build Fixes (2026-06-15)
**FIXED & ADDED (by Gemini/Antigravity)**:
1. **Added Portfolio Button**: Added a flashy "Portfolio" button to the top navbar (pointing to the about page: `https://portfolio-app-272932496670.europe-west1.run.app/about`) on both desktop and mobile views. Created layout overrides:
   - `zzo.ricc.rocks/layouts/partials/navbar/nav-menu.html`
   - `zzo.ricc.rocks/layouts/partials/navbar/nav-menu-mobile.html`
   - Injected custom styles under `zzo.ricc.rocks/assets/sass/custom.scss` with gradient, shadow glow, and hover transitions.
   - Updated menu files: `menus.en.yaml` and `menus.it.yaml`.
2. **Fixed Hugo Build Errors**:
   - Fixed duplicate `description` frontmatter keys in multiple gallery files (Madeira, Photo, Family, Sport).
   - Fixed duplicate `author` and `draft` keys in `math-typesetting.md` and `about-me/index.md`.
   - Fixed a critical frontmatter syntax issue in `2026-06-05-worktree-multiagent-dev-flow/index.md` where `Tags: worktree, Antigravity` was parsed as a single string, crashing the RSS templates. Changed to `Tags: [worktree, Antigravity]`.
3. **Makefile Fallback**: Updated `zzo.ricc.rocks/Makefile` to fallback to `npx -y hugo-bin` when standard `hugo` is not in the environment PATH.

## `just dev` fallback & Tags syntax fix (2026-06-15)
**UPDATED & FIXED (by Gemini/Antigravity)**:
1. **Added `just dev` Fallback**: Updated `zzo.ricc.rocks/justfile` to check for `hugo` in PATH first, and fallback to `npx -y hugo-bin server --disableFastRender` if it's not present. This prevents `hugo: command not found` errors.
2. **Re-applied YAML Tags fix**: Found that the frontmatter in `content/en/posts/technology/2026-06-05-worktree-multiagent-dev-flow/index.md` still contained `Tags: worktree, Antigravity` which caused build crashes. Corrected it to `Tags: [worktree, Antigravity]`. The site now builds successfully with `make test`.

## Git Merge Conflict Resolution (2026-06-17)
**RESOLVED (by Gemini/Antigravity)**:
- **Conflict Resolution**: Merged `origin/main` into local `main`. Resolved the conflict on `deleted by them: content/en/posts/technology/2026-06-05-worktree-multiagent-dev-flow/index.md` by accepting the deletion, since the post was reorganized and published in `origin/main` as "Crescendo of Agents (Part 1 & 2)".

