# coding: utf-8
# Ruby wrapper for Festival speech engine
# author Alexsey Ermolaev afay.zangetsu@gmail.com

require 'bundler'
GEM_ROOT = Bundler.rubygems.find_name('fest').first.full_gem_path
require_relative './fest/volume'
require 'yaml'

class Fest
  include Volume
  attr_accessor :params

  def say(string)
    check_conditions
    make_wav(string)
    expect_if_paplay_now
    play_wav
  end

  def initialize(params = {})
    params =
      YAML.load_file("#{GEM_ROOT}/config/default.yml") if params == {}
    params.each do |key, value|
      instance_variable_set(
        "@#{key}",
        value.is_a?(Array) ? eval(value.join('; ')) : value
      )
    end
  end

  def check_conditions
    @conditions.values.each do |value|
      eval(value.join('; '))
    end
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
    sink_inputs
    change_volume(@current_volume, @volume, @step)
    system("paplay #{@path}/say_#{@index}.wav \
      --volume='#{@optimize_volume * 655}' > /dev/null 2>&1")
    change_volume(@volume, @current_volume, @step)
    delete_wav
  end

  def delete_wav
    if File.exist?("#{@path}/say_#{@index}.wav")
      File.delete("#{@path}/say_#{@index}.wav")
    end
  end
end
