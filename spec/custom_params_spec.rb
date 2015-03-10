require 'rspec'
require_relative '../lib/fest'

RSpec.describe Fest do
  before(:each) do
    @fest = Fest.new
    @fest.params = {:language => 'cmu_us_slt_arctic_hts',
                    :min_volume => 30,
                    :max_volume => 70,
                    :step => 3,
                    :path => '~/'}
  end

  it 'check custom params' do
    params = {:language => 'cmu_us_slt_arctic_hts',
              :min_volume => 30,
              :max_volume => 70,
              :step => 3,
              :path => '~/'}
    expect(@fest.params).to eq(params)
  end

  it 'check custom path in params' do
    expect(@fest.path).to eq('~/')
  end

  it 'check custom min volume' do
    expect(@fest.min_volume).to eq(30)
  end

  it 'check custom max volume' do
    expect(@fest.max_volume).to eq(70)
  end

  it 'check custom step' do
    expect(@fest.step).to eq(3)
  end

  it 'check custom language' do
    expect(@fest.language).to eq('cmu_us_slt_arctic_hts')
  end
end
