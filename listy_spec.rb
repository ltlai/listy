require 'rspec'
require_relative 'network_size_calculator'

describe NetworkSizeCalculator do
  let(:short_dictionary) {
    dictionary = {}
    File.foreach('very_small_test_dictionary.txt') do |line|
      dictionary[line.chomp] = true
    end
    dictionary
  }

  let(:calculator) { NetworkSizeCalculator.new(short_dictionary) }

  describe "#generate_variants" do
    before(:each) do
      @word = "HI"
    end

    it "does not modify the word itself" do
      calculator.generate_variants(@word)
      expect(@word).to eq("HI")
    end

    it "deletes each letter of the word" do
      expect(calculator.generate_variants(@word)).to include("I", "H")
    end

    it "replaces each letter of the word with each letter of the alphabet" do
      expect(calculator.generate_variants(@word)).to include("AI", "ZI", "HZ")
    end

    it "inserts each letter of the alphabet before and after each letter of the word" do
      expect(calculator.generate_variants(@word)).to include("AHI", "HIZ", "HJI")
    end

    it "does not generate variants that have an edit distance greater than 1" do
      variants = calculator.generate_variants(@word)
      expect((variants.select {|v| v.size < @word.size - 1 || v.size > @word.size + 1}).size).to eq(0)
    end

    it "generates all variants with an edit distance of 1" do
      num_variants = (@word.size + 1) * 26 + @word.size * 26 + @word.size
      expect(calculator.generate_variants(@word).size).to eq(num_variants)
    end

    context "word only has 1 letter" do
      it "generates all variants with an edit distance of 1" do
        word = "A"
        expect(calculator.generate_variants(word).size).to eq(79)
      end
    end
  end

  describe "#build_network_iteratively" do
    context "a word is in the dictionary but has no friends in the dictionary" do
      it "returns a network containing just the word" do
        expect(calculator.build_network_iteratively("LIT")).to eq({"LIT" => true})
      end
    end

    context "a word is not in the dictionary and has no friends in the dictionary" do
      it "returns a network containing just the word" do
        expect(calculator.build_network_iteratively("HI")).to eq({"HI" => true})
      end
    end

    context "a word is not in the dictionary but has friends in the dictionary" do
      it "returns all the words in the social network, including the word itself" do
        expect(calculator.build_network_iteratively("LITANIEST").size).to eq(2)
      end
    end

    it "returns all the words in the social network" do
      expect(calculator.build_network_iteratively("LISTY").size).to eq(5)
      expect(calculator.build_network_iteratively("LITCHI").size).to eq(2)
    end
  end
end