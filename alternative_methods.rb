def build_network_recursively_v1(word, network = {word => true})
  @dictionary.each_key do |dict_word|
    if friends?(word, dict_word) && !network[dict_word]
      network[dict_word] = true
      build_network_recursively_v1(dict_word, network)
    end
  end
  return network
end

def build_network_recursively_v2(word, network = {word => true})
  generate_variants(word).each do |variant|
    if @dictionary[variant] && !network[variant]
      network[variant] = true
      build_network_recursively_v2(variant, network)
    end
  end
  return network
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

def generate_variants_v1(word)
  variants = []
  word.length.times do |i|
    variants << word[0...i] + word[(i+1)..-1]    #deletion
    ('A'..'Z').each do |letter|
      variants << word[0...i] + letter + word[(i+1)..-1]    #replacement
    end
  end
  (word.length + 1).times do |i|
    ('A'..'Z').each do |letter|
      variants << word[0...i] + letter + word[i..-1]    #insertion
    end
  end
  variants
end