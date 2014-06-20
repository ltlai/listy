require 'benchmark'
require 'pry'

class NetworkSizeCalculator
  def initialize(dictionary)
    @dictionary = dictionary
  end

  def network_size(word)
    build_network_iteratively(word).size
  end

  def build_network_iteratively(word)
    network = {word => true}
    stack = [word]
    while !stack.empty?
      current_variant = stack.pop
      generate_variants(current_variant).each do |variant|
        if @dictionary[variant] && !network[variant]
          network[variant] = true
          stack << variant
        end
      end
    end
    network
  end

  def generate_variants(word)
    variants = []
    word.length.times do |index|
      variants << word_after_deletion(word, index)
      variants += words_after_replacement(word, index)
    end
    variants += words_after_insertion(word)
    variants.flatten
  end

  def word_after_deletion(word, index)
    word[0...index] << word[(index + 1)..-1]
  end

  def words_after_replacement(word, index)
    variant_set = []
    original_letter = word[index]
    ('A'..'Z').each do |new_letter|
      word[index] = new_letter
      # We need to dupe the word to prevent future changes to the word from 
      # changing the existing elements of variant_set
      variant_set << word.dup
    end
    word[index] = original_letter
    variant_set
  end

  def words_after_insertion(word)
    variant_set = []
    (word.length + 1).times do |i|
      ('A'..'Z').each do |letter|
        word.insert(i, letter)
        # We need to dupe the word to prevent future changes to the word from 
        # changing the existing elements of variant_set
        variant_set << word.dup
        word[i] = ''
      end
    end
    variant_set
  end
end

if __FILE__==$0
  dictionary = {}
  File.foreach('dictionary.txt') do |line|
    dictionary[line.chomp] = true
  end
  time = Benchmark.measure do
    calculator = NetworkSizeCalculator.new(dictionary)
    puts calculator.network_size('LISTY')
  end
  puts time
end