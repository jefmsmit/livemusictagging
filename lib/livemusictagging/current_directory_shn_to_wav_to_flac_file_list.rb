class CurrentDirectoryShnToWaveToFlacFileList

  def initialize(md5checker, executor)
    puts "We must have shn files..."
    @md5checker = md5checker
    @executor = executor
  end

  def valid?
    if(@md5checker.valid?)
      return CompoundCommand.new(
        [ ShnToWavCommand.new(@executor, MD5Checker.new("*wav*.md5", nil)),
          WavToFlacCommand.new(@executor),
          RemoveFilesCommand.new("*.wav", nil),
          RemoveFilesCommand.new("*.md5", "*wav*.md5")]
      ).execute?
    end
    false
  end

  def flac_files
    command = RemoveFilesCommand.new("*.md5", "*wav*.md5")
    CurrentDirectoryFlacFileList.new(nil, FlacFileFetcher.new, command).flac_files #nil here because there won't be an md5 file for flacs we created
  end

end
