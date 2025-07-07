# Netlify build issue
Investigated the cause of Netlify build failures for the zzo.ricc.rocks site.  The issue was related to an update to the hugo-bootstrap-theme submodule.  Attempted to revert to a specific commit (c938be0) but it was not found in the submodule's history. Updated the submodule to the latest commit on main instead.

## Bug in google_analytics_async.html
