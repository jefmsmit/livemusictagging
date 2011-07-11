class WavToFlacCommand

  def initialize(executor)
    @executor = executor
  end

  def execute?
    wavs = Dir.glob("*.wav")

    wavs.each do |file|
      puts("converting wav file #{file} to flac")
      status = @executor.execute("flac -8 #{file}")
      return status unless status
    end

    true
  end

end
