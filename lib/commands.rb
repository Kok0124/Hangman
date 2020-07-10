require 'yaml'

class Save
    def initialize(secret_word, guessed_word, wrong_words, turns_count, all_guesses)
        @secret_word = secret_word
        @guessed_word = guessed_word
        @wrong_words = wrong_words
        @turns_count = turns_count
        @all_guesses = all_guesses
    end

    def save_game
        Dir.mkdir("saves") unless Dir.exists?("saves")
        filename = "saves/save.yaml"
        #File.open(filename, 'w') unless File.exist? filename
        data = { "secret_word" => @secret_word, "guessed_word" => @guessed_word, "wrong_words" => @wrong_words, "turns_count" => @turns_count, "all_guesses" => @all_guesses}
        File.open(filename, 'w') { |file| file.write(data.to_yaml) }
    end
end

class Load
    def load_game
        filename = "saves/save.yaml"
        puts 'No save information found' unless File.exist? filename
        YAML.safe_load(File.read(filename))
      end
end