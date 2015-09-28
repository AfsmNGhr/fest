# coding: utf-8
require_relative '../spec_helper'

RSpec.describe Fest do
  before(:each) do
    @fest = Fest.new
    params = YAML.load_file("#{GEM_ROOT}/config/default.yml")
    @step = params['step']
    @current_volume = eval(params['current_volume'].join('; '))
    @max_volume = params['max_volume']
    @min_volume = params['min_volume']
  end

  it 'current volume eq volume?' do
    vol = `amixer | grep -o '[0-9]*' | sed "5 ! d"`.to_i
    expect(@current_volume).to eq(vol)
  end

  it '#inputs' do
    inputs = `pactl list sink-inputs | grep '№' | grep -o '[0-9]*'`.split("\n")
    expect(@fest.sink_inputs).to match_array(inputs)
  end

  it '#check_optimal_volume' do
    vol = @current_volume - @current_volume / 10 * @step
    expect(@fest.check_optimal_volume).to eq(vol)
  end

  it '#optimize_volume' do
    if @current_volume > @max_volume
      expect(@fest.optimize_volume).to be < @current_volume
    elsif @current_volume < @min_volume
      expect(@fest.optimize_volume).to be > @current_volume
    else
      expect(@fest.optimize_volume).to eq(@current_volume)
    end
  end

  it '#change_volume' do
    @fest.sink_inputs
    @fest.change_volume(
      @current_volume,
      @fest.check_optimal_volume,
      @step
    )

    @fest.change_volume(
      @fest.check_optimal_volume,
      @current_volume,
      @step
    )

    vol = `amixer | grep -o '[0-9]*' | sed "5 ! d"`.to_i
    expect(@current_volume).to eq(vol)
  end
end
