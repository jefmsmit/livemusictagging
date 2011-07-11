class RemoveFilesCommand

  def initialize(pattern, exclude_pattern)
    @pattern = pattern
    @exclude_pattern = exclude_pattern
  end

  def execute?
    all_files = Dir.glob(@pattern) # duplication here with the md5 checker
    excludes = @exclude_pattern ? Dir.glob(@exclude_pattern) : []
    files = []

    puts("Removing files that match #{@pattern} but not #{@exclude_pattern}")
    all_files.each do |file|
      files.push(file) unless excludes.member?(file)
    end

    files.each do |file|
      File.delete(file)
    end
  end

end
