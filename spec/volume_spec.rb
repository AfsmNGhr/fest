# coding: utf-8
require 'spec_helper'

RSpec.describe Fest do
  describe '::Volume' do
    before(:all) do
      @fest = Fest.new
      params = YAML.load_file("#{GEM_ROOT}/config/default.yml")
      @flat_volumes = params['flat_volumes']
      @step = params['step']
      @common_volume = instance_eval(params['common_volume'].join('; '))
      @max_volume = params['max_volume']
      @min_volume = params['min_volume']
      @current_volumes = @fest.current_volumes_on_inputs
      @volumes = @fest.volumes_for_inputs
    end

    it '.include? Volume' do
      expect(@fest.class.included_modules.include?(Volume)).to be_truthy
    end

    it 'common volume eq volume?' do
      vol = `amixer | grep -o '[0-9]*' | sed "5 ! d"`.to_i
      expect(@common_volume).to eq(vol)
    end

    it '#current_volumes_on_inputs' do
      info = `pactl list sink-inputs`
      inputs = info.scan(/\A#|№(\d+)/).flatten
      volumes = info.scan(/\W+:\s\w+\W+\w+:\s\d+\s\/\s+(\d+)%/).flatten
      current_volumes = inputs.zip(volumes.map(&:to_i)).to_h
      expect(@fest.current_volumes_on_inputs).to eq(current_volumes)
    end

    it '#volumes_for_inputs' do
      current_volumes = @fest.current_volumes_on_inputs
      volumes = {}
      current_volumes.each do |input, volume|
        volumes.merge!({ input => (volume - volume / 10 * @step) })
      end
      expect(@fest.volumes_for_inputs).to eq(volumes)
    end

    it '#optimize_volume' do
      case @flat_volumes
      when 'yes'
        if @common_volume > @max_volume
          expect(@fest.optimize_volume).to be < @common_volume
        elsif @common_volume < @min_volume
          expect(@fest.optimize_volume).to be > @common_volume
        else
          expect(@fest.optimize_volume).to eq(@common_volume)
        end
      else
        expect(@fest.optimize_volume).to eq(100)
      end
    end

    it '#change_volumes down' do
      @fest.change_volumes(@current_volumes, @volumes, @step)

      info = `pactl list sink-inputs`
      inputs = info.scan(/\A#|№(\d+)/).flatten
      volumes = info.scan(/\W+:\s\w+\W+\w+:\s\d+\s\/\s+(\d+)%/).flatten
      current_volumes = inputs.zip(volumes.map(&:to_i)).to_h

      @volumes.each do |input, volume|
        expect(volume).to eq(current_volumes[input])
      end
    end

    it '#change_volumes up' do
      @fest.change_volumes(@volumes, @current_volumes, @step)

      info = `pactl list sink-inputs`
      inputs = info.scan(/\A#|№(\d+)/).flatten
      volumes = info.scan(/\W+:\s\w+\W+\w+:\s\d+\s\/\s+(\d+)%/).flatten
      current_volumes = inputs.zip(volumes.map(&:to_i)).to_h

      @current_volumes.each do |input, volume|
        expect(volume).to eq(current_volumes[input])
      end
    end
  end
end
