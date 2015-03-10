# coding: utf-8
#
module Fest::Params
  def path
    @path = @params[:path] || '/tmp'
  end

  def current_volume
    @current_volume = `amixer | grep -o '[0-9]*' | sed "5 ! d"`.to_i
  end

  def index
    @index = `ls -r #{@path} | grep -o '[0-9]*' | sed "1 ! d"`.to_i
    @index > 0 ? @index += 1 : @index = 1
  end

  def min_volume
    @min_volume = @params[:volume[0]] || 20
  end

  def max_volume
    @max_volume = @params[:volume[1]] || 60
  end

  def step
    @step = @params[:volume[2]] || 4
  end

  def language
    @language = @params[:language] || 'voice_msu_ru_nsh_clunits'
  end
end
