## FEST

[![Gem Version](https://badge.fury.io/rb/fest.svg)](http://badge.fury.io/rb/fest)
[![Build Status](https://travis-ci.org/AfsmNGhr/fest.svg)](https://travis-ci.org/AfsmNGhr/fest)
[![Packagist](https://img.shields.io/packagist/l/doctrine/orm.svg)](https://github.com/AfsmNGhr/fest)

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
text = "Пример"
@fest.say(text)
# => Say "Пример"

# Expanded option
params = {:language => "cmu_us_slt_arctic_hts"}
text = "This is an example"
@fest.say(text, params)
# => Say "This is an example" ...

# All options
# params || default value
params[:path] || "/tmp"
params[:down_volume] || [20,60,4] # [min, max, step]
params[:backlight] || nil # disable check backlight
params[:language] || "voice_msu_ru_nsh_clunits"

# Declension
text = @fest.pluraform(2, %w(Сообщение Сообщения Сообщений))
puts text
# => "Сообщения"
```

## Сustomization

```.ruby
@fest.init(params)
# check @current_volume
# @path, @index, @min_volume, @max_volume ...

@fest.check_optimal_volume
# @volume = @current_volume - @down_volume

@fest.optimize_min_and_max_volume(min_volume, max_volume)

@fest.check_conditions
# @fest.check_say_wav
# check_light и check_home_theater

@fest.check_light # (with xbacklight)
# exit if backlight equal 0

@fest.check_home_theater
# exit if run (vlc, kodi(xbmc))

@fest.make_wav(text)

@fest.change_volume(volume)

@fest.expect_if_paplay_now
# wait if paplay active ...

@fest.play_wav
# @fest.turn_down_volume (with @step)
# @volume = @current_volume - @current_volume / 10 * @step
# play wav ... with @optimize_volume
# @fest.return_current_volume (with @step)
# @fest.delete_wav
```

## Issues
### Level of loudness doesn't dump after an exit

```.bash
#!/bin/bash

vlc.run --play-and-exit $*
amixer set Master 30% > /dev/null 2>&1
```