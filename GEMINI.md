## Context

This git repo contains ALL my hugo Blogs, some of which in DEV some of which in PROD.
Each folder uses a different Hugo skin.

The only one in prod is:
* PROD: `zzo.ricc.rocks/`: a hugo website: `https://ricc.rocks/`


All repos are handled by Netlify, which means that when
* git commit + git push
* this trigger a Netlify build.
* If successful, it pushes a new version to a certain website, eg https://ricc.rocks/

## BUG

Currently, the ZZO is broken.

Solutions:
1. I would like you to be able to read Netlify logs programmatically. If this is possible, you can infer whats broken and fix it!
2. If not, i can paste you the error, and we try to fix it.
