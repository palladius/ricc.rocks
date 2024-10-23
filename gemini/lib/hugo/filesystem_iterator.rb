


def iterate_through(input_folder:, extensions:, languages:, overwrite: false, max_articles: )

  n_articles = 0
  n_articles_errors = 0
  # Iterate through each extension and language
  extensions.each do |extension|
    languages.each do |lang|
      # Create output folder
      output_folder = "out/#{extension}/#{lang}/"
      FileUtils.mkdir_p(output_folder)

      # Iterate through input files
      Dir.glob("#{input_folder}/**/*").each do |file|
        # Skip markdown files and directories
  #      next if file.end_with?('.md') || File.directory?(file)
        next if File.directory?(file)

        # Determine output file path
        output_file = output_folder + file.gsub(input_folder, '')

        # Create output directory if needed
        FileUtils.mkdir_p(File.dirname(output_file))

        # Geminizing the file
        if file.end_with?('.md')
          puts("TODO check the MD5 of the source file to see if it has changed. Wait, credo lo faccia gia semplicemente cambiando il nome del cache file.. l unico problema e trovare cache duplicates..")
          if File.exist?(output_file) and (not overwrite)
            puts(Rainbow("Output File exists ('#{output_file}') and overwrite=false => skipping Geminization").darkslategray)
          else
            # Exit if too many files.
            if n_articles >= max_articles
              puts("[ERROR] Max Articles reached (#{n_articles}) - refusing to use Gemini on #{file}")
              break
            end
            # Normal flow: Gemini is ON! :)
            puts("Either OutputFile '#{output_file}' doesnt exist or overwrite=false => doing Geminization!!")
            # Call your Gemini function (replace with your actual implementation)
#            translate_with_gemini(file_name: file, extension:, lang:, output_file: , overwrite:)
            begin
              # Call your Gemini function (replace with your actual implementation)
              translate_with_gemini(file_name: file, extension:, lang:, output_file:, overwrite:)
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
          #puts("NOT MD = just copying #{file} to #{output_file}..")
          FileUtils.cp(file, output_file)
        end
      end
    end
  end

  puts("#Articles ✅ correctly parsed: #{n_articles}")
  puts("#Articles 🙈 with errors: #{n_articles_errors}")

end
