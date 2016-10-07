require 'spec_helper'

describe Suricata do
  let(:nagios){Suricata::Nagios.new("misc/fast.log")}

  it 'runs a search successfully' do
  	expect(nagios.search("ET CHAT")).to eq(2)
	expect(nagios.found_str).to eq("ET CHAT Skype VOIP Checking Version (Startup)")
  end


  it 'runs a search unsuccessfully' do
  	expect(nagios.search("EaT Chat")).to eq(0)
  end

  it 'runs the application without any arguments and exits with UNKNOWN' do
  	begin
		nagios.runApp([])
	rescue SystemExit => e
  		expect(e.status).to eq(3)
	end
  end

  it 'runs the application and performs a search successfully' do
 	begin
		nagios.runApp(["-e","ET CHAT"])
	rescue SystemExit => e
  		expect(e.status).to eq(2)
	end
  end

  it 'runs the application and performs a search using a whitelist' do
 	begin
		nagios.runApp(["-e","ET CHAT","-w","misc/whitelist.txt"])
	rescue SystemExit => e
  		expect(e.status).to eq(0)
	end
  end

  it 'runs the application and performs a search without any hit using a whitelist' do
 	begin
		nagios.runApp(["-e","Jabber","-w","misc/whitelist.txt"])
	rescue SystemExit => e
  		expect(e.status).to eq(2)
	end
  end

  it 'runs acknowlege interactively' do
  	o = Suricata::Nagios.new("misc/fast.log")
	o.acknowlege("ET CHAT")
  end


end
