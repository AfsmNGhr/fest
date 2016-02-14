# coding: utf-8
# Ruby wrapper for Festival speech engine
# author Alexsey Ermolaev afay.zangetsu@gmail.com

require 'yaml'
require 'bundler'
require_relative './fest/volume'

GEM_ROOT = Bundler.rubygems.find_name('fest').first.full_gem_path
#
class Fest
  include Volume

  def say(string)
    unless string.nil? || string.empty?
      check_conditions
      make_wav(string)
      play_wav
      delete_wav
    end
  end

  def initialize(params = {})
    params = YAML.load_file("#{GEM_ROOT}/config/default.yml").merge(params)
    params.each do |key, value|
      instance_variable_set(
        "@#{key}",
        value.is_a?(Array) ? instance_eval(value.join('; ')) : value
      )
    end
  end

  def check_conditions
    @conditions =
      YAML.load_file("#{GEM_ROOT}/config/conditions.yml") if @conditions == {}
    @conditions.values.each do |value|
      instance_eval(value.join('; '))
    end
  end

  def make_wav(string)
    system("echo '#{string}' | text2wave -o #{@path}/say_#{@index}.wav \
      -eval '(#{@language})' > /dev/null 2>&1")
  end

  def expect_if_paplay_now
    loop { break `ps -el | grep paplay | wc -l`.to_i == 0 ? sleep(1) : '' }
  end

  def play_wav
    expect_if_paplay_now
    current_volumes_on_inputs
    volumes_for_inputs
    change_volumes(@current_volumes, @volumes, @step)
    paplay_wav
    change_volumes(@volumes, @current_volumes, @step)
  end

  def paplay_wav
    change_common_volume(optimize_common_volume)
    system("paplay #{@path}/say_#{@index}.wav \
      --volume='#{optimize_volume * 655}' > /dev/null 2>&1")
    change_common_volume(@common_volume)
  end

  def delete_wav
    File.delete("#{@path}/say_#{@index}.wav") if
      File.exist?("#{@path}/say_#{@index}.wav")
  end
end
