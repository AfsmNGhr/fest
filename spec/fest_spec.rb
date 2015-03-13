# coding: utf-8
require_relative 'spec_helper'

RSpec.describe Fest do
  before(:each) do
    @fest = Fest.new
    @fest.init
  end

  it 'check say method' do
    @fest.say('Начинаю тэст+ирова ние')
    expect($?.success?).to be_truthy
  end

  context 'make wav method' do
    it 'check successfull make wav' do
      @fest.make_wav('Пример')
      expect($?.success?).to be_truthy
    end

    it 'check pid make wav' do
      pid = $?.pid
      @fest.make_wav('Пример')
      expect(pid).not_to eq($?.pid)
    end

    it 'check make wav index' do
      i = `ls -r #{@fest.path} | grep -o '[0-9]*' | sed "1 ! d"`.to_i
      @fest.make_wav('Пример')
      expect(@fest.index).not_to eq(i)
    end
  end

  context 'delete wav method' do
    it 'successfull delete wav' do
      @fest.make_wav('Пример')
      @fest.delete_wav
      expect($?.success?).to be_truthy
    end

    it 'check delete wav index' do
      i = `ls -r #{@fest.path} | grep -o '[0-9]*' | sed "1 ! d"`.to_i
      @fest.make_wav('Пример')
      @fest.delete_wav
      x = `ls -r #{@fest.path} | grep -o '[0-9]*' | sed "1 ! d"`.to_i
      expect(i).to eq(x)
    end
  end

  context 'for pause' do
    it 'check play wav method' do
      @fest.make_wav('Вы числ+яю энт роп+ии ю вселенной')
      @fest.play_wav
      expect($?.success?).to be_truthy
    end
  end
end
