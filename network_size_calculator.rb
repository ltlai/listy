require 'benchmark'

class NetworkSizeCalculator
  attr_reader :dictionary

  def initialize(dictionary_file)
    @dictionary = {}
    File.foreach(dictionary_file) do |line|
      @dictionary[line.chomp] = true
    end
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
  time = Benchmark.measure do
    dictionary = NetworkSizeCalculator.new('dictionary.txt')
    puts dictionary.network_size("LISTY")
  end
  puts time
end