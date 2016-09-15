require 'pry'

ARTICLE_GENDERS = %w(Der Das Die)

SUFFICES = {'ant' => 'Der',
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
            'ik' => 'Die'}

def verdict(article, noun)
  i = noun.length
  bingo =
  while i > 1
    i -= 1
    bingo = predict_gender(article, noun[i..-1])
    return bingo if bingo
    # predict_gender(noun[0..i])
  end
  :nope
end

def predict_gender(article, ending)
  return false unless SUFFICES[ending]
  SUFFICES[ending] == article ? :yay : :red_herring
end

def main
  str = File.read('dictionary.txt')
  lines = str.split("\n")
  result = { yay: {}, red_herring: {}, nope: {}}

  lines.each do |line|
    item = line.sub(/.+– /, '').sub(/ ~.+/,'')
    article, noun = item.split(' ')
    next unless ARTICLE_GENDERS.include? article
    verdict = verdict(*item.split(' '))
    result[verdict][article] ||= []
    result[verdict][article] << noun
  end

  format_result(result)
end

def format_result(result)
  result.keys.each do |verdict|
    puts verdict.to_s.capitalize
    result[verdict].keys.each do |article|
      puts "  #{article}"
      puts "     #{result[verdict][article].count}"
    end
  end
end

main





