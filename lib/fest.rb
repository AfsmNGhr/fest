# coding: utf-8
# Ruby wrapper for Festival speech engine
# author Alexsey Ermolaev afay.zangetsu@gmail.com

require_relative 'fest/params'
require_relative 'fest/volume'
require_relative 'fest/conditions'
#
class Fest
  include Params
  include Volume
  include Conditions
  attr_accessor :params

  def say(string)
    init
    check_conditions
    make_wav(string)
    expect_if_paplay_now
    play_wav
  end

  def make_wav(string)
    system("echo '#{string}' | text2wave -o #{@path}/say_#{@index}.wav \
      -eval '(#{@language})' > /dev/null 2>&1")
  end

  def expect_if_paplay_now
    loop do
      break if `ps -el | grep paplay | wc -l`.to_i == 0
      sleep 1
    end
  end

  def play_wav
    check_optimal_volume
    optimize_volume
    inputs
    turn_down_volume
    system("paplay #{@path}/say_#{@index}.wav \
      --volume='#{@optimize_volume * 655}' > /dev/null 2>&1")
    return_current_volume
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
