

# TODO(rocc): explain what is overwrite
##
##
# DryRun. If enabled, doesnt copy files, doesnt do Gemini translation but it does creat folders.
def iterate_through(input_folder:, extensions:, languages:, overwrite_existing_out_file: false, max_articles: , restrict_src_path_by_regex: , out_dir: , dry_run: false)
  puts("* INPUT: input_folder:    #{input_folder}")
  puts("* INPUT: restrict_src_path_by_regex: #{restrict_src_path_by_regex}")
  puts("iterate_through() DRYRUN enabled! ") if dry_run
  #exit 42
  n_articles = 0
  n_articles_errors = 0
  # Iterate through each extension and language
  extensions.each do |extension|
    languages.each do |lang|
      # Create output folder
      output_folder = "#{out_dir}/#{extension}/#{lang}/"
      FileUtils.mkdir_p(output_folder)

      # Iterate through input files
      Dir.glob("#{input_folder}/**/*").each do |file|
        # Skip markdown files and directories
        next if File.directory?(file)

        # Determine output file path
        output_file = output_folder + file.gsub(input_folder, '')

        # Create output directory if needed
        FileUtils.mkdir_p(File.dirname(output_file))

        # Geminizing the file
        if file.end_with?('.md')
          #puts("TODO check the MD5 of the source file to see if it has changed. Wait, credo lo faccia gia semplicemente cambiando il nome del cache file.. l unico problema e trovare cache duplicates..")
          if File.exist?(output_file) and (not overwrite_existing_out_file)
            puts(Rainbow("Output File exists ('#{output_file}') and overwrite_existing_out_file=false => skipping Geminization").darkslategray)
          else
            # Exit if too many files.
            if n_articles >= max_articles
              puts("[ERROR] Max Articles reached (#{n_articles}) - refusing to use Gemini on #{file}")
              break
            end
            # Normal flow: Gemini is ON! :)
            deb("Either OutputFile '#{Rainbow(output_file).purple}' doesnt exist or overwrite_existing_out_file=false => doing Geminization!!")
            # Call your Gemini function (replace with your actual implementation)
#            translate_with_gemini(file_name: file, extension:, lang:, output_file: , overwrite_existing_out_file:)
            begin
              # Call your Gemini function (replace with your actual implementation)
              if dry_run
                puts("[DRYRUN] Skipping translate for #{file}")
              else
                translate_with_gemini(file_name: file, extension:, lang:, output_file:)
              end
              n_articles += 1
            rescue StandardError => e  # Catch any StandardError
              n_articles_errors += 1
              puts Rainbow("🙈 Error processing file '#{file}': #{e.message}").red
              # Optionally, you can log the error to a file or error tracking service
              #  Logger.error("Error processing file '#{file}': #{e.message}")
              #  # Or use your preferred logging mechanism
              # Re-raise the exception if you want to halt execution
              # raise e
            end
            #n_articles += 1
          end
        else
          # Copy file to output folder
          deb("NOT MD => just copying #{file} to #{output_file}..")
          FileUtils.cp(file, output_file) unless dry_run
        end
      end
    end
  end

  puts("#Articles ✅ correctly parsed: #{n_articles}")
  puts("#Articles 🙈 with errors: #{n_articles_errors}")

end
