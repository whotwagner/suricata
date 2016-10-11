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

## Documentation

[rubydoc.info](http://www.rubydoc.info/github/whotwagner/suricata/master)


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/whotwagner/suricata.


---

Powered by [Toscom](http://www.toscom.at)
