class FlacFileListFactory

  def initialize(executor)
    @executor = executor
  end

  def flac_file_list
    fetcher = FlacFileFetcher.new
    command = RemoveFilesCommand.new("*.md5", "*wav*.md5")

    if not Dir.glob("*.flac").empty?
      CurrentDirectoryFlacFileList.new(MD5Checker.new("*.md5", "*wav*.md5"), fetcher, command)
    elsif not Dir.glob("*.shn").empty?
      CurrentDirectoryShnToWaveToFlacFileList.new(MD5Checker.new("*.md5", "*wav*.md5"), @executor)
    else
      []
    end
  end

end
