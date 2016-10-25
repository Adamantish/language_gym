require_relative 'koan_helper'

RSpec.describe 'Decorating nouns' do
  describe 'The:' do
    it 'the power of Strong Grid you shall use' do
      deutsch = The.new(1).noun('Schlips', 1).to_s
      expect(deutsch).to eq 'der Schlips'

      deutsch = The.new(2).noun('Schlips', 1).to_s
      expect(deutsch).to eq 'den Schlips'

      deutsch = The.new(3).noun('Schlips', 1).to_s
      expect(deutsch).to eq '_ Schlips'
    end
  end

  describe 'A:' do
    it 'through Mixed Grid shall you find your peace ' do
      deutsch = A.new(1).noun('Schlips', 1).to_s
      expect(deutsch).to eq 'ein Schlips'

      deutsch = A.new(2).noun('Schlips', 1).to_s
      expect(deutsch).to eq 'einen Schlips'

      deutsch = A.new(3).noun('Schlips', 1).to_s
      expect(deutsch).to eq 'ein_ Schlips'
    end
  end

  describe 'Adjective:' do
    it 'Weak Grid not quite your friend shall be' do
      deutsch = The.new(3).adj('glücklich').noun('Mann').to_s
      expect(deutsch).to eq 'dem glücklichen Mann'

      deutsch = A.new(3).adj('glücklich').noun('Mann').to_s
      expect(deutsch).to eq 'einem glücklichen Mann'

      deutsch = The.new(1).adj('schwartz').noun('Hund').to_s
      expect(deutsch).to eq 'der schwartze Hund'

      deutsch = The.new(2).adj('gelb').noun('Knochen').to_s
      expect(deutsch).to eq 'den gelben Knochen'

      # Treachery!
      deutsch = A.new(1).adj('schwartz').noun('Hund').to_s
      expect(deutsch).to eq 'ein schwartz_ Hund'
    end

    it 'shall be overcome by the Strong when duty the decorator has forsaken' do
      deutsch = A.new(1).adj('röt').noun('Bier').to_s
      expect(deutsch).to eq 'ein rötes Bier'

      deutsch = NoArticle.new(1).adj('furchtbar').noun('Schlips', 1).to_s
      expect(deutsch).to eq ' furchtbar_ Schlips'
    end
  end
end
