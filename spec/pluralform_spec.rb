# coding: utf-8
require_relative 'spec_helper'

RSpec.describe Fest do
  before(:each) do
    @fest = Fest.new
    @fest.init
  end

  context 'check pluralform method' do
    it 'check 1 message' do
      expect(@fest.pluralform(
              1, %w(Сообщение Сообщения Сообщений))).to eq('Сообщение')
    end

    it 'check 5 message' do
      expect(@fest.pluralform(
              5, %w(Сообщение Сообщения Сообщений))).to eq('Сообщений')
    end

    it 'check 3 message' do
      expect(@fest.pluralform(
              3, %w(Сообщение Сообщения Сообщений))).to eq('Сообщения')
    end
  end
end
