require 'spec_helper'
require 'date'

describe "A DiscAndTrackInfo" do

  before(:all) do
    regex_builder = FilePatternRegexBuilder.new(test_date, test_pattern)

    @files = [file_name("1", "01"), file_name("1", "02"), file_name("2", "01")]
    @d_and_t_info = DiscAndTrackInfo.new(regex_builder, @files)
  end

  it "should give correct disc total" do
    @d_and_t_info.disc_total.should == 2
  end

  it "should give correct track number" do
    @d_and_t_info.track_number(@files[0]).should == 1
    @d_and_t_info.track_number(@files[1]).should == 2
    @d_and_t_info.track_number(@files[2]).should == 1
  end

  it "should give correct disc numbers" do
    @d_and_t_info.disc_number(@files[0]).should == 1
    @d_and_t_info.disc_number(@files[1]).should == 1
    @d_and_t_info.disc_number(@files[2]).should == 2
  end

  it "should give correct track totals" do
    @d_and_t_info.track_total(@files[0]).should == 2
    @d_and_t_info.track_total(@files[1]).should == 2
    @d_and_t_info.track_total(@files[2]).should == 1
  end

end

def file_name(disc, track)
  "gd77-05-08d#{disc}t#{track}.flac"
end
