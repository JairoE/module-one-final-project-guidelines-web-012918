require_relative '../config/environment'

greet
game = create_users_and_game
winner_id = play_game(game)

winner_name = User.find_by_id(winner_id).name
puts "#{winner_name} is the wiener"
