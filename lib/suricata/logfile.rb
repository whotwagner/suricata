module Suricata


require "suricata/fast"

class Logfile
attr_accessor :logfile, :parser
attr_reader :file, :line

def initialize(logfile,logtype=nil,autoopen=true)
	@logfile = logfile
	@parser = Suricata::Fast.new

	if autoopen == true
		open
	end
end

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

def open
	@file = File.new(@logfile,"r")
end

def close
	@file.close()
end

end

end
