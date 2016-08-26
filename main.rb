# --------------- GRIDS ---------------------------------------------------
# require 'pry'

class StrongGrid
  class << self
    def decorators
      [%w(er es e  e),
       %w(en es e  e),
       %w(em em er en)]
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

class WeakGrid
  class << self
    def decorators
      [['e',  'e',  'e',  'en'],
       ['en', 'e',  'e',  'en'],
       ['en', 'en', 'en', 'en']]
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
    @case_id = case_ref - 1
  end

  def noun(literal, gender_ref = nil)
    @noun_literal = literal
    @gender_id = gender_ref
    @gender_id ||= Noun.gender(literal)
    raise ArgumentError, 'I don\'t know that noun so you need to tell me the gender.' unless @gender_id
    @gender_id -= 1
    self
  end

  def adj(literal)
    @adj_literal = literal
    self
  end

  def strong_decorator
    StrongGrid.decorators[@case_id][@gender_id]
  end

  def weak_decorator
    WeakGrid.decorators[@case_id][@gender_id]
  end

  def strongish_decorator
    strongish_decorators[@case_id][@gender_id]
  end

  def decorated_article
    "#{self.class::ARTICLE_CORE}#{strongish_decorator}"
  end

  def decorated_adj
    return nil unless @adj_literal
    decorator = if use_weak_grid?
                  weak_decorator
                else
                  strong_decorator
                end
    "#{@adj_literal}#{decorator}"
  end

  def to_s
    "#{decorated_article} #{decorated_adj} #{@noun_literal}".gsub(/\s+/, ' ')
  end

  private

  def use_weak_grid?
    strongish_decorator
  end
end

class A < Article
  ARTICLE_CORE = 'ein'.freeze

  def strongish_decorators
    MixedGrid.decorators
  end
end

class The < Article
  ARTICLE_CORE = 'd'.freeze

  def strongish_decorators
    StrongGrid.decorators.map do |row|
      row.map do |decorator|
        decorator == 'e' ? 'ie' : decorator
      end
    end
  end
end


# --------------- Say Stuff! ---------------------------------------------------

# First give me an article and tell me which row_reference (case) in the grid
# plus a noun with a column reference (gender)

puts The.new(1).noun('Schlips', 1)
puts The.new(2).noun('Schlips', 1)
puts The.new(3).noun('Schlips', 1)

puts A.new(1).noun('Schlips', 1)
puts A.new(2).noun('Schlips', 1)
puts A.new(3).noun('Schlips', 1)

# Now let's stick an adjective in there
puts A.new(1).adj('furchtbar').noun('Schlips', 1)
puts A.new(2).adj('furchtbar').noun('Schlips', 1)
puts A.new(3).adj('furchtbar').noun('Schlips', 1)

# If the noun is already in the dictionary you don't need to specify the gender.
puts @subject = The.new(1).adj('glücklich').noun('Mann')
puts @indirect_object = The.new(3).adj('schwartz').noun('Hund')
puts @object = A.new(2).adj('gelb').noun('Knochen')

# How about a full sentence?
@verb = 'bringt'

def sentence
  "#{@subject} #{@verb} #{@object} für #{@indirect_object}."
end

puts sentence

# And if we change the object to something with a different gender...
@object = A.new(2).adj('röt').noun('Frucht')
puts sentence

