#  Airbrake handler for Chef

Report [Chef](http://www.opscode.com/chef) exceptions to [Airbrake](http://airbrake.io)

Works fine with chef versions: 0.9.x and 0.10.x

## Usage

```
gem install airbrake_handler
```

In your chef client file (often placed at /etc/chef/client.rb) put:

```ruby
require "airbrake_handler"
exception_handlers << AirbrakeHandler.new(:api_key => "your-airbrake-api-key")
```

You can pass more options to AirbrakeHander initializer, i.e:

```ruby
AirbrakeHandler.new(:api_key => "your-airbrake-api-key", :framework_env => "production")
```

If you want to ignore specific exceptions, you can do this like that:

```ruby
airbrake_handler = AirbrakeHandler.new(:api_key => "your-airbrake-api-key", :framework_env => "production")
airbrake_handler.ignore << {:class => "SystemExit"}
airbrake_handler.ignore << {:class => "Errno::ECONNRESET", :message => "Connection reset by peer"}
```

## Continuous Integration

[![Build Status](https://secure.travis-ci.org/morgoth/airbrake_handler.png)](http://travis-ci.org/morgoth/airbrake_handler)

## Copyright

Copyright (c) 2011 Adam Jacob, Wojciech Wnętrzak See LICENSE for details.
