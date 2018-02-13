def greet
  "Welcome to Connect 0100"
end

def create_users_and_game
  puts "Enter player 1 name"
  username = gets.chomp
  User.new(username)
  puts "Enter player 2 name"
  username2 = gets.chomp
  User.new(username2)

  still_adding_users = true
  while still_adding_users
    puts "Would you like to add more players or start a game? /n
    Enter 'm' for more players or 's' to start a game..."
    input = gets.chomp
    if input == 's'
      still_adding_users = false
    elsif input == 'm'
      puts "Enter another unique username"
      username = gets.chomp
      #check that input is unique through helpermethod
      #if helper method is unique (ie, true), create the username
      User.new(username)
    else
      "Please read carefully :)"
    end
  end

  puts "Who will be Player 1?"
  username1 = gets.chomp
  puts "Who will be Player 2?"
  username2 = gets.chomp
  start_game(username1, username2)
end

def start_game(username1, username2)
  username1 = User.find_by_name(username1)
  username2 = User.find_by_name(username2)
  player1 = Player1.new(username1)
  player2 = Player2.new(username2)
  Game.new(player1, player2)
end

def play_game(game)

end
