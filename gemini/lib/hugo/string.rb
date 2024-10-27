
class String
  def inject_in_front_matter(comment)
    if self =~ /---\n/
      self.sub!(/---\n/, "---\n#{comment}\n")
    else
      raise "No front matter found in the string."
    end
    self
  end
end
