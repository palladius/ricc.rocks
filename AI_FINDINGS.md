# Netlify build issue
Investigated the cause of Netlify build failures for the zzo.ricc.rocks site.  The issue was related to an update to the hugo-bootstrap-theme submodule.  Attempted to revert to a specific commit (c938be0) but it was not found in the submodule's history. Updated the submodule to the latest commit on main instead.

## Bug in google_analytics_async.html
**FIXED (2026-01-14)**: The zzo2 theme was referencing the deprecated `_internal/google_analytics_async.html` template which was removed in Hugo v0.128+. Fixed by removing the deprecated line from `themes/zzo2/layouts/partials/service/google-analytics.html`. The site now builds successfully with Hugo v0.150.1.

## New Blog Article: AI-Powered SRE (2026-01-14)
Created a new blog article about using Gemini CLI and Antigravity for SRE work. The article documents a real-world case of troubleshooting Netlify build failures for the rubycon.it site. Article location: `zzo.ricc.rocks/content/en/posts/medium/2026-01-14-troubleshooting-cloud-build-with-gemini-cli/index.md`. Title chosen: "AI-Powered SRE: How Gemini CLI Saved My Netlify Build" - more engaging than the original working title. Build tested successfully.
