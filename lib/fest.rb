# coding: utf-8

class Fest

  def say(str, params={})
    init(params={})
    check_light
    @i = check_say_wav
    make_wav(str, params={})
    set_volume(params={})
    expect_if_aplay_now
    play_wav
    return_current_volume(params={})
    delete_wav
  end

  def init(params={})
    @data = params[:data] || "/tmp"
    @current_volume = `amixer | grep -o '[0-9]*' | sed "5 ! d"`.to_i
    @i = `ls -r #{@data} | grep -o '[0-9]*' | sed "1 ! d"`.to_i
  end

  def check_light
    light = `xbacklight`.to_i
    exit if light == 0
  end

  def check_say_wav
    if @i > 0
      @i += 1
    else
      @i = 1
    end
  end

  def make_wav(str, params={})
    lang = params[:lang] || "voice_msu_ru_nsh_clunits"
    system("echo '#{str}' | text2wave -o #{@data}/say_#{@i}.wav \
      -eval '(#{lang})' > /dev/null 2>&1")
  end

  def set_volume(params={})
    volume = params[:volume] || 70
    sound = params[:sound] || "alsa"
    set_volume_sound_system(volume, params={})
  end

  def expect_if_aplay_now
    while true
      sleep 1
      break if `ps -el | grep aplay | wc -l`.to_i == 0
    end
  end

  def play_wav
    system("aplay #{@data}/say_#{@i}.wav > /dev/null 2>&1")
  end

  def return_current_volume(params={})
    if `ps -el | grep aplay | wc -l`.to_i == 0
      set_volume_sound_system(@current_volume, params={})
    end
  end

  def set_volume_sound_system(volume, params={})
    sound = params[:sound] || "alsa"
    if sound == "alsa"
      system("amixer set Master #{volume}% > /dev/null 2>&1")
    else
      system("amixer -D pulse set Master #{volume}% > /dev/null 2>&1")
    end
  end

  def delete_wav
    system("rm -f #{@data}/say_#{@i}.wav")
  end

  def pluralform(num, arr)
    n = num % 100
    m = n % 10

    if n > 10 && n < 20
      return arr[2]
    elsif m > 1 && m < 5
      return arr[1]
    elsif m == 1
      return arr[0]
    else
      return arr[2]
    end
  end

end
