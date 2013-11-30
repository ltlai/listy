require 'rspec'
require_relative 'listy'

describe NetworkSizeCalculator do
  describe "#initialize" do
    it "creates an element in @dictionary for each word in the dictionary text file" do
      small = NetworkSizeCalculator.new('very_small_test_dictionary.txt')
      expect(small.dictionary).to eq({ "FIST" => true, "FISTS" => true, "LISTS" => true, "LISTY" => true, "LIT" => true, "LITAI" => true, "LITANIES" => true, "LITANY" => true, "LITAS" => true, "LITCHI" => true, "LITCHIS" => true, "LUSTY" => true })
    end
  end
end