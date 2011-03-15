require 'helper'

class HoptoadHandlerTest < Test::Unit::TestCase
  test "raise error when api_key is not specified" do
    assert_raise_message("You must specify Hoptoad api key") do
      HoptoadHandler.new.client
    end
  end

  test "not raise error when api_key is specified" do
    assert_nothing_raised do
      HoptoadHandler.new(:api_key => "fake").client
    end
  end

  test "setting options" do
    handler = HoptoadHandler.new(:framework_env => "staging")
    assert_equal "staging", handler.options[:framework_env]
  end

  # TODO: write more tests
end
