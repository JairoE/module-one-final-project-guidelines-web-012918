require_relative '../config/environment'

greet
game = create_users_and_game
while game.winner_id == nil
  play_game(game)
end 
