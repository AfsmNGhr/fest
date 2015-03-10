# coding: utf-8
#
module Fest::Conditions
  def check_conditions
    check_light
    check_home_theater
  end

  def check_light
    exit if @params[:backlight].nil? && `xbacklight`.to_i == 0
  end

  def check_home_theater
    xbmc = `ps -el | grep xbmc | wc -l`.to_i
    vlc = `ps -el | grep vlc | wc -l`.to_i
    kodi = `ps -el | grep kodi | wc -l`.to_i
    exit if xbmc > 0 || vlc > 0 || kodi > 0
  end
end
