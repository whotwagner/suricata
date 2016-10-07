#--
# Copyright (C) 2016 Wolfgang Hotwagner <code@toscom.at>       
#                                                                
# This file is part of the suricata gem                                            
# 
# This mindwave gem is free software; you can redistribute it and/or 
# modify it under the terms of the GNU General Public License 
# as published by the Free Software Foundation; either version 2 
# of the License, or (at your option) any later version.
# 
# This gem is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License          
# along with this gem; if not, write to the 
# Free Software Foundation, Inc., 51 Franklin St, Fifth Floor, 
# Boston, MA  02110-1301  USA 
#++

module Suricata

require 'suricata/logfile'
require 'suricata/fast'
require 'optparse'


# This class offers all functionalities for a suricata-nagios-plugin
class Nagios


# @!attribute fast
#  this attribute stores the Suricata::Logfile-object
# @!attribute found_str
#  this attribute stores the string found by search() in the Logfile-object
# @!attribute search_str
#  the search-pattern is stored in this attribute
attr_reader :fast, :found_str, :search_str

# @!attribute whitelist
#  this whitelist can be used to exclude results from the search
# @!attribute alertfile
#  this alertfile(fast.log) is used for the search
# @!attribute return_found
#  this value is returned from search() on succes. (Default: 2)
# @!attribute return_notfound
#  this value is returned from search() on failure (Default: 0)
# @!attribute ack
#  it is possible to acknowlege alerts, so that they will be 
#  excluded from the next search. Use this member to set the acknowlege-file.
#  Default ack-file is: /tmp/surack.lst
attr_accessor :whitelist, :alertfile, :return_found, :return_notfound, :ack

# constructor 
# @param [String] alertfile path to the suricata-log-file(default: /var/log/suricata/fast.log)
# @param [String] whitelist path to the whitelist(default: nil)
def initialize(alertfile="/var/log/suricata/fast.log",whitelist=nil)
	@whitelist = whitelist
	@alertfile = alertfile
	@return_found = 2
	@return_notfound = 0
	@ack = "/tmp/surack.lst"
end

# this method initializes the Suricata::Logfile(@fast) and opens 
# the @alertfile 
# @see alertfile
def init_log
	@fast = Suricata::Logfile.new(@alertfile)
end

# this is the check_suricata-application. this function exits with 3 
# on error
# @param [Array] args typically ARGV
# @return [Integer] @return_found if searchstring was found
# @return [Integer] @return_notfound if searchstring was not found
# @see return_found
# @see return_notfound
def runApp(args)
	help = nil
	interactive = false

	OptionParser.new do |opt|
		opt.banner = "Usage: #{$PROGRAM_NAME} [ -a alertfile ] [ -w whitelistfile ] -e searchstring"
		opt.on('-h', '--help', 'This help screen') do
  			$stderr.puts opt
			exit 3
  		end
		opt.on('-a','--alertfile ALERTFILE','alertfile(default: /var/log/suricata/fast.log)') { |o| @alertfile = o }
		opt.on('-w','--whitelist WHITELISTFILE','whitelistfile') { |o| @whitelist = o }
		opt.on('-e','--search STRING','searchstring') { |o| @search_str = o }
		opt.on('-i','--interactive','interactive acknowleges') { |o| interactive = o }
		opt.on('-k','--ackfile ACKFILE','ackfile(default: /tmp/surack.lst)') { |o| @ack = o }
		help = opt.help
	end.parse!(args)

	if @search_str.nil?
		$stderr.puts help
		exit 3
	end
	
	if interactive
		acknowlege(@search_str)
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

# this method performs a search(str). It will ask interactively for ever
# hit if it should be acknowleged. In case of "yes", the routine will
# add a shortform of the entry to the acknowlege-file
# @param [String] str string to search
# @see ack
def acknowlege(str)

	if @fast.nil?
		init_log
	end

	list = File.open(@ack,'a')

	@fast.readline_parse do |fast_entry|
		if fast_entry.description =~ /#{str}/
			if not search_list("#{fast_entry.timestamp} #{fast_entry.id} #{fast_entry.conn}",@ack)
			 	printf("Acknowlege the following entry:\n")
			 	printf("#{fast_entry}\n")
			 	printf("Acknowlege(y|n): ")
			 	answer = STDIN.gets
			 	if answer == "y\n"
			 		list.write("#{fast_entry.timestamp} #{fast_entry.id} #{fast_entry.conn}\n")
			 	end
			end	
		end
	end

	list.close

end

# this function performs a search for a string(str) 
# in the alert-file. If a whitelistfile is given,
# or a acknowlege-file, it will search those files
# too and eventually exclude the hit from the result.
# @param [String] str search-query
# @return [Integer] @return_found on success
# @return [Integer] @return_notfound on failure
# @see return_found
# @see return_notfound
# @see ack
# @see whitelist
def search(str)
	@search_str = str
	@found_str = nil

	if @fast.nil?
		init_log
	end	

	wl_found = false
	ack_found = false

	@fast.readline_parse do |fast_entry|
		if fast_entry.description =~ /#{@search_str}/
			if not @whitelist.nil?
				wl_found =  search_list(fast_entry.description,@whitelist)
			end

			if not @ack.nil? and File.file?(@ack)
				ack_found = search_list("#{fast_entry.timestamp} #{fast_entry.id} #{fast_entry.conn}",@ack)
			end

			if wl_found == false and ack_found == false
				@found_str = fast_entry.description
				return @return_found
			end
		end
	end
	@fast.close

	return @return_notfound
end

private

# this function performs a search for a line in a file
# @param [String] str search-query
# @param [String] listfile file to search
# @return [Boolean] true if it succeded
# @return [Boolean] false if it did not succed
def search_list(str,listfile)
	list = File.open(listfile,'r')
	begin
	while entry = list.readline
		entry = entry.chomp
		if str =~ /#{entry}/
			list.close
			return true
		end
	end
	rescue EOFError
	end
	list.close
	return false

end

end

end
