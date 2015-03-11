require 'spec_helper'

RSpec.describe Fest do
  before(:each) do
    @fest = Fest.new
    @fest.params = {}
  end

  it 'check default params' do
    expect(@fest.params).to eq({})
  end

  it 'check default path' do
    expect(@fest.path).to eq('/tmp')
  end

  it 'check current volume' do
    vol = `amixer | grep -o '[0-9]*' | sed "5 ! d"`.to_i
    expect(@fest.current_volume).to eq(vol)
  end

  it 'check index' do
    i = `ls -r #{@path} | grep -o '[0-9]*' | sed "1 ! d"`.to_i
    expect(@fest.index).not_to eq(i)
  end

  it 'check default min volume' do
    expect(@fest.min_volume).to eq(20)
  end

  it 'check default max volume' do
    expect(@fest.max_volume).to eq(60)
  end

  it 'check default step' do
    expect(@fest.step).to eq(4)
  end

  it 'check default language' do
    expect(@fest.language).to eq('voice_msu_ru_nsh_clunits')
  end
end
