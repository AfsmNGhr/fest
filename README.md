## FEST

[![Gem Version](https://badge.fury.io/rb/fest.svg)](http://badge.fury.io/rb/fest)
[![Build Status](https://travis-ci.org/AfsmNGhr/fest.svg)](https://travis-ci.org/AfsmNGhr/fest)
[![Coverage Status](https://coveralls.io/repos/AfsmNGhr/fest/badge.svg?branch=master)](https://coveralls.io/r/AfsmNGhr/fest?branch=master)
[![License](https://img.shields.io/packagist/l/doctrine/orm.svg)](https://github.com/AfsmNGhr/fest)

Ruby wrapper use [Festival](https://wiki.archlinux.org/index.php/Festival_%28%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9%29) for speak of the text and scripts ...

## Requirements

- *nix* or OS X ...
- [Festival](https://wiki.archlinux.org/index.php/Festival_%28%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9%29) and necessary languages ...
- [Pulseaudio](https://wiki.archlinux.org/index.php/PulseAudio_%28%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9%29)
- xbacklight ([backlight](https://wiki.archlinux.org/index.php/Backlight_%28%D0%A0%D1%83%D1%81%D1%81%D0%BA%D0%B8%D0%B9%29))

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
@fest.say("Пример")
# => Say "Пример"

# Expanded option
@fest.params = {:language => "cmu_us_slt_arctic_hts"}
@fest.say("This is an example")
# => Say "This is an example"

# All options
# params || default value
params[:path] || "/tmp"
params[:min_volume] || 20
params[:max_volume] || 60
params[:step] || 4
params[:backlight] || nil # disable check backlight
params[:language] || "voice_msu_ru_nsh_clunits"

# Declension
text = @fest.pluraform(2, %w(Сообщение Сообщения Сообщений))
puts text
# => "Сообщения"
```

## Сustomization

```.ruby
@fest.init
# check @current_volume
# @path, @index, @min_volume, @max_volume ...

@fest.check_conditions
# @fest.check_say_wav
# check_light и check_home_theater

@fest.check_light # (with xbacklight)
# exit if backlight equal 0

@fest.check_home_theater
# exit if run (vlc, kodi(xbmc))

@fest.make_wav(text)

@fest.expect_if_paplay_now
# wait if paplay active ...

@fest.play_wav
# @fest.check_optimal_volume (optimize min_volume and max_volume)
# @fest.turn_down_volume (with @step)
# @volume = @current_volume - @current_volume / 10 * @step
# play wav ... with @optimize_volume
# @fest.return_current_volume (with @step)
# delete_wav
```

## Issues
### Level of loudness doesn't dump after an exit

```.bash
#!/bin/bash

vlc.run --play-and-exit $*
amixer set Master 30% > /dev/null 2>&1
```
