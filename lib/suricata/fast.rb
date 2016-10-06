module Suricata

class Fast

attr_accessor :timestamp, :id, :description, :classification, :priority, :conn

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

end

end
