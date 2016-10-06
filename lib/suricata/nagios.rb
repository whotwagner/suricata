module Suricata

require 'suricata/logfile'
require 'suricata/fast'
require 'optparse'

class Nagios

attr_reader :fast, :wl, :found_str, :search_str
attr_accessor :whitelist, :alertfile, :return_found, :return_notfound

def initialize(alertfile="/var/log/suricata/fast.log",whitelist=nil)
	@whitelist = whitelist
	@alertfile = alertfile
	@return_found = 2
	@return_notfound = 0

	@fast = Suricata::Logfile.new(@alertfile)
end

def runApp(args)
	help = nil
	OptionParser.new do |opt|
		opt.banner = "Usage: #{$PROGRAM_NAME} [ -a alertfile ] [ -w whitelistfile ] -e searchstring"
		opt.on('-h', '--help', 'This help screen') do
  			$stderr.puts opt
			exit 3
  		end
		opt.on('-a','--alertfile ALERTFILE','alertfile') { |o| @alertfile = o }
		opt.on('-w','--whitelist WHITELISTFILE','whitelistfile') { |o| @whitelist = o }
		opt.on('-e','--search STRING','searchstring') { |o| @search_str = o }
		help = opt.help
	end.parse!(args)

	if @search_str.nil?
		$stderr.puts help
		exit 3
	end

	ret = search(@search_str)
	if ret > 0
		puts "FOUND"
	else
		puts "OK"
	end
	exit ret
end

def search(str)
	@search_str = str
	@found_str = nil

	@fast.readline_parse do |fast_entry|
		if fast_entry.description =~ /#{@search_str}/
			if not @whitelist.nil?
				if search_wl(fast_entry.description) == false
					@found_str = fast_entry.description
					return @return_found
				end	
			else
				@found_str = fast_entry.description
				return @return_found
			end
		end
	end
	@fast.close

	return @return_notfound
end

private
def open_wl
@wl = File.open(@whitelist,'r')
end

def close_wl
@wl.close
end

def search_wl(str)
	open_wl
	begin
	while entry = @wl.readline
		entry = entry.chomp
		if str =~ /#{entry}/
			close_wl
			return true
		end
	end
	rescue EOFError
	end
	close_wl
	return false

end

end

end
