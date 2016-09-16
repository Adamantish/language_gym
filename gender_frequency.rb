require 'pry'
# require 'benchmark'

ARTICLE_GENDERS = %w(Der Das Die)

SUFFIXES = {'us' => 'Der',
            'ant' => 'Der',
            'ast' => 'Der',
            'ich' => 'Der',
            'ig' => 'Der',
            'ismus' => 'Der',
            'ling' => 'Der',
            'chen' => 'Das',
            'lein' => 'Das',
            'ma' => 'Das',
            'tel' => 'Das',
            'tum' => 'Das',
            'um' => 'Das',
            'e' => 'Die',
            'a' => 'Die',
            'anz' => 'Die',
            'enz' => 'Die',
            'ei' => 'Die',
            'heit' => 'Die',
            'ie' => 'Die',
            'ik' => 'Die',
            'in' => 'Die',
            'schaft' => 'Die',
            'sion' => 'Die',
            'tät' => 'Die',
            'ung' => 'Die',
            'ur' => 'Die'}

# -------------------------------------------------------------------

class Guesser
  class << self
    def verdict(article, noun)
      i = 1
      while i < noun.length
        guessed_article = SUFFIXES[noun[i..-1]]
        i += 1
        next unless guessed_article

        hit_one = guessed_article == article ? :yay : :red_herring
        return [hit_one, guessed_article] if hit_one
      end
      [:nope, article]
    end
  end
end

# -------------------------------------------------------------------

class Analysis
  class << self
    def process(result, totals)
      bayes(posterior(result, prior(totals)))
    end

    def prior(totals)
      grand_total = totals.values.inject(&:+)
      totals.each_pair do |article, total|
        totals[article] = [total, total / grand_total.to_f]
      end
      totals
    end

    def posterior(result, prior)
      {}.tap do |posterior|
        result[:yay].each_pair do |article, words|
          yay_count = words.count
          herring_count = result[:red_herring][article].count
          hit_rate = yay_count / (yay_count + herring_count).to_f
          posterior[article] = prior[article] << hit_rate
        end
      end
    end

    def bayes(post_n_prior)
      {}.tap do |power|
        post_n_prior.each_pair do |article, data|
          prior_uncertainty = 1 - data[1]
          post_uncertainty = 1 - data[2]

          power[article] = if post_uncertainty > 0
            (prior_uncertainty / post_uncertainty).round(2)
          else
            :perfect
          end
        end
      end
    end
  end
end

# -------------------------------------------------------------------

class Presenter
  class << self
    def format(result, stats)
      print ARTICLE_GENDERS.join '  '
      result.keys.each do |verdict|
        print "\n"
        ARTICLE_GENDERS.each do |article|
          print result[verdict][article].count.to_s.ljust(5)
        end
        print "#{verdict.to_s.capitalize}"
      end
      puts "\n\nPredictive powers: \n#{stats.to_s.gsub(',',",\n")}"
    end
  end
end

# -------------------------------------------------------------------

def main
  str = File.read('dictionary.txt')
  lines = str.split("\n")
  result = { yay: {}, red_herring: {}, nope: {}}
  totals = Hash.new(0)

  lines.each do |line|
    item = line.sub(/.+– /, '').sub(/ ~.+/,'')
    article, noun = item.split(' ')
    next unless ARTICLE_GENDERS.include? article
    totals[article] += 1
    verdict, guessed_article = Guesser.verdict(article, noun)
    result[verdict][guessed_article] ||= []
    result[verdict][guessed_article] << noun
  end

  stats = Analysis.process(result, totals)
  Presenter.format(result, stats)
end

# -------------------------------------------------------------------

main





