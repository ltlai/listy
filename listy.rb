DICTIONARY = ("FIST
FISTS
LISTS
LISTY
LIT
LITAI
LITANIES
LITANY
LITAS
LITCHI
LITCHIS
LUSTY").split("\n")

def network_size(word)
  build_network_faster(word).size
end

def build_network(word, network = {word => true})
  DICTIONARY.each do |dict_word|
    if friends?(word, dict_word) && !network[dict_word]
      network[dict_word] = true
      build_network(dict_word, network)
    end
  end
  return network
end

def build_network_faster(word, network = {word => true})
  find_variants(word).each do |variant|
    if DICTIONARY.include?(variant) && !network[variant]
      network[variant] = true
      build_network_faster(variant, network)
    end
  end
  puts network
  return network
end

def find_variants(word)
  variants = []
  word.length.times do |i|
    variants << word[0...i] + word[(i+1)..-1]
    ('A'..'Z').each do |letter|
      variants << word[0...i] + letter + word[(i+1)..-1]
      variants << word[0...i] + letter + word[i..-1]
    end
  end
  variants
end

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

##############################

puts network_size("LISTY")
puts

puts num_letters_diff("HI", "HE") == 1
puts num_letters_diff("HEAR", "HEIR") == 1
puts num_letters_diff("VOWEL", "TOWEL") == 1
puts num_letters_diff("HEAR", "HERE") == 2
puts
puts insertion_or_deletion?("HE", "SHE") == true
puts insertion_or_deletion?("HE", "HER") == true
puts insertion_or_deletion?("HEAR", "HER") == true
puts insertion_or_deletion?("HEAT", "HATE") == false
puts insertion_or_deletion?("HEAT", "HATER") == false