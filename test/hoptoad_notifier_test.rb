require "helper"

class HoptoadHandlerTest < Test::Unit::TestCase
  def setup
    Chef::Log.stubs(:error)
  end

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

  test "reporting exception using client" do
    run_status = stub(:failed? => true, :exception => "Exception")
    client = mock
    handler = HoptoadHandler.new(:api_key => "fake")
    handler.stubs(:run_status).returns(run_status)
    handler.stubs(:client).returns(client)
    handler.stubs(:hoptoad_params).returns({})

    client.expects(:post!).with("Exception", {})
    handler.report
  end

  test "returning hoptoad params" do
    node = stub(:name => "node-name", :run_list => "cookbook::recipe")
    run_status = stub(:node => node, :start_time => Time.mktime(2011,1,1),
      :end_time => Time.mktime(2011,1,2), :elapsed_time => Time.mktime(2011,1,3))
    handler = HoptoadHandler.new(:api_key => "fake")
    handler.stubs(:run_status => run_status)
    assert_equal Hash, handler.hoptoad_params.class
  end
end
