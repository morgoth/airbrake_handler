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

require "chef"
require "chef/handler"
require "chef/mixin/deep_merge"
require "toadhopper"

class HoptoadHandler < Chef::Handler

  attr_accessor :options, :api_key

  def initialize(options={})
    @api_key = options.delete(:api_key)
    @options = options
  end

  def report
    if run_status.failed?
      Chef::Log.error("Creating Hoptoad exception report")

      client.post!(run_status.exception, hoptoad_params)
    end
  end

  def hoptoad_params
    Chef::Mixin::DeepMerge.merge({
      :component => run_status.node, :url => nil, :environment => {},
      :params => {
        :start_time => run_status.start_time,
        :end_time => run_status.end_time,
        :elapsed_time => run_status.elapsed_time
      }
    }, options)
  end

  def client
    raise "You must specify hoptoad api key" unless api_key
    Toadhopper.new(api_key)
  end
end
