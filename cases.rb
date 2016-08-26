# require 'pry'
# --------------- GRIDS ---------------------------------------------------
class Grid
  class << self
    def decorator(gender_ref, case_ref)
      decorators[case_ref - 1][gender_ref - 1]
    end
  end
end

# -------------------------------------------------------------------------

class StrongGrid < Grid
  class << self
    def key_letters
      [ ['r', 's', 'e', 'e'],
        ['n', 's', 'e', 'e'],
        ['m', 'm', 'r', 'n'] ]
    end

    def decorators
      [ ['er', 'es', 'e',  'e'],
        ['en', 'es', 'e',  'e'],
        ['em', 'em', 'er', 'en'] ]
    end
  end
end

# -------------------------------------------------------------------------

class WeakGrid < Grid
  class << self
    def decorators
      [ ['e',  'e',  'e',  'en'],
        ['en', 'e',  'e',  'en'],
        ['en', 'en', 'en', 'en'] ]
    end
  end
end

# -------------------------------------------------------------------------

class MixedGrid < StrongGrid
  class << self
    def decorators
      decs = super
      decs[0][0] = nil
      decs[0][1] = nil
      decs[1][1] = nil
      decs
    end
  end
end

# -------------------------------------------------------------------------

class Noun
  class << self
    def dictionary
      { 'Hund' => { gender_ref: 1 },
        'Mann' => { gender_ref: 1 },
        'Knochen' => { gender_ref: 1 },
        'Frucht' => { gender_ref: 3 }
      }
    end

    def gender(literal)
      noun = Noun.dictionary[literal]
      noun[:gender_ref] if noun.is_a? Hash
    end
  end
end

# -------------------------------------------------------------------------

class Article
  def initialize(case_ref)
    @case_ref = case_ref
  end

  def noun(literal, gender_ref = nil)
    @noun_literal = literal
    @gender_ref = gender_ref || Noun.gender(literal)
    raise ArgumentError, 'I don\'t know that noun so you need to tell me the gender.' unless @gender_ref
    self
  end

  def adj(literal)
    @adj_literal = literal
    self
  end

  def strong_decorator
    StrongGrid.decorator(@gender_ref, @case_ref)
  end

  def weak_decorator
    WeakGrid.decorator(@gender_ref, @case_ref)
  end

  def flexi_decorator
    # Refactor into FlexiGrid object
    flexi_decorators[@case_ref - 1][@gender_ref - 1]
  end

  def decorated_article
    return nil unless self.class::ARTICLE_ROOT
    "#{self.class::ARTICLE_ROOT}#{flexi_decorator}"
  end

  def decorated_adj
    return nil unless @adj_literal
    decorator = use_weak_grid? ? weak_decorator : strong_decorator
    "#{@adj_literal}#{decorator}"
  end

  def to_s
    "#{decorated_article} #{decorated_adj} #{@noun_literal}".gsub(/\s+/, ' ')
  end

  private

  # @alias 'determiner'
  def use_weak_grid?
    !!flexi_decorator
  end
end

# -------------------------------------------------------------------------

class A < Article
  ARTICLE_ROOT = 'ein'

  def flexi_decorators
    MixedGrid.decorators
  end
end

# -------------------------------------------------------------------------

class NoArticle < A
  ARTICLE_ROOT = nil
end

# -------------------------------------------------------------------------

class The < Article
  ARTICLE_ROOT = 'd'

  def flexi_decorators
    StrongGrid.decorators.map do |row|
      row.map do |decorator|
        decorator == 'e' ? 'ie' : decorator
      end
    end
  end
end


# --------------- Say Stuff! ---------------------------------------------------

def para (text)
  puts "\n#{text}\n"
end

para 'First give me an article and tell me which row reference (case) in the grid'
puts 'plus a noun with a column reference (gender)'

  puts The.new(1).noun('Schlips', 1)
  puts The.new(2).noun('Schlips', 1)
  puts The.new(3).noun('Schlips', 1)

  puts A.new(1).noun('Schlips', 1)
  puts A.new(2).noun('Schlips', 1)
  puts A.new(3).noun('Schlips', 1)

para 'Now let\'s stick an adjective in there'

  puts A.new(1).adj('furchtbar').noun('Schlips', 1)
  puts A.new(2).adj('furchtbar').noun('Schlips', 1)
  puts A.new(3).adj('furchtbar').noun('Schlips', 1)

para 'Should be similar when there is no article'

  puts NoArticle.new(1).adj('furchtbar').noun('Schlips', 1)
  puts NoArticle.new(2).adj('furchtbar').noun('Schlips', 1)
  puts NoArticle.new(3).adj('furchtbar').noun('Schlips', 1)

para 'If the noun is already in the dictionary you don\'t need to specify the gender.'

  puts @subject = The.new(1).adj('glücklich').noun('Mann')
  puts @indirect_object = The.new(3).adj('schwartz').noun('Hund')
  puts @object = A.new(2).adj('gelb').noun('Knochen')

para 'How about a full sentence?'
  @verb = 'bringt'

  def sentence
    "#{@subject} #{@verb} #{@indirect_object} #{@object}."
  end

  puts sentence

para 'And if we change the object to something with a different gender...'
  @object = A.new(2).adj('röt').noun('Frucht')
  puts sentence

