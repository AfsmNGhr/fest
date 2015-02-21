# coding: utf-8
#
class Fest
  def say(string, params = {})
    init(params)
    check_conditions
    make_wav(string)
    expect_if_paplay_now
    check_optimal_volume
    play_wav
  end

  def init(params)
    @params = params
    @path = @params[:path] || '/tmp'
    @current_volume = `amixer | grep -o '[0-9]*' | sed "5 ! d"`.to_i
    @index = `ls -r #{@path} | grep -o '[0-9]*' | sed "1 ! d"`.to_i
    @min_volume = @params[:down_volume[0]] || 20
    @max_volume = @params[:down_volume[1]] || 60
    @step = @params[:down_volume[2]] || 4
  end

  def check_optimal_volume
    @volume = @current_volume - @current_volume / 10 * @step
    optimize_min_and_max_volume
  end

  def optimize_min_and_max_volume
    @optimize_volume = (
    if @current_volume > @max_volume
      @max_volume
    elsif @current_volume < @min_volume
      @min_volume
    else
      @current_volume
    end
    )
  end

  def check_conditions
    check_light
    check_home_theater
    check_say_wav
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

  def check_say_wav
    @index > 0 ? @index += 1 : @index = 1
  end

  def make_wav(string)
    system("echo '#{string}' | text2wave -o #{@path}/say_#{@index}.wav \
      -eval '(#{@params[:language] || 'voice_msu_ru_nsh_clunits'})' \
      > /dev/null 2>&1")
  end

  def change_volume(volume)
    system("amixer set Master #{volume}% > /dev/null 2>&1")
  end

  def expect_if_paplay_now
    loop do
      break if `ps -el | grep paplay | wc -l`.to_i == 0
      sleep 1
    end
  end

  def turn_down_volume
    @inputs = `pactl list sink-inputs | grep № | grep -o '[0-9]*'`.split("\n")
    @inputs.each do |input|
      volume = @current_volume
      loop do
        system("pactl set-sink-input-volume #{input} '#{volume * 655}'")
        volume -= @step
        break if volume < @volume
      end
    end
  end

  def play_wav
    turn_down_volume
    system("paplay #{@path}/say_#{@index}.wav \
      --volume='#{@optimize_volume * 655}' > /dev/null 2>&1")
    return_current_volume
    delete_wav
  end

  def return_current_volume
    @inputs.each do |input|
      volume = @volume
      loop do
        system("pactl set-sink-input-volume #{input} '#{volume * 655}'")
        volume += @step
        break if volume > @current_volume
      end
    end
  end

  def delete_wav
    system("rm -f #{@path}/say_#{@index}.wav")
  end

  def pluralform(number, array)
    n = number % 100
    m = n % 10

    if n > 10 && n < 20
      array[2]
    elsif m > 1 && m < 5
      array[1]
    elsif m == 1
      array[0]
    else
      array[2]
    end
  end
end
