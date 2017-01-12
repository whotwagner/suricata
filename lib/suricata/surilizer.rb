module Suricata

require 'suricata/logfile'

class Counter
attr_reader :count

def initialize(start=0)
@count = start
end

def increase
@count += 1
end

def to_s
	"#{@count}"
end

end


#
# [src-ip][counter]
# [src-ip][dst]
# [src-ip][dst][counter]
# [src-ip][dst][desc][counter]
class Surilizer

attr_accessor :logfile
attr_reader :src, :lines

def initialize(file = nil)

	@logfile = Suricata::Logfile.new(file) if not file.nil?
	@src = Hash.new
	@dst = Hash.new
	@lines = Counter.new
end



def analyze()
	@logfile.readline_parse do |entry|
		@lines.increase
		addCounter(@src,entry.conn.src)
		addEntry(@src[entry.conn.src],'dst',Hash)
		addCounter(@src[entry.conn.src]['dst'],entry.conn.dst)
		addEntry(@src[entry.conn.src]['dst'][entry.conn.dst],'desc',Hash)
		addCounter(@src[entry.conn.src]['dst'][entry.conn.dst]['desc'],entry.description)
		@src[entry.conn.src]['dst'][entry.conn.dst]['desc'][entry.description]['prio'] = entry.priority
		@src[entry.conn.src]['dst'][entry.conn.dst]['desc'][entry.description]['class'] = entry.classification
	end


end

def getUniqEvents
	a = Array.new
	@src.each do |key,val|
		val['dst'].each do  |keya,vala|
		val['dst'][keya]['desc'].each do  |keyb,valb|
			a.push([keyb,val['dst'][keya]['desc'][keyb]['prio']])
		end

		end
	end

	return a.uniq
end

def result
	events = getUniqEvents
	puts "======== Suricata Log Analysis ========"
	puts "Events: #{@lines}"
	puts "Unique Sources: #{@src.length}"
	puts "Unique Events: #{events.length}"
	puts "\n"
	puts "======== Unique Events ========="
	puts "\n"
	puts "PRIORITY\t| DESCRIPTION "
	events.sort{ |x,y| x[1] <=> y[1]}.each do |e|
		puts "#{e[1]}\t\t| #{e[0]}"
	end
	puts "\n"

	puts "======== Eventy by source ========"
	@src.each do |key,val|
		puts "Source: #{key}"
		val['dst'].each do  |keya,vala|
		puts "\t-> #{keya}\n"
		val['dst'][keya]['desc'].each do  |keyb,valb|
			puts "\t\t#{valb['counter'].count} x #{keyb} Prio: #{valb['prio']}\n"
		end

		end
		puts ""
	end

end

private
def addCounter(val,entry)
		if not val.key?(entry)
			val[entry] = Hash.new
			val[entry]['counter'] = Counter.new(1)
		else
			val[entry]['counter'].increase
		end
end

def addEntry(val,entry,type)
	if not val.key?(entry)
		val[entry] = type.new
	end
end

end

end
