require 'spec_helper'

describe Suricata::Fast do
	let(:fast) {Suricata::Fast.new}
	it 'can be created' do
		Suricata::Fast.new
	end

	it 'gets successfully parsed' do
		fast.parse("10/05/2016-09:25:01.186862  [**] [1:2001595:10] ET CHAT Skype VOIP Checking Version (Startup) [**] [Classification: Potential Corporate Privacy Violation] [Priority: 1] {TCP} 10.12.32.15:49491 -> 157.56.198.14:80")
		expect(fast.timestamp).to eq("10/05/2016-09:25:01.186862")
		expect(fast.id).to eq("1:2001595:10")
		expect(fast.description).to eq("ET CHAT Skype VOIP Checking Version (Startup)")
		expect(fast.classification).to eq("Potential Corporate Privacy Violation")
		expect(fast.priority).to eq("1")
		expect(fast.conn.to_s).to eq("{TCP} 10.12.32.15:49491 -> 157.56.198.14:80")
	end
end
