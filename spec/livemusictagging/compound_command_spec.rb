require "spec_helper"

describe "A Compound Command " do

  it "should return true if no commands are given" do
    compound_command = CompoundCommand.new([])
    compound_command.execute?.should == true
  end

  it "should return true if all commands return true" do
    compound_command = CompoundCommand.new([MockCommand.new(true), MockCommand.new(true)])
    compound_command.execute?.should == true
  end

  it "should return false if all commands are false" do
    compound_command = CompoundCommand.new([MockCommand.new(false), MockCommand.new(false)])
    compound_command.execute?.should == false
  end

  it "should return false if any commands are false" do
    compound_command = CompoundCommand.new([MockCommand.new(false), MockCommand.new(true)])
    compound_command.execute?.should == false

    compound_command = CompoundCommand.new([MockCommand.new(true), MockCommand.new(false)])
    compound_command.execute?.should == false
  end

end

class MockCommand

  def initialize(return_val)
    @return_val = return_val
  end

  def execute?
    return_val
  end

end