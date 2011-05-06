require "helper"

describe HoptoadHandler do
  before do
    Chef::Log.stubs(:error)
  end

  it "should raise error when api_key is not specified" do
    assert_raises ArgumentError do
      HoptoadHandler.new.client
    end
  end

  it "should setting options" do
    handler = HoptoadHandler.new(:framework_env => "staging")
    assert_equal "staging", handler.options[:framework_env]
  end

  it "should reporting exception using client" do
    run_status = stub(:failed? => true, :exception => "Exception")
    client = mock
    handler = HoptoadHandler.new(:api_key => "fake")
    handler.stubs(:run_status).returns(run_status)
    handler.stubs(:client).returns(client)
    handler.stubs(:hoptoad_params).returns({})

    client.expects(:post!).with("Exception", {})
    handler.report
  end

  it "should returning hoptoad params" do
    node = stub(:name => "node-name", :run_list => "cookbook::recipe")
    run_status = stub(:node => node, :start_time => Time.mktime(2011,1,1),
      :end_time => Time.mktime(2011,1,2), :elapsed_time => Time.mktime(2011,1,3))
    handler = HoptoadHandler.new(:api_key => "fake")
    handler.stubs(:run_status => run_status)
    assert_equal Hash, handler.hoptoad_params.class
  end
end
