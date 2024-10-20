
require 'rainbow'
require 'langchain'
require 'net/http'
require 'fileutils'
require 'dotenv'
require 'dotenv/load'

# These go before the requires..
ENABLE_GEMINI ||= ENV.fetch('ENABLE_GEMINI', 'tRue').downcase == 'true'
GEMINI_MODEL ||= ENV.fetch('GEMINI_MODEL', 'gemini-1.5-pro')
# Require them all
require_relative '../lib/gemini/translator'
require_relative '../lib/hugo/filesystem_iterator'
