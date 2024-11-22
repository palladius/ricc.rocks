# Learn more about building any generic provider: https://promptfoo.dev/docs/providers/custom-script

# Anything printed to standard output will be captured as the output of the provider

echo "This is the LLM output"

# You can also call external scripts or executables
#php my_script.php

echo "ARGV: $*"

echo OVERWRITE_EXISTING_OUT_FILES=TRUE INPUT_SUBFOLDER='original-work/life/learning-german-in-zurich' LANGUAGES=jp ruby bin/build-all.rb

echo TODO add params argv from promptfoo into this script
