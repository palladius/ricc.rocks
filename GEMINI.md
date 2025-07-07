## Context

This git repo contains ALL my hugo Blogs, some of which in DEV some of which in PROD.
Each folder uses a different Hugo skin.

The only one in prod is:
* PROD: `zzo.ricc.rocks/`: a hugo website: `https://ricc.rocks/`
* ZZO theme is quite old, unfortunately: https://github.com/zzossig/hugo-theme-zzo , hasnt been updated in 4 years.


All repos are handled by Netlify, which means that when
* git commit + git push
* this trigger a Netlify build.
* If successful, it pushes a new version to a certain website, eg https://ricc.rocks/

## Structure

Most folders are one hugo website + theme

* `themes/` links to all themese I've tried so far. Every time I touch this folder, things tend to break.

## BUG

Currently, the ZZO is broken. This has to do with the fact that Hugo is unable to load correctly the Bootstrap Theme.

Solutions:
1. I would like you to be able to read Netlify logs programmatically. If this is possible, you can infer whats broken and fix it!
2. If not, i can paste you the error, and we try to fix it.

Another solution could be to check the last NON failed push from `zzo.ricc.rocks/NETLIFY_LOG.md`.
We can match that timestamp to identify the git commit which broke it.

## Persist findings

Whenever you do soem research and find anything (wether its a good thing or a cul de sac), write your findings
(succintly!) under `AI_FINDINGS.md`.
When you read this, you'll first read `AI_FINDINGS.md` to get up to speed, then update it with new findings.

## Feedback loop

* I will run `make run` under ZZO folder for you.which runs Hugo on port 1313.
* You can invoke commands like "curl http://localhost:1313/en/" ,
* or more complex endpoints like: "curl http://localhost:1313/en/posts/medium/2022-09-12-gcp-cb-trigger-with-pulumi-python/"
* Note that an article pointing to this URL: http://localhost:1313/en/posts/medium/2022-09-12-gcp-cb-trigger-with-pulumi-python/"
  can be found in files here: `zzo.ricc.rocks/content/en/posts/medium/2022-09-12-GCP-CB-trigger-with-pulumi-python`. So the
  mapping is quite deterministic.
