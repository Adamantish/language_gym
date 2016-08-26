# --------------- GRIDS ---------------------------------------------------
require 'pry'

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

class Article
  def initialize(case_ref)
    @case_ref = case_ref - 1
  end

  def noun(literal, gender_ref = nil)
    @noun_literal = literal
    @gender_ref = gender_ref - 1
    self
  end

  def adjective(literal)
    @adjective_literal = literal
  end

  def decorator
    decorators[@case_ref][@gender_ref]
  end

  def decorated_article
    "#{self.class::ARTICLE_CORE}#{decorator}"
  end

  def to_s
    "#{decorated_article} #{@noun_literal}"
  end
end

class A < Article
  ARTICLE_CORE = 'ein'.freeze

  def decorators
    MixedGrid.decorators
  end
end

class The < Article
  ARTICLE_CORE = 'd'.freeze

  def decorators
    StrongGrid.decorators.map do |row|
      row.map do |decorator|
        decorator == 'e' ? 'ie' : decorator
      end
    end
  end
end

puts A.new(2).noun('hund', 2)
puts The.new(2).noun('hund', 2)
