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
      find_variants(current_variant).each do |variant|
        if @dictionary[variant] && !network[variant]
          network[variant] = true
          stack << variant
        end
      end
    end
    return network
  end

  # def build_network_recursively(word, network = {word => true})
  #   @dictionary.each_key do |dict_word|
  #     if friends?(word, dict_word) && !network[dict_word]
  #       puts dict_word
  #       network[dict_word] = true
  #       build_network(dict_word, network)
  #     end
  #   end
  #   return network
  # end

  # def build_network_recursively_v2(word, network = {word => true})
  #   find_variants_faster(word).each do |variant|
  #     if @dictionary[variant] && !network[variant]
  #       network[variant] = true
  #       build_network_faster(variant, network)
  #     end
  #   end
  #   return network
  # end

  def find_variants(word)
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

  # def find_variants_v1(word)
  #   variants = []
  #   word.length.times do |i|
  #     variants << (word[0...i] << word[(i+1)..-1])    #deletion
  #     ('A'..'Z').each do |letter|
  #       variants << (word[0...i] << letter << word[(i+1)..-1])    #replacement
  #     end
  #   end
  #   (word.length + 1).times do |i|
  #     ('A'..'Z').each do |letter|
  #       variants << (word[0...i] << letter << word[i..-1])    #insertion
  #     end
  #   end
  #   variants
  # end

  def friends?(word_1, word_2)
    if (word_1.length - word_2.length).abs > 1
      return false
    end
    if word_1.length == word_2.length
      return num_letters_diff(word_1, word_2) == 1
    end
    return insertion_or_deletion?(word_1, word_2)
  end

  def num_letters_diff(word_1, word_2)  # For words of same length
    num_diff = 0
    word_1.length.times do |i|
      if word_1[i] != word_2[i]
        num_diff += 1
      end
    end
    num_diff
  end

  def insertion_or_deletion?(word_1, word_2)
    if word_1.length > word_2.length
      longer_word, shorter_word = word_1.split(""), word_2.split("")
    else
      longer_word, shorter_word = word_2.split(""), word_1.split("")
    end
    longer_word.length.times do |i|
      if longer_word[i] != shorter_word[i]
        longer_word.delete_at(i)
        return longer_word == shorter_word
      end
    end
  end
end

##############################

if __FILE__==$0
  time = Benchmark.measure do
    full_dictionary = NetworkSizeCalculator.new('dictionary.txt')
    puts full_dictionary.network_size("LISTY")
  end
  puts time
end

# puts

# puts num_letters_diff("HI", "HE") == 1
# puts num_letters_diff("HEAR", "HEIR") == 1
# puts num_letters_diff("VOWEL", "TOWEL") == 1
# puts num_letters_diff("HEAR", "HERE") == 2
# puts
# puts insertion_or_deletion?("HE", "SHE") == true
# puts insertion_or_deletion?("HE", "HER") == true
# puts insertion_or_deletion?("HEAR", "HER") == true
# puts insertion_or_deletion?("HEAT", "HATE") == false
# puts insertion_or_deletion?("HEAT", "HATER") == false