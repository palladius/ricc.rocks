
require 'rainbow'
require 'langchain'
require 'net/http'
require 'fileutils'
require 'dotenv'
require 'dotenv/load'

# These go before the requires..
ENABLE_GEMINI ||= ENV.fetch('ENABLE_GEMINI', 'tRue').downcase == 'true'
GEMINI_MODEL ||= ENV.fetch('GEMINI_MODEL', 'gemini-1.5-pro')
GEMINI_API_KEY ||= ENV.fetch('GEMINI_API_KEY', nil).to_s

raise "no ENV[GEMINI_API_KEY]!!" if GEMINI_API_KEY.nil?

# Require them all
require_relative '../lib/gemini/languages'
require_relative '../lib/gemini/translator'
require_relative '../lib/hugo/filesystem_iterator'
require_relative '../lib/hugo/local_to_hugo_repo_mover'
require_relative '../lib/hugo/string'

def deb(str)
  puts("[DEB] #{str}") if $DEBUG
end
