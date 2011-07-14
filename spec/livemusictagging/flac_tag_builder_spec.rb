require 'spec_helper'

describe "A Flac Tag Builder" do

  before(:each) do
    @builder = FlacTagBuilder.new
  end

  it "should add description correctly" do
    validate_tagging(:description)
  end

  it "should add title correctly" do
    validate_tagging(:title)
  end

  it "should add artist correctly" do
    validate_tagging(:artist)
  end

  it "should add album correctly" do
    validate_tagging(:album)
  end

  it "should add date correctly" do
    validate_tagging(:date)
  end

  it "should add genre correctly" do
    validate_tagging(:genre)
  end

  it "should add disc total correctly" do
    validate_tagging(:disc_total)
  end

  it "should add track number total correctly" do
    validate_tagging(:track_number)
  end

  it "should add track total correctly" do
    validate_tagging(:track_total)
  end

  it "should handle multiple tags at once" do
    genre = "my genre"
    artist = "my artist"
    @builder.add_genre(genre).add_artist(artist)
    @builder.arguments.should == " --set-tag=GENRE=\"#{genre}\" --set-tag=ARTIST=\"#{artist}\""
  end

end

def validate_tagging(tag)
  value = "my #{tag}"
  @builder.method("add_#{tag}").call(value)
  @builder.arguments.should == " --set-tag=#{tag.to_s.upcase.sub("_", "")}=\"#{value}\""
end