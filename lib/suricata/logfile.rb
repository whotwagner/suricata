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


require "suricata/fast"

# This class opens a logfile, offers methods for reading logfiles 
# and calls the logfile-parser
class Logfile
# @!attribute logfile
#   path and filename of the logfile
# @!attribute parser
#   parser to use(default: Suricata::Fast)
attr_accessor :logfile, :parser
# @!attribute file
#   file-descriptor for logfile
# @!attribute line
#   current line of the logfile. set by readline and readline_parse
attr_reader :file, :line

# constructor
# @param [String] logfile path and filename of the logfile
# @param [Boolean] autoopen calls open if true(default: true)
def initialize(logfile,autoopen=true,file=nil)
	@logfile = logfile
	@parser = Suricata::Fast.new

	if autoopen == true
		open
	else
		@file = file if not file.nil?
	end
end

# this method calls parser.parse(string)
# @param [String] string logfile-entry to parse
# @raise [Exception] "Invalid argument" if string is nil 
# @raise [Exception] "Invalid parser" if parser is nil
# @return [Object] parser
def parse(string)
	if string.nil?
		raise "Invalid argument"
	end

	if @parser.nil?
		raise "Invalid parser"
	end

	@parser.parse(string)

	return @parser

end

# this method reads a line of the logfile and calls the parser
# @return [Object] parsed object if not called with a block(default: Surricata::Fast)
# @return [false] if there is nothing to read and if not called with a block
# @yieldparam [Object] @line parsed object(default Suricata::Fast)
def readline_parse
	if block_given?
		while readline
			yield(parse(@line))
		end
	else
		if not readline
			return false
		else
			return parse(@line)
		end
	end
end

# this method reads a line of the logfile
# @return [String] line current logfile entry
# @return [Boolean] false when EOF reached
# @yieldparam [String] @line current logfile entry
def readline
	begin
	if block_given?
		while @line = @file.readline
			yield(@line)
		end
	else
		@line = @file.readline
		return @line
	end
	rescue EOFError
		return false
	end


end

# this method opens the logfile and initialises file
def open
	@file = File.new(@logfile,"r")
end

# this method closes the logfile
def close
	@file.close()
end

end

end
