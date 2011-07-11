class FlacTagBuilder
  SET_TAG_PREFIX = "--set-tag="

  def initialize
    @args = ""
  end

  def arguments
    @args
  end

  def add_description(desc)
    add_argument("DESCRIPTION", desc)
    self
  end

  def add_title(title)
    add_argument("TITLE", title)
    self
  end

  def add_artist(artist)
    add_argument("ARTIST", artist)
    self
  end

  def add_album(album)
    add_argument("ALBUM", album)
    self
  end

  def add_date(date)
    add_argument("DATE", date)
    self
  end

  def add_genre(genre)
    add_argument("GENRE", genre)
    self
  end

  def add_disc_total(total)
    add_argument("DISCTOTAL", total)
    self
  end

  def add_track_number(number)
    add_argument("TRACKNUMBER", number)
    self
  end

  def add_disc_number(number)
    add_argument("DISCNUMBER", number)
    self
  end

  def add_track_total(total)
    add_argument("TRACKTOTAL", total)
    self
  end

  private

  def add_argument(tag_name, value)
    @args += " #{SET_TAG_PREFIX}#{tag_name}=\"#{value}\""
  end

end
