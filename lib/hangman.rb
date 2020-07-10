require_relative './commands.rb'

class Hangman

    def initialize
        @secret_word = "" # this is needed, so secret_word is not nil beacuse that would break the next line
        @secret_word = (File.read "5desk.txt").split(" ").sample.downcase until @secret_word.length.between?(5, 12) # this is a string
        @guessed_word = Array.new(@secret_word.length, "_")
        @wrong_words = []
        @turns_count = 16
        @all_guesses = [];
    end

    def print_curent_state
        print "WORD: "
        @guessed_word.each do |value|
            print "#{value} "
        end
        puts "\n\n"
        print "MISSES: "
        @wrong_words.each do |letter|
            print "#{letter}, "
        end
        puts "\n\n"
        puts "Turns left: #{@turns_count} \n\n"
    end

    def validate_input(input)
        if input.match(/^[a-z]$/)
            return true
        end
        return false
    end

    def already_guessed?(input)
        return @all_guesses.include?(input)
    end

    def check_for_matches(input)
        temp_flag = false
        @secret_word.chars.each_with_index do |value, index|
            if input == value
                @guessed_word[index] = input
                temp_flag = true
            end
        end
        temp_flag == true ? true : false
    end

    def command?(input)
        return input == "save" || input == "load"
    end

    def execute_command(command)
        if command == "save"
            @save = Save.new(@secret_word, @guessed_word, @wrong_words, @turns_count, @all_guesses)
            @save.save_game
            puts "Game saved Successfully"
        end
        if command == "load"
            @load = Load.new
            lo = @load.load_game
            @secret_word = lo["secret_word"]
            @guessed_word = lo["guessed_word"]
            @wrong_words = lo["wrong_words"]
            @turns_count = lo["turns_count"]
            @all_guesses = lo["all_guesses"];
            puts "Game loaded Succesfully"
        end
    end

    def play # Maybe i should break this to smaller functions, but right now I'm too lazy to do that
        puts"If you want so save the game, jsut type 'save' or if you want to load the saved game just type 'load'. Game has only one save slot"
        while @turns_count != 0 do
            print_curent_state
            print "GUESS: "
            guessed_letter = gets.chomp.downcase
            if command?(guessed_letter)
                execute_command(guessed_letter)
            else

                puts "\n\n"
                if(validate_input(guessed_letter) && !already_guessed?(guessed_letter))
                    @all_guesses.push(guessed_letter)
                    if check_for_matches(guessed_letter) 
                        if @guessed_word == @secret_word.chars
                            puts "YOU WON !!! As you guessed it, the secret word is: #{@secret_word}"
                            return
                        end
                    else
                        puts "Wrong letter"
                        @wrong_words.push(guessed_letter)
                    end
                    @turns_count -= 1
                else
                    puts "Please enter a single letter that you have not guessed yet"
                end 
                puts "\n\n\n\n"

            end
        end
        puts "You Lost :(. The secret word was: #{@secret_word}"
    end



end
