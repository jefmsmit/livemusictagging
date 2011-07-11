class FilePatternRegexBuilder

  def initialize(date, starting_pattern)
    @starting_pattern = starting_pattern
    @date = date
  end

  def regex
    pattern = @starting_pattern.sub("{d}", "(\\d)")
    pattern.sub("{t}", "(\\d+)")
  end

end
