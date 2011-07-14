require 'spec_helper'

describe "A CurrentDirectoryShnToWaveToFlacFileList" do

  it "should be invalid if md5 checking fails" do
    file_list = CurrentDirectoryShnToWaveToFlacFileList.new(mock_md5_checker(false), nil, nil, nil)
    file_list.valid?.should == false
  end

  it "should ask the shn_to_wav_to_flac_command if md5 checking passes" do
    command = mock()
    command.stub!(:execute?).and_return(true)
    command_factory = mock(CommandFactory)
    command_factory.stub!(:shn_to_wav_to_flac_command).and_return(command)

    file_list = CurrentDirectoryShnToWaveToFlacFileList.new(mock_md5_checker(true), nil, command_factory, nil)
    file_list.valid?.should == true
  end

  it "should return flac files by asking flac_file_list_factory's flac_file_list" do
    command_factory = mock(CommandFactory)
    command_factory.stub!(:remove_md5_files_command).and_return(mock())

    file_list = mock()
    fake_flacs = ["a", "b", "c"]
    file_list.stub!(:flac_files).and_return(fake_flacs)

    flac_file_list_factory = mock(FlacFileListFactory)
    flac_file_list_factory.stub!(:flac_file_list).and_return(file_list)

    current_directory_shn_to_wav_flac_file_list = CurrentDirectoryShnToWaveToFlacFileList.new(nil, nil, command_factory, flac_file_list_factory)
    current_directory_shn_to_wav_flac_file_list.flac_files.should == fake_flacs
  end

end