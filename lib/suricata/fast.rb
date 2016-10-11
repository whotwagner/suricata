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

require 'suricata/connection'

# This class parses suricatas fast.log-files
class Fast

# @!attribute timestamp
#  log-time
# @!attribute id
#  signature-id
# @!attribute description
#  signature-description
# @!attribute classification
#   threat-classification
# @!attribute priority
#  priority
# @!attribute conn
#  Suricata::Connection connection
attr_accessor :timestamp, :id, :description, :classification, :priority, :conn

# this function parses an entry of fast.log
# @param [String] string one line of fast.log
# @raise [Exception] if string is nil
def parse(string)
	if string.nil?
		raise "Invalid argument"
	end

	if string =~ /^([^ ]+)\s+/
		@timestamp = $1.chomp(' ')
	end

	if string =~ /\[\*\*\]\s+\[(\d+\:\d+\:\d+)\]\s+(.*)\[\*\*\]/
		@id = $1
		@description = $2.chomp(' ')
	end

	if string =~ /\[Classification: ([^\]]+)\]/
		@classification = $1
	end

	if string =~ /\[Priority: ([^\]]+)\]/
		@priority = $1
	end

	if string =~ /\]\s+([^\]]+)$/
		@conn = Suricata::Connection.new($1)
	end

end

def getThreat
	return [ @description, @priority, @classification ]
end

# this function converts the parsed entry back to string
# @return [String] converted string
def to_s
	"#{@timestamp} [**] [#{@id}] #{@description} [**] [Classification: #{@classification}] [Priority: #{@priority}] #{@conn}"
end

end

end
