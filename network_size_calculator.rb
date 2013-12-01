require 'benchmark'

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
    return network
  end

  def generate_variants(word)
    word = word.dup
    variants = []
    word.length.times do |i|
      variants << (word[0...i] << word[(i+1)..-1])    #deletion
      original_letter = word[i]
      ('A'..'Z').each do |letter|
        word[i] = letter    #replacement
        variants << word.dup
      end
      word[i] = original_letter
    end
    (word.length + 1).times do |i|
      word.insert(i, "_")
      ('A'..'Z').each do |letter|
        word[i] = letter    #insertion
        variants << word.dup
      end
      word[i] = ""
    end
    variants
  end
end


if __FILE__==$0
  dictionary = {}
  File.foreach('eighth_dictionary.txt') do |line|
      dictionary[line.chomp] = true
  end
  time = Benchmark.measure do
    dict = NetworkSizeCalculator.new(dictionary)
    puts dict.network_size("LISTY")
  end
  puts time
end