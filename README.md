# Suricata

[![GPL Licence](https://badges.frapsoft.com/os/gpl/gpl.png?v=103)](https://github.com/whotwagner/suricata/blob/master/LICENSE.txt)  
[![Build Status](https://travis-ci.org/whotwagner/suricata.svg?branch=master)](https://travis-ci.org/whotwagner/suricata)
[![Inline docs](http://inch-ci.org/github/whotwagner/suricata.svg?branch=master)](http://inch-ci.org/github/whotwagner/suricata)
[![Code Climate](https://codeclimate.com/github/whotwagner/suricata/badges/gpa.svg)](https://codeclimate.com/github/whotwagner/suricata)
[![Gem Version](https://badge.fury.io/rb/suricata.svg)](https://badge.fury.io/rb/mindwave)

This gem offers classes for parsing suricata logfiles. It ships with a nagios-plugin.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'suricata'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install suricata

## Usage

### Nagios-Plugin

This gem comes with a Nagios-plugin to search suricata's fast-logfile for specific strings in the threat-description.

```
Usage: check_suricata [ -a alertfile ] [ -w whitelistfile ] -e searchstring
    -h, --help                       This help screen
    -a, --alertfile ALERTFILE        alertfile(default: /var/log/suricata/fast.log)
    -w, --whitelist WHITELISTFILE    whitelistfile
    -e, --search STRING              searchstring
    -i, --interactive                interactive
    -k, --ackfile ACKFILE            ackfile(default: /tmp/surack.lst)
```

It is possible to interactively acknowlege search hits so that they will not occur on the next search:
```
check_suricata -i -e "ET CHAT"                                                                                                                                               
Acknowlege the following entry:
10/04/2016-13:39:45.498785 [**] [1:2001595:10] ET CHAT Skype VOIP Checking Version (Startup) [**] [Classification: Potential Corporate Privacy Violation] [Priority: 1] {TCP} 192.168.0.1:40460 -> 15.14.13.12:80
Acknowlege(y|n): y
Acknowlege the following entry:
10/05/2016-09:25:01.186862 [**] [1:2001595:10] ET CHAT Skype VOIP Checking Version (Startup) [**] [Classification: Potential Corporate Privacy Violation] [Priority: 1] {TCP} 192.168.0.1:49491 -> 100.254.198.10:80
Acknowlege(y|n): n
```

### Logfile Analyzer

This gem comes with a logfile analyzer for suricata's fast.log. It's very easy to use and meant for using as a daily cronjob
```
Usage: surilizer <fast.log | fast.log* | fast.log fast.2.log fast.3.log.gz >

surilizer misc/fast.log

======== Suricata Log Analysis ========
Events: 11
Unique Sources: 3
Unique Events: 6

======== Unique Events =========

PRIORITY	| DESCRIPTION 
1		| ET POLICY Cleartext WordPress Login
1		| ET POLICY Http Client Body contains pwd= in cleartext
1		| ET CHAT Skype VOIP Checking Version (Startup)
2		| ET TOR Known Tor Relay/Router (Not Exit) Node Traffic group 339
3		| GPL CHAT Jabber/Google Talk Outgoing Traffic
3		| SURICATA TCPv4 invalid checksum

======== Eventy by source ========
Source: 192.168.0.1
	-> 8.8.8.8
		1 x ET POLICY Cleartext WordPress Login Prio: 1
	-> 8.8.8.1
		1 x ET POLICY Http Client Body contains pwd= in cleartext Prio: 1
	-> 4.3.2.1
		1 x SURICATA TCPv4 invalid checksum Prio: 3
	-> 15.14.13.12
		1 x ET CHAT Skype VOIP Checking Version (Startup) Prio: 1
	-> 8.4.3.7
		1 x GPL CHAT Jabber/Google Talk Outgoing Traffic Prio: 3
	-> 1.2.3.22
		2 x SURICATA TCPv4 invalid checksum Prio: 3
	-> 100.254.198.10
		1 x ET CHAT Skype VOIP Checking Version (Startup) Prio: 1

Source: 212.69.166.153
	-> 1.2.3.4
		1 x ET TOR Known Tor Relay/Router (Not Exit) Node Traffic group 339 Prio: 2

Source: 10.12.32.6
	-> 42.42.42.42
		1 x SURICATA TCPv4 invalid checksum Prio: 3
	-> 9.1.2.1
		1 x SURICATA TCPv4 invalid checksum Prio: 3

```

## Documentation

[rubydoc.info](http://www.rubydoc.info/github/whotwagner/suricata/master)


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/whotwagner/suricata.


---

Powered by [Toscom](http://www.toscom.at)
