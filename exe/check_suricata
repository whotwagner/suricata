#!/usr/bin/env ruby

require 'suricata/nagios'

begin
nagios = Suricata::Nagios.new
nagios.runApp(ARGV)
rescue Errno::ENOENT => e
	puts "#{e.message}\n"
	exit 3
end
