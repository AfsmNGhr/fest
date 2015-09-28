require 'spec_helper'

RSpec.describe Fest do
  before(:each) do
    @fest = Fest.new
  end

  it '.params' do
    expect(@fest.params).to eq({})
  end

  it '.path' do
    expect(@fest.path).to eq('/tmp')
  end

  it '.current_volume' do
    vol = `amixer | grep -o '[0-9]*' | sed "5 ! d"`.to_i
    expect(@fest.current_volume).to eq(vol)
  end

  it '.index' do
    i = `ls -r #{@path} | grep -o '[0-9]*' | sed "1 ! d"`.to_i
    expect(@fest.index).not_to eq(i)
  end

  it '.min_volume' do
    expect(@fest.min_volume).to eq(20)
  end

  it '.max_volume' do
    expect(@fest.max_volume).to eq(60)
  end

  it '.step' do
    expect(@fest.step).to eq(4)
  end

  it '.language' do
    expect(@fest.language).to eq('voice_msu_ru_nsh_clunits')
  end
end
