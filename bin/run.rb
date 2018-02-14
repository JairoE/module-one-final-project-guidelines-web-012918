require_relative '../config/environment'

greet
still_playing = true
while still_playing
  game = create_users_and_game
  winner_id = play_game(game)
  winner_name = User.find_by_id(winner_id).name
  puts "#{winner_name} is the winner"
  puts "Would you like to play another game?"
  puts "Enter [yes] or [no]"
  input = gets.chomp
  if input == "no"
    still_playing = false
  end

end
puts "Goodbye!"
