#!/usr/bin/env ruby


require_relative '../lib/importz'

ENABLE_GEMINI ||= ENV.fetch('ENABLE_GEMINI', 'tRue').downcase == 'true'
OVERWRITE_FILES ||= ENV.fetch('OVERWRITE_FILES', 'fAlse').downcase == 'true'
MAX_ARTICLES ||= ENV.fetch('MAX_ARTICLES', '100000').to_i # == 'true'

# Input folder
input_folder = 'doc/posts'

# Hugo Blog Extensions and languages
#extensions = ['zzo', 'papermod', 'ananke']
extensions = ['zzo']

#languages = ['en', 'it', 'fr', 'de]
#languages = ['it', 'fr']
languages = ['it']

many_articles = MAX_ARTICLES > 5

puts("=" * 80)
puts(Rainbow("OVERWRITE_FILES: #{OVERWRITE_FILES}\t(#{OVERWRITE_FILES ? 'unsafe' : 'safe'})").send( OVERWRITE_FILES ? :red : :green))
puts(Rainbow("ENABLE_GEMINI:   #{ENABLE_GEMINI}\t(#{ENABLE_GEMINI ? 'Slow' : 'blazing-fast'})").send( ENABLE_GEMINI ? :red : :green))
puts(Rainbow("MAX_ARTICLES:    #{MAX_ARTICLES}\t(#{many_articles ? 'Production' : 'few for debugging (dev)'})").send( many_articles ? :green : :yellow))
puts("=" * 80)

iterate_through(input_folder:, extensions:, languages:, overwrite: OVERWRITE_FILES, max_articles: MAX_ARTICLES)

# raise "Exiting so i dont write stuff.."
#   exit -1
