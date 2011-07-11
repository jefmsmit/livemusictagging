class FlacFileFetcher

  def fetch
    Dir.glob("*.flac")
  end

end