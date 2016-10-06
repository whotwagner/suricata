require 'spec_helper'

describe Suricata::Connection do
  let(:conn) {Suricata::Connection.new}
  it 'gets successfully parsed' do
    conn.parse("{TCP} 10.12.32.15:49491 -> 157.56.198.14:80")
    expect(conn.proto).to eq("TCP")
    expect(conn.src).to eq("10.12.32.15")
    expect(conn.sport).to eq(49491)
    expect(conn.dst).to eq("157.56.198.14")
    expect(conn.dport).to eq(80)
    expect(conn.to_s).to eq("{TCP} 10.12.32.15:49491 -> 157.56.198.14:80")
  end

  it 'throws an exception if it parses nil' do
  	expect{conn.parse(nil)}.to raise_error(RuntimeError,"Invalid argument")
  end

  it 'throws an parsing error if the string is "foobar"' do
  	expect{conn.parse("foobar")}.to raise_error(/Parsing error/)
  end


  it 'throws an parsing error if the string does not end properly' do
  	expect{conn.parse("{TCP} 10.12.32.15:49491 -> 157.56.198.14:80 ")}.to raise_error(/Parsing error/)
  end

  it 'throws an parsing error if the string does not start properly' do
  	expect{conn.parse(" {TCP} 10.12.32.15:49491 -> 157.56.198.14:80")}.to raise_error(/Parsing error/)
  end

end
