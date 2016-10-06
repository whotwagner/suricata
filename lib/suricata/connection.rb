module Suricata

class Connection
attr_accessor :proto, :src, :dst, :sport, :dport

def initialize(string=nil)
	if not string.nil?
		parse(string)
	end
end

def parse(string)
	if string.nil?
		raise "Invalid argument"
	end

	string = string.chomp

	if string =~ /^\{(.+)\}\s+(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\:(\d+)\s+\-\>\s+(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\:(\d+)$/
		@proto = $1
		@src = $2
		@sport = $3.to_i
		@dst = $4
		@dport = $5.to_i
	else
		raise "Parsing error: >>#{string}<<"
	end
end

def to_s
	"{#{proto}} #{src}:#{sport} -> #{dst}:#{dport}"
end

end

end
