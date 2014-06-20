require 'rspec'
require_relative 'network_size_calculator'

describe NetworkSizeCalculator do
  let(:short_dictionary) do
    dictionary = {}
    File.foreach('very_small_test_dictionary.txt') do |line|
      dictionary[line.chomp] = true
    end
    dictionary
  end

  let(:calculator) { NetworkSizeCalculator.new(short_dictionary) }

  describe "#generate_variants" do
    let(:word) { 'HI' }
    let(:variants) { calculator.generate_variants(word) }
    let(:expected_number) { (word.size + 1) * 26 + word.size * 26 + word.size }

    it "does not modify the word itself" do
      calculator.generate_variants(word)
      expect(word).to eq("HI")
    end

    it "deletes each letter of the word" do
      expect(variants).to include("I", "H")
    end

    it "replaces each letter of the word with each letter of the alphabet" do
      expect(variants).to include("AI", "ZI", "HZ")
    end

    it "inserts each letter of the alphabet before and after each letter of the word" do
      expect(variants).to include("AHI", "HIZ", "HJI")
    end

    it "does not generate variants that have an edit distance greater than 1" do
      invalid_variants = variants.select do |v| 
        v.size < word.size - 1 || v.size > word.size + 1
      end
      expect(invalid_variants).to be_empty
    end

    it "generates all variants with an edit distance of 1" do
      expect(variants.size).to eq(expected_number)
    end

    context "when the word only has 1 letter" do
      let(:word) { 'A' }

      it "generates all variants with an edit distance of 1" do
        expect(variants.size).to eq(expected_number)
      end
    end
  end

  describe "#build_network_iteratively" do
    let(:network) { calculator.build_network_iteratively(word) }

    it "returns all the words in the social network" do
      expect(calculator.build_network_iteratively("LISTY").size).to eq(5)
      expect(calculator.build_network_iteratively("LITCHI").size).to eq(2)
    end

    context "when the word is in the dictionary but has no friends" do
      let(:word) { 'LIT' }

      it "returns a network containing just the word" do
        expect(network).to eq({ word => true })
      end
    end

    context "when the word is not in the dictionary and has no friends" do
      let(:word) { 'HI' }

      it "returns a network containing just the word" do
        expect(network).to eq({ word => true })
      end
    end

    context "when the word is not in the dictionary but has friends" do
      let(:word) { 'LITANIEST' }

      it "returns all the words in the social network, including the word itself" do
        expect(network.size).to eq(2)
      end
    end
  end
end