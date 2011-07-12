require "spec_helper"

describe "A Current Directory Flac File List" do

  before :each do
    @checker = mock(MD5Checker)
    @fetcher = mock(FlacFileFetcher)
    @fetcher.stub!(:fetch).and_return([])
  end

  it "should return false if md5checker fails" do
    @checker.stub!(:valid?).and_return(false)
    file_list = CurrentDirectoryFlacFileList.new(@checker, @fetcher, nil)
    file_list.valid?.should == false
  end

  it "should defer to post md5 valid command if md5s are valid" do
    @checker.stub!(:valid?).and_return(true)
    validate_flac_file_list_with_post_md5_command(false)
    validate_flac_file_list_with_post_md5_command(true)
  end

end

def mock_post_md5_command(return_val)
  post_md5_command = mock()
  post_md5_command.stub!(:execute?).and_return(return_val)
  post_md5_command
end

def validate_flac_file_list_with_post_md5_command(is_valid)
  file_list = CurrentDirectoryFlacFileList.new(@checker, @fetcher, mock_post_md5_command(is_valid))
  file_list.valid?.should == is_valid
end
