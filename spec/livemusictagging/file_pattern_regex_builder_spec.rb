require 'spec_helper'

describe "A FilePatternRegexBuilder" do

  it "should replace disc number place holder and track number place holder" do
    regex_builder = FilePatternRegexBuilder.new(test_date, test_pattern)
    regex_builder.regex.should == "gd77-05-08d(\\d)t(\\d+).flac"
  end

end