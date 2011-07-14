$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'bundler/setup'

require 'livemusictagging'

RSpec.configure do |config|
  # some (optional) config here
end


def mock_md5_checker(return_val)
  md5checker = mock(MD5Checker)
  md5checker.stub!(:valid?).and_return(return_val)
  md5checker
end
