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

# This class splits a connection string into it's parts
class Connection
# @!attribute proto
#   protocol
# @!attribute src
#   source-ip
# @!attribute dst
#   destination-ip
# @!attribute sport
#   source port
# @!attribute dport
#   destination port
attr_accessor :proto, :src, :dst, :sport, :dport

# This constructor calls parse(string) if string is not nil
#
# @param [String] string string to parse
def initialize(string=nil)
	if not string.nil?
		parse(string)
	end
end

# This function parses a connection-string into it's parts
#
# @param [String] string string to parse
# @raise [Exception] Parsing error
def parse(string)
	if string.nil?
		raise "Invalid argument"
	end

	string = string.chomp

	if string =~ /^\{(.+)\}\s+(.+)\:(\d{1,5})\s+\-\>\s+(.+)\:(\d{1,5})$/
		@proto = $1
		@src = $2
		@sport = $3.to_i
		@dst = $4
		@dport = $5.to_i
	else
		raise "Parsing error: >>#{string}<<"
	end
end

# converts parsed values back to string
# @return [String] connection-string
def to_s
	"{#{proto}} #{src}:#{sport} -> #{dst}:#{dport}"
end

end

end
