require_relative '../spec_helper'

RSpec.describe Fest do
  before(:each) do
    @fest = Fest.new
    @fest.params = {:language => 'cmu_us_slt_arctic_hts',
                    :min_volume => 30,
                    :max_volume => 70,
                    :step => 3,
                    :path => '~/'}
  end

  it '.params' do
    params = {:language => 'cmu_us_slt_arctic_hts',
              :min_volume => 30,
              :max_volume => 70,
              :step => 3,
              :path => '~/'}
    expect(@fest.params).to eq(params)
  end

  it '.path' do
    expect(@fest.path).to eq('~/')
  end

  it '.min_volume' do
    expect(@fest.min_volume).to eq(30)
  end

  it '.max_volume' do
    expect(@fest.max_volume).to eq(70)
  end

  it '.step' do
    expect(@fest.step).to eq(3)
  end

  it '.language' do
    expect(@fest.language).to eq('cmu_us_slt_arctic_hts')
  end
end
