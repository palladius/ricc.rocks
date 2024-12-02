#!/bin/bash

echo You need to authenticate to gcloud first..
gcloud config set project ricc-genai
# https://www.promptfoo.dev/docs/guides/gemini-vs-gpt/
export VERTEX_PROJECT_ID=ricc-genai
export PROJECT_ID=ricc-genai
export PROMPTFOO_PROMPT_SEPARATOR='-A-A-A-'
promptfoo eval ; promptfoo view
