require 'spec_helper'

describe Suricata::Surilizer do
  let(:a) {Suricata::Surilizer.new("misc/fast.log")}

  it 'analysis' do
	a.analyze
	a.result
  end
end
