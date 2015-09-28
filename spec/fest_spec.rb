# coding: utf-8
require 'spec_helper'

RSpec.describe Fest do
  before(:each) do
    @fest = Fest.new
  end

  context '.say' do
    it 'check successfull say' do
      @fest.say('Начинаю тэ+с т+ирова ние')
      expect($?.success?).to be_truthy
    end
  end

  context '.make_wav' do
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

  context '.delete_wav' do
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
    it '.play_wav' do
      @fest.make_wav('Вы числ+яю энт ро+п+ии ю вселенной')
      @fest.play_wav
      expect($?.success?).to be_truthy
    end
  end
end
