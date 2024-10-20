


def iterate_through(input_folder:, extensions:, languages:, overwrite: false)

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
          if File.exist?(output_file) and (not overwrite)
            puts(Rainbow("Output File exists ('#{output_file}') and overwrite=false => skipping Geminization").darkslategray)
          else
            puts("Either OutputFile doesnt exist or overwrite=false => doing Geminization!!")
            # Call your Gemini function (replace with your actual implementation)
            translate_with_gemini(file_name: file, extension:, lang:, output_file: , overwrite:)
            #puts("result: #{ret}")
          end
        else
          # Copy file to output folder
          #puts("NOT MD = just copying #{file} to #{output_file}..")
          FileUtils.cp(file, output_file)
        end
      end
    end
  end

end
