require "spec_helper"

describe "A Compound Command " do

  it "should return true if no commands are given" do
    compound_command = CompoundCommand.new([])
    compound_command.execute?.should == true
  end

  it "should return true if all commands return true" do
    compound_command = CompoundCommand.new([mock_command(true), mock_command(true)])
    compound_command.execute?.should == true
  end

  it "should return false if all commands are false" do
    compound_command = CompoundCommand.new([mock_command(false), mock_command(false)])
    compound_command.execute?.should == false
  end

  it "should return false if any commands are false" do
    compound_command = CompoundCommand.new([mock_command(false), mock_command(true)])
    compound_command.execute?.should == false

    compound_command = CompoundCommand.new([mock_command(true), mock_command(false)])
    compound_command.execute?.should == false
  end

end


def mock_command(return_val)
  command = mock()
  command.stub!(:execute?).and_return(return_val)
  command
end
