require "spec_helper"

describe "A Current Directory Flac File List" do

  it "should return false if md5checker fails" do
    file_list = CurrentDirectoryFlacFileList.new(MockMD5Checker.new(false), MockFetcher.new, nil)
    file_list.valid?.should == false
  end

  it "should defer to post md5 valid command if md5s are valid" do
    file_list = CurrentDirectoryFlacFileList.new(MockMD5Checker.new(true), MockFetcher.new, MockPostMD5Command.new(false))
    file_list.valid?.should == false

    file_list = CurrentDirectoryFlacFileList.new(MockMD5Checker.new(true), MockFetcher.new, MockPostMD5Command.new(true))
    file_list.valid?.should == true
  end

end

class MockMD5Checker

  def initialize(valid)
    @valid = valid
  end

  def valid?
    @valid
  end

end

class MockFetcher

  def fetch
    []
  end

end

class MockPostMD5Command

  def initialize(successful)
    @successful = successful
  end

  def execute?
    @successful
  end

end