# coding: utf-8
require_relative '../spec_helper'

RSpec.describe Fest do
  before(:each) do
    @fest = Fest.new
    @fest.init
  end

  it 'check current volume' do
    vol = `amixer | grep -o '[0-9]*' | sed "5 ! d"`.to_i
    expect(@fest.current_volume).to eq(vol)
  end

  it 'chech current inputs' do
    inputs = `pactl list sink-inputs | grep № | grep -o '[0-9]*'`.split("\n")
    expect(@fest.inputs).to match_array(inputs)
  end

  it 'check optimal volume background music or video' do
    vol = @fest.current_volume - @fest.current_volume / 10 * @fest.step
    expect(@fest.check_optimal_volume).to eq(vol)
    expect(@fest.current_volume).to be > vol
  end

  it 'check optimizing volume min and max' do
    if @fest.current_volume > @fest.max_volume
      expect(@fest.optimize_volume).to be < @fest.current_volume
    elsif @fest.current_volume < @fest.min_volume
      expect(@fest.optimize_volume).to be > @fest.current_volume
    else
      expect(@fest.optimize_volume).to eq(@fest.current_volume)
    end
  end
end
