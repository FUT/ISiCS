# encoding: utf-8
require 'pry'

signal_with_noise = '111 101 101 001 101 100 000 100 100 101 011 111 010 100 110'.split ' '
# puts "signal with noise: #{signal_with_noise}"

words_with_noise = signal_with_noise.each_slice(5).to_a.map(&:reverse).map(&:join).map { |word| word.to_i(2) }
# puts "words with noise: #{ words_with_noise.map { |word| '%015b' % word } }"

alphabet = {
  'а' => '000',
  'р' => '001',
  'м' => '010',
  'и' => '011',
  'я' => '100',
  'т' => '101',
  'у' => '110',
  'ц' => '111'
}
# puts "alphabet: #{alphabet}"

dictionary = %w{армия мария мицар тарту рация марта марат тиара}
# puts "dictionary: #{dictionary}"

alphabet.values.permutation.each do |permutation|
  permutated_alphabet = Hash[alphabet.keys.zip permutation]
  permutated_alphabet_back = Hash[permutation.zip alphabet.keys]
  binary_dictionary = dictionary.map { |word| word.gsub /./, permutated_alphabet }

  binary_dictionary.each do |first_word|
    noise = words_with_noise.first ^ first_word.to_i(2)

    binary_words = words_with_noise.map { |word| '%015b' % (word ^ noise) }
    puts binary_words.map { |word| word.gsub /.../, permutated_alphabet_back }.join(' ') if (binary_dictionary & binary_words).size == 3
  end
end
