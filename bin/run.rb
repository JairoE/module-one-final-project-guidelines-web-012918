require_relative '../config/environment'

greet
still_playing = true
game = create_users_and_game

while still_playing
  winner_id = play_game(game)
  winner_name = User.find_by_id(winner_id).name
  puts "#{winner_name} is the winner"
  puts "Would you like to play another game?"
  puts "Enter [Yes] or [No]"
  input = gets.chomp.downcase
  input = check_yes_no_input(input)
  if input == "no"
    still_playing = false
  end

end
enter_the_database
puts "See ya later"
sleep(1)
puts "."
sleep(1)
puts ".."
sleep(1)
puts "..."
sleep(1)
puts ".."
sleep(1)
puts "."
sleep(1)
puts "scrubs"
