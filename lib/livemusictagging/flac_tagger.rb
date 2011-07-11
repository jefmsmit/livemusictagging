class FlacTagger

  def initialize(files, source_info, disc_and_track_info, song_name_fetcher, tag_writer)
    @files = files
    @source_info = source_info
    @disc_and_track_info = disc_and_track_info
    @song_name_fetcher = song_name_fetcher
    @tag_writer = tag_writer
  end

  def write_tags(artist, date, location, venue)
    source = @source_info.source_info

    @files.each do |file|
      builder = FlacTagBuilder.new
      builder.add_description(source).
        add_title(@song_name_fetcher.song_name(file)).
        add_artist(artist).
        add_album(build_album_string(date, location, venue)).
        add_date(date.strftime('%Y')).
        add_genre("Rock").
        add_disc_total(@disc_and_track_info.disc_total).
        add_track_number(@disc_and_track_info.track_number(file)).
        add_disc_number(@disc_and_track_info.disc_number(file)).
        add_track_total(@disc_and_track_info.track_total(file))

      @tag_writer.write_tags(file, builder)
    end
  end

  def build_album_string(date, location, venue)
    "#{date.strftime('%Y/%m/%d')} #{location} - #{venue}"
  end

end
