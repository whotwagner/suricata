require 'spec_helper'

describe Suricata::Logfile do
  let(:log) {Suricata::Logfile.new("misc/fast.log")}

  it 'gets successfully reads as a block' do
  	i = 0
  	log.readline do |n|
		i += 1
	end
	expect(i).to eq(11)
  end

  
  it 'successfully reads lines' do
  	i = 0
	while n = log.readline
		i += 1
	end
	expect(i).to eq(11)
  end

  it 'gets successfully parsed as block' do
  	i = 0
  	log.readline_parse do |n|
		i += 1
	end
	expect(i).to eq(11)
  end

  it 'gets successfully parsed' do
  	i = 0
  	while n = log.readline_parse
		i += 1
	end
	expect(i).to eq(11)
  end


end
