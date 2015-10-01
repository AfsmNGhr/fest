# coding: utf-8
require 'spec_helper'

RSpec.describe Fest do
  before(:each) do
    @fest = Fest.new
    params = YAML.load_file("#{GEM_ROOT}/config/default.yml")
    @index = params['index']
    @path = params['path']
  end

  context '#say' do
    it 'check successfull say' do
      @fest.say('Произвожу проверку функ циона+ла')
      expect($?.success?).to be_truthy
    end
  end

  context '#make_wav' do
    it 'successfull make wav?' do
      @fest.make_wav('Пример')
      expect($?.success?).to be_truthy
    end

    it 'pid not eq latest' do
      pid = $?.pid
      @fest.make_wav('Пример')
      expect(pid).not_to eq($?.pid)
    end

    it 'index change after make wav' do
      i = `ls -r #{@path} | grep -o '[0-9]*' | sed "1 ! d"`.to_i
      @fest.make_wav('Пример')
      expect(@index).not_to eq(i)
    end
  end

  context '#delete_wav' do
    it 'with successfull?' do
      @fest.make_wav('Пример')
      @fest.delete_wav
      expect($?.success?).to be_truthy
    end

    it 'index change' do
      i = `ls -r #{@path} | grep -o '[0-9]*' | sed "1 ! d"`.to_i
      @fest.make_wav('Пример')
      @fest.delete_wav
      x = `ls -r #{@path} | grep -o '[0-9]*' | sed "1 ! d"`.to_i
      expect(i).to eq(x)
    end
  end

  context 'for pause' do
    it '#play_wav' do
      @fest.make_wav('Вы числ+яю энт ро+п+ии ю вселенной')
      @fest.play_wav
      expect($?.success?).to be_truthy
    end
  end
end
