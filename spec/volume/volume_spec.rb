# coding: utf-8
require_relative '../spec_helper'

RSpec.describe Fest do
  before(:each) do
    @fest = Fest.new
    @fest.init
  end

  it '.current_volume' do
    vol = `amixer | grep -o '[0-9]*' | sed "5 ! d"`.to_i
    expect(@fest.current_volume).to eq(vol)
  end

  it '.inputs' do
    inputs = `pactl list sink-inputs | grep № | grep -o '[0-9]*'`.split("\n")
    expect(@fest.inputs).to match_array(inputs)
  end

  it '.check_optimal_volume' do
    vol = @fest.current_volume - @fest.current_volume / 10 * @fest.step
    expect(@fest.check_optimal_volume).to eq(vol)
    expect(@fest.current_volume).to be > vol
  end

  it '.optimize_volume' do
    if @fest.current_volume > @fest.max_volume
      expect(@fest.optimize_volume).to be < @fest.current_volume
    elsif @fest.current_volume < @fest.min_volume
      expect(@fest.optimize_volume).to be > @fest.current_volume
    else
      expect(@fest.optimize_volume).to eq(@fest.current_volume)
    end
  end

  it '.turn_down_volume' do
    @fest.inputs
    @fest.turn_down_volume(
      @fest.current_volume,
      @fest.check_optimal_volume,
      @fest.step
    )
    expect($?.success?).to be_truthy
    @fest.return_current_volume(
      @fest.check_optimal_volume,
      @fest.current_volume,
      @fest.step
    )
    expect($?.success?).to be_truthy
  end

  it '.return_current_volume' do
    @fest.inputs
    @fest.turn_down_volume(
      @fest.current_volume,
      @fest.check_optimal_volume,
      @fest.step)
    expect($?.success?).to be_truthy
    @fest.return_current_volume(
      @fest.check_optimal_volume,
      @fest.current_volume,
      @fest.step
    )
    expect($?.success?).to be_truthy
  end
end
