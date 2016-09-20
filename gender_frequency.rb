require 'json'
# require 'benchmark'
require 'pry'

ARTICLE_GENDERS = %w(Der Das Die)

SUFFIXES = {'us' => 'Der',
            'or' => 'Der',
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
            'ur' => 'Die'
          }

# -------------------------------------------------------------------

class Guesser
  class << self
    def verdict(article, noun)
      i = 1
      while i < noun.length
        suffix = noun[i..-1]
        guessed_article = SUFFIXES[suffix]
        i += 1
        next unless guessed_article

        verdict = guessed_article == article ? :yay : :red_herring
        return [verdict, guessed_article, suffix]
      end
      [:nope, article, nil]
    end
  end
end

# -------------------------------------------------------------------

class Analysis
  class << self
    def process(result, totals)
      bayes(prior(totals), posterior(result))
    end

    def prior(totals)
      grand_total = totals.values.inject(&:+)
      totals.each_pair do |article, total|
        totals[article] = total / grand_total.to_f
      end
      totals
    end

    def posterior_calc(red_herring_words, yay_words)
      yay_count = yay_words.count
      yay_count / (yay_count + red_herring_words.count).to_f
    end

    def posterior(result)
      {}.tap do |posterior|
        result[:yay].each_pair do |article, words|
          posterior[article] = posterior_calc(result[:red_herring][article], words)
        end
      end
    end

    def bayes(prior, posterior)
      {}.tap do |power|
        prior.each_pair do |article, value|
          prior_uncertainty = 1 - value
          post_uncertainty  = 1 - posterior[article]

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
def sort_result_words(result)
  result.each_pair do |verdict, article|
    article.each_pair do |article, words|
      result[verdict][article] = words.sort
    end
  end
  result
end



def main
  str = File.read('dictionary.txt')
  lines = str.split("\n")
  result = { yay: {}, red_herring: {}, nope: {}}
  baseline_totals = Hash.new(0)

  lines.map! { |line| line.sub(/.+– /, '').sub(/ ~.+/,'') }

  lines.uniq.each do |item|
    article, noun = item.split(' ')
    # Some of these text lines (about 1.5%) aren't in the {Article Noun} format. Ignore them.
    next unless ARTICLE_GENDERS.include? article
    baseline_totals[article] += 1
    verdict, guessed_article, suffix = Guesser.verdict(article, noun)
    result[verdict][guessed_article] ||= {}
    result[verdict][guessed_article][suffix] ||= []
    result[verdict][guessed_article][suffix] << "#{article} #{noun}"
  end

  result = sort_result_words(result)

  stats = Analysis.process(result, baseline_totals)
  Presenter.format(result, stats)

  out_file_name = 'full_results.json'
  out_file = File.open(out_file_name, 'w')
  out_file.write JSON.pretty_generate(result)
  puts "Written results to #{out_file_name}."
  out_file.close
end

# -------------------------------------------------------------------

main





