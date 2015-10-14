## FEST

[![Gem Version](https://badge.fury.io/rb/fest.svg)](http://badge.fury.io/rb/fest)
[![Build Status](https://travis-ci.org/AfsmNGhr/fest.svg)](https://travis-ci.org/AfsmNGhr/fest)
[![Coverage Status](https://coveralls.io/repos/AfsmNGhr/fest/badge.svg?branch=master)](https://coveralls.io/r/AfsmNGhr/fest?branch=master)
[![License](https://img.shields.io/packagist/l/doctrine/orm.svg)](https://github.com/AfsmNGhr/fest)

Ruby wrapper use [Festival](https://wiki.archlinux.org/index.php/Festival_%28%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9%29) for speak of the text and scripts ...

## Requirements

- *nix* or OS X (pgrep tools) ...
- [Festival](https://wiki.archlinux.org/index.php/Festival_%28%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9%29) and necessary languages ...
- [Pulseaudio](https://wiki.archlinux.org/index.php/PulseAudio_%28%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9%29)

## Install

```.ruby
# Gemfile
gem 'fest'
```
or
```.ruby
$ gem install fest
```

## Used
### Call methods
```.ruby
require 'fest'

@fest = Fest.new
@fest.say("Пример") # => Say "Пример"

@fest = Fest.new(YAML.load_file('../config/custom.yml'))
@fest.say("This is an example")
# => Say "This is an example"

# All options
# params || default value
params['path'] || '/tmp'
params['flat_volumes'] || 'no' # need pulseaudio flat-volumes = no
params['min_volume'] || 20
params['max_volume'] || 60
params['step'] || 4
params['backlight'] || nil # disable check backlight
params['language'] || 'voice_msu_ru_nsh_clunits'
params['conditions'] || {} # eval config/conditions.yml

## Сustomization

@fest.initialize(params = {})
# check @common_volume
# @path, @index, @min_volume, @max_volume ...

@fest.check_conditions
# eval config/conditions.yml if default conditions

@fest.make_wav(text)

@fest.expect_if_paplay_now
# wait if paplay active ...

@fest.play_wav
# play wav ... with @optimize_volume
# delete_wav
```

## Issues
### Level of loudness doesn't dump after an exit

```.bash
#!/bin/bash

vlc.run --play-and-exit $*
amixer set Master 30% > /dev/null 2>&1
```

or

```.js
; pulseaudio config

flat-volumes = no ; yes
```