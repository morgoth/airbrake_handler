require "helper"

describe AirbrakeHandler do
  before do
    Chef::Log.stubs(:error)
  end

  # initalization

  it "raises error when api_key is not specified" do
    assert_raises ArgumentError do
      AirbrakeHandler.new.client
    end
  end

  # options

  it "sets options" do
    handler = AirbrakeHandler.new(:framework_env => "staging")
    assert_equal "staging", handler.options[:framework_env]
  end

  # exceptions

  it "reports exception using client" do
    exception = Exception.new
    run_status = stub(:failed? => true, :exception => exception)
    client = mock
    handler = AirbrakeHandler.new(:api_key => "fake")
    handler.stubs(:run_status).returns(run_status)
    handler.stubs(:client).returns(client)
    handler.stubs(:airbrake_params).returns({})

    client.expects(:post!).with(exception, {})
    handler.report
  end

  it "does not report ignored exception" do
    run_status = stub(:failed? => true, :exception => Exception.new)
    client = mock
    handler = AirbrakeHandler.new(:api_key => "fake")
    handler.ignore << {:class => "Exception"}
    handler.stubs(:run_status).returns(run_status)
    handler.stubs(:client).returns(client)
    handler.stubs(:airbrake_params).returns({})

    client.expects(:post!).never
    handler.report
  end

  it "does not report ignored exception with specific message" do
    run_status = stub(:failed? => true, :exception => Exception.new("error"))
    client = mock
    handler = AirbrakeHandler.new(:api_key => "fake")
    handler.ignore << {:class => "Exception", :message => /error/}
    handler.stubs(:run_status).returns(run_status)
    handler.stubs(:client).returns(client)
    handler.stubs(:airbrake_params).returns({})

    client.expects(:post!).never
    handler.report
  end

  it "reports exception if its message doesn't match any message of ignored exceptions" do
    run_status = stub(:failed? => true, :exception => Exception.new("important error"))
    client = mock
    handler = AirbrakeHandler.new(:api_key => "fake")
    handler.ignore << {:class => "Exception", :message => /not important error/}
    handler.ignore << {:class => "Exception", :message => /some error/}
    handler.stubs(:run_status).returns(run_status)
    handler.stubs(:client).returns(client)
    handler.stubs(:airbrake_params).returns({})

    client.expects(:post!).once
    handler.report
  end

  it "ignores exception by message regexp" do
    handler = AirbrakeHandler.new(:api_key => "fake")
    handler.ignore << {:class => "Exception", :message => /catch me if you can/}

    assert handler.ignore_exception?(Exception.new("catch me if you can"))
  end

  # params

  it "returns Airbrake params" do
    node = stub(:name => "node-name", :run_list => "cookbook::recipe")
    run_status = stub(:node => node, :start_time => Time.mktime(2011,1,1),
      :end_time => Time.mktime(2011,1,2), :elapsed_time => Time.mktime(2011,1,3))
    handler = AirbrakeHandler.new(:api_key => "fake")
    handler.stubs(:run_status => run_status)

    refute_empty handler.airbrake_params
  end
end
