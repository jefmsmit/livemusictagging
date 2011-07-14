class DiscAndTrackInfo

  def initialize(regex_builder, files)
    @discs_and_tracks = {}
    @file_to_disc = {}
    @file_to_track = {}

    files.each do |file|
      regex = regex_builder.regex
      file[Regexp.new(regex)]

      current_disc = $1.to_i
      raise "Could not find the disc number for #{file}" unless current_disc

      current_track = $2.to_i
      raise "Could not find the track number for #{file}" unless current_track

      @file_to_disc[file] = current_disc
      @file_to_track[file] = current_track
      @discs_and_tracks[current_disc] = current_track
    end
  end

  def disc_total
    @discs_and_tracks.size
  end

  def track_number(file)
    @file_to_track[file]
  end

  def disc_number(file)
    @file_to_disc[file]
  end

  def track_total(file)
    @discs_and_tracks[disc_number(file)]
  end

end
