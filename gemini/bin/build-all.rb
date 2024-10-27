#!/usr/bin/env ruby


require_relative '../lib/importz'
require 'dotenv/load'

DEFAULT_LANGUAGES='it' # could be it,es,..

ENABLE_GEMINI ||= ENV.fetch('ENABLE_GEMINI', 'tRue').downcase == 'true'
OVERWRITE_EXISTING_OUT_FILES ||= ENV.fetch('OVERWRITE_EXISTING_OUT_FILES', 'fAlse').downcase == 'true'
MAX_ARTICLES ||= ENV.fetch('MAX_ARTICLES', '100000').to_i # == 'true'
GEMINI_MODEL ||= ENV.fetch('GEMINI_MODEL', 'gemini-1.5-pro')
GEMINI_API_KEY ||= ENV.fetch('GEMINI_API_KEY', nil).to_s
PROJECT_ID ||= ENV.fetch('PROJECT_ID', nil).to_s
LANGUAGES ||= ENV.fetch('LANGUAGES', DEFAULT_LANGUAGES ).to_s
RESTRICT_SRC_PATH_BY_REGEX ||= ENV.fetch('RESTRICT_SRC_PATH_BY_REGEX', nil)
INPUT_FOLDER ||= ENV.fetch('INPUT_FOLDER', nil) # 'src/posts'
OUTPUT_FOLDER ||= ENV.fetch('OUTPUT_FOLDER', 'out') # 'out/'
raise "no ENV[GEMINI_API_KEY]!!" if GEMINI_API_KEY.nil?

# Input folder
#input_folder = 'doc/posts'
raise "Give me an ENV[INPUT_FOLDER]!! For instance src/posts. this is a campaign to sensibilize Riccardo on making this explicit in ENV" unless INPUT_FOLDER

# Hugo Blog Extensions and languages
#extensions = ['zzo', 'papermod', 'ananke']
extensions = ['zzo']


#languages = ['it', 'fr', 'de', 'jp']
#languages = ['jp'] # some error
#languages = ['it', 'fr']
#languages = ['it']
languages = LANGUAGES.split(',')

many_articles = MAX_ARTICLES > 5

puts("=" * 80)
puts(Rainbow("💾 OVERWRITE_EXISTING_OUT_FILES: #{OVERWRITE_EXISTING_OUT_FILES}\t(#{OVERWRITE_EXISTING_OUT_FILES ? 'unsafe' : 'safe'})").send( OVERWRITE_EXISTING_OUT_FILES ? :red : :green))
puts(Rainbow("📰 MAX_ARTICLES:    #{MAX_ARTICLES}\t(#{many_articles ? 'Production' : 'few for debugging (dev)'})").send( many_articles ? :green : :yellow))
puts(Rainbow("♊ ENABLE_GEMINI:   #{ENABLE_GEMINI}\t(#{ENABLE_GEMINI ? 'Slow' : 'blazing-fast'})").send( ENABLE_GEMINI ? :red : :green))
puts(Rainbow("♊ GEMINI_MODEL:    #{GEMINI_MODEL}\t(#{GEMINI_MODEL.match(/flash/) ? 'blazing-fast, approximative' : 'Slow and accurate'})").send( GEMINI_MODEL.match(/flash/) ? :yellow : :green))
#binding.pry
puts(Rainbow("♊ GEMINI_API_KEY:  ..#{GEMINI_API_KEY[-5..-1]}\t(#{GEMINI_API_KEY.match(/^AIza/) ? 'seems legit' : 'incorrect'})").send( GEMINI_API_KEY.match(/^AIZa/) ? :green : :red))
puts(Rainbow("☁️  PROJECT_ID:      #{PROJECT_ID}").white)
puts(Rainbow("🇬🇵 LANGUAGES:      [array] #{languages.join ', '}").white)
puts(Rainbow("🇬🇵 INPUT_FOLDER:   #{INPUT_FOLDER}").cyan)
puts(Rainbow("🇬🇵 OUTPUT_FOLDER:   #{OUTPUT_FOLDER}").cyan)
puts(Rainbow("🇬🇵 RESTRICT_SRC_PATH_BY_REGEX:[str/nil] #{RESTRICT_SRC_PATH_BY_REGEX}").green)

puts("=" * 80)

#exit 42

# Run the import
# 1. Call gemini
iteration_results = iterate_through(input_folder: INPUT_FOLDER, extensions:, languages:, overwrite_existing_out_file: OVERWRITE_EXISTING_OUT_FILES, max_articles: MAX_ARTICLES, restrict_src_path_by_regex: RESTRICT_SRC_PATH_BY_REGEX, out_dir: OUTPUT_FOLDER)

n_errors = iteration_results[:n_articles_errors]

puts('--')
#puts("Atrticle errors in total: #{n_errors}")

if n_errors == 0
  puts("🍀 All good, we can now move to the next step")
  copy_files_to_enabled_extensions(extensions: , languages: , out_dir: OUTPUT_FOLDER)
else
  puts("🆑 Article errors in total: #{n_errors}")
  puts("Sorry, Pallybboy: fix the errors first!")
  exit(-1)
end

puts("🍀 Done!")
