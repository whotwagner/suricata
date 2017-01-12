#!/usr/bin/env ruby

require 'bundler/setup'
require 'suricata/surilizer'

def usage(prognam)
	puts "Usage: #{prognam} <fast.log | fast.log.gz | fast.log fast.log.1.gz fast.log2.gz fast3.log>"
	exit 0
end

begin
usage($PROGRAM_NAME) if ARGV.length == 0
	surilizer = Suricata::Surilizer.new()

	ARGV.each do |f|
		if f =~ /.*.gz$/
			Zlib::GzipReader.open(f) {|gz|
				  surilizer.logfile = Suricata::Logfile.new(nil,false,gz)
				  surilizer.analyze
				  surilizer.logfile.close
			}
		else
			surilizer.logfile = Suricata::Logfile.new(f)
			surilizer.analyze
			surilizer.logfile.close
		end
	end
	surilizer.result
rescue Errno::ENOENT => e
	puts "#{e.message}\n"
	exit 1
end
