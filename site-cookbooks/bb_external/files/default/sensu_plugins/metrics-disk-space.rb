#!/usr/bin/env ruby

require 'rubygems' if RUBY_VERSION < '1.9.0'
require 'sensu-plugin/metric/cli'
require 'socket'

class DiskSpaceGraphite < Sensu::Plugin::Metric::CLI::Graphite
  option :scheme,
    :description => "Metric naming scheme, text to prepend to metric",
    :short => "-s SCHEME",
    :long => "--scheme SCHEME",
    :default => "#{Socket.gethostname}.disk"

  def run
    `df -PT`.split("\n").drop(1).each do |line|
      begin
        fs, _type, _blocks, used, avail, capacity, _mnt = line.split

        if (dev = fs[%r{^/dev/([^/]+)}, 1])
          scheme = config[:scheme]

          output "#{scheme}.#{dev}.used.bytes", used.to_i * 1024
          output "#{scheme}.#{dev}.available.bytes", avail.to_i * 1024
          output "#{scheme}.#{dev}.capacity.percent", capacity.to_i
        end
      rescue
        unknown "malformed line from df: #{line}"
      end
    end
    ok
  end
end
