require "rubygems"
gem "test-unit"
require "test/unit"
require "mocha"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require "hoptoad_handler"
