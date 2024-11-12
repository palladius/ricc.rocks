#!/bin/bash



alias promptfoo='/usr/local/google/home/ricc/git/py-pvt-gemini-chat-challenge/genai-training/vertex-eval/deepeval/genai-beyond-basics/samples/evaluation/node_modules/.bin/promptfoo'
export PATH=$PATH:/usr/local/google/home/ricc/git/py-pvt-gemini-chat-challenge/genai-training/vertex-eval/deepeval/genai-beyond-basics/samples/evaluation/node_modules/.bin/

export PROMPTFOO_PROMPT_SEPARATOR='-A-A-A-'
export VERTEX_PROJECT_ID='ricc-genai'
export PORT=11434
export OLLAMA_HOST=":$PORT"
# Su derek con va con localhost :(
export OLLAMA_BASE_URL="http://127.0.0.1:$PORT"
#export REQUEST_TIMEOUT_MS='20000'
# export OPENAI_API_KEY .. nope

#	promptfoo eval ; promptfoo view
# this is not ok since i have --- in the ptompt! so i have to make a new spearator, like '-A-A-A-' :)
#	PROMPTFOO_PROMPT_SEPARATOR='-A-A-A-' promptfoo eval ; promptfoo view

echo "------------------------------------------------------------"
echo "$0 - $@"
echo "VERTEX_PROJECT_ID=$VERTEX_PROJECT_ID"
echo "OLLAMA_BASE_URL=$OLLAMA_BASE_URL"
echo "OLLAMA_HOST=$OLLAMA_HOST"
echo "PROMPTFOO_PROMPT_SEPARATOR=$PROMPTFOO_PROMPT_SEPARATOR"
echo "REQUEST_TIMEOUT_MS=${REQUEST_TIMEOUT_MS}ms"
echo "PORT=$PORT"
#echo "ollama version=`ollama --version`"
echo "promptfoo version=`promptfoo --version`"
echo "------------------------------------------------------------"

promptfoo eval
promptfoo view
