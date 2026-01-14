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
