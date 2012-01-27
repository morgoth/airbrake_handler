#
# Author:: Adam Jacob (<adam@opscode.com>)
# Copyright:: Copyright (c) 2010 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require "chef/handler"
require "toadhopper"

class AirbrakeHandler < Chef::Handler
  VERSION = "0.2.1"

  attr_accessor :options, :api_key, :ignore

  def initialize(options={})
    @api_key = options.delete(:api_key)
    @ignore = options.delete(:ignore) || []
    @options = options
  end

  def report
    if run_status.failed? && !ignore_exception?(run_status.exception)
      Chef::Log.error("Creating Airbrake exception report")

      client.post!(run_status.exception, airbrake_params)
    end
  end

  def ignore_exception?(exception)
    @ignore.any? do |ignore_case|
      ignore_case[:class] == exception.class.name &&
      (!exception.message || !ignore_case[:message] || exception.message.include?(ignore_case[:message]))
    end
  end

  def airbrake_params
    {
      :notifier_name => "Chef Airbrake Notifier", :notifier_version => VERSION, :notifier_url => "https://github.com/morgoth/airbrake_handler",
      :component => run_status.node.name, :url => nil, :environment => {},
      :params => {
        :start_time => run_status.start_time,
        :end_time => run_status.end_time,
        :elapsed_time => run_status.elapsed_time,
        :run_list => run_status.node.run_list.to_s
      }
    }.merge(options)
  end

  def client
    raise ArgumentError.new("You must specify Airbrake api key") unless api_key
    Toadhopper.new(api_key)
  end
end
