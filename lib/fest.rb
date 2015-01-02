# coding: utf-8

class Fest

  def say(string, params={})
    init(params={})
    check_optimal_volume
    check_light
    @index = check_say_wav
    make_wav(string)
    expect_if_aplay_now
    turn_down_volume
    play_wav
    return_current_volume
    delete_wav
  end

  def init(params)
    @params = params
    @path = @params[:path] || "/tmp"
    @current_volume = `amixer | grep -o '[0-9]*' | sed "5 ! d"`.to_i
    @index = `ls -r #{@path} | grep -o '[0-9]*' | sed "1 ! d"`.to_i
  end

  def check_optimal_volume
    if @params[:down_volume].nil?
      @down_volume = 7
      @volume = @current_volume - @down_volume
    else
      @down_volume = @params[:down_volume]
      @volume = @current_volume - @down_volume
    end
  end

  def check_light
    light = `xbacklight`.to_i
    exit if light == 0
  end

  def check_say_wav
    if @index > 0
      @index += 1
    else
      @index = 1
    end
  end

  def make_wav(string)
    language = @params[:language] || "voice_msu_ru_nsh_clunits"
    system("echo '#{string}' | text2wave -o #{@path}/say_#{@index}.wav \
      -eval '(#{language})' > /dev/null 2>&1")
  end

  def set_volume(volume)
    system("amixer set Master #{volume}% > /dev/null 2>&1")
  end

  def expect_if_aplay_now
    while true
      sleep 1
      break if `ps -el | grep aplay | wc -l`.to_i == 0
    end
  end

  def turn_down_volume
    @inputs = `pactl list sink-inputs | grep № | grep -o '[0-9]*'`.split("\n")
    @new_volume = @volume * 655
    @inputs.each do |input|
      system("pactl set-sink-input-volume #{input} '#{@new_volume}'")
    end
  end

  def play_wav
    system("aplay #{@path}/say_#{@index}.wav > /dev/null 2>&1")
  end

  def return_current_volume
    if `ps -el | grep aplay | wc -l`.to_i == 0
      @inputs.each do |input|
        volume = @current_volume * 655
        system("pactl set-sink-input-volume #{input} '#{volume}'")
      end
      set_volume(@current_volume)
    end
  end

  def delete_wav
    system("rm -f #{@path}/say_#{@index}.wav")
  end

  def pluralform(number, array)
    n = number % 100
    m = n % 10

    if n > 10 && n < 20
      return array[2]
    elsif m > 1 && m < 5
      return array[1]
    elsif m == 1
      return array[0]
    else
      return array[2]
    end
  end

end
