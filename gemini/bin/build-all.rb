#!/usr/bin/env ruby


require_relative '../lib/importz'
require 'dotenv/load'

ENABLE_GEMINI ||= ENV.fetch('ENABLE_GEMINI', 'tRue').downcase == 'true'
OVERWRITE_FILES ||= ENV.fetch('OVERWRITE_FILES', 'fAlse').downcase == 'true'
MAX_ARTICLES ||= ENV.fetch('MAX_ARTICLES', '100000').to_i # == 'true'
GEMINI_MODEL ||= ENV.fetch('GEMINI_MODEL', 'gemini-1.5-pro')
GEMINI_API_KEY ||= ENV.fetch('GEMINI_API_KEY', nil).to_s
PROJECT_ID ||= ENV.fetch('PROJECT_ID', nil).to_s

raise "no ENV[GEMINI_API_KEY]!!" if GEMINI_API_KEY.nil?

# Input folder
input_folder = 'doc/posts'

# Hugo Blog Extensions and languages
#extensions = ['zzo', 'papermod', 'ananke']
extensions = ['zzo']

languages = ['it', 'fr', 'de']
#languages = ['it', 'fr']
#languages = ['it']

many_articles = MAX_ARTICLES > 5

puts("=" * 80)
puts(Rainbow("💾 OVERWRITE_FILES: #{OVERWRITE_FILES}\t(#{OVERWRITE_FILES ? 'unsafe' : 'safe'})").send( OVERWRITE_FILES ? :red : :green))
puts(Rainbow("📰 MAX_ARTICLES:    #{MAX_ARTICLES}\t(#{many_articles ? 'Production' : 'few for debugging (dev)'})").send( many_articles ? :green : :yellow))
puts(Rainbow("♊ ENABLE_GEMINI:   #{ENABLE_GEMINI}\t(#{ENABLE_GEMINI ? 'Slow' : 'blazing-fast'})").send( ENABLE_GEMINI ? :red : :green))
puts(Rainbow("♊ GEMINI_MODEL:    #{GEMINI_MODEL}\t(#{GEMINI_MODEL.match(/flash/) ? 'blazing-fast, approximative' : 'Slow and accurate'})").send( GEMINI_MODEL.match(/flash/) ? :yellow : :green))
#binding.pry
puts(Rainbow("♊ GEMINI_API_KEY:  #{GEMINI_API_KEY[0..5]}..\t(#{GEMINI_API_KEY.match(/^AIza/) ? 'seems legit' : 'incorrect'})").send( GEMINI_API_KEY.match(/^AIZa/) ? :green : :red))
puts(Rainbow("☁️  PROJECT_ID:      #{PROJECT_ID}").white)
puts("=" * 80)
# Run the import

#exit 42
iterate_through(input_folder:, extensions:, languages:, overwrite: OVERWRITE_FILES, max_articles: MAX_ARTICLES)

# raise "Exiting so i dont write stuff.."
#   exit -1
