require_relative '../config/environment'

greet
game = create_users_and_game
still_playing = true
while still_playing
  winner_id = play_game(game)
  winner_name = User.find_by_id(winner_id).name
  puts "#{winner_name} is the winner"
  puts "Would you like to play another game?"
end
