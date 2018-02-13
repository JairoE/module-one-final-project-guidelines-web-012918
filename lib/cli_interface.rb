def greet
  puts "Welcome to Connect 0100"
end

def create_users_and_game
  puts "Enter user 1 name"
  username = gets.chomp
  User.create(name: username)
  puts "Enter user 2 name"
  username2 = gets.chomp
  User.create(name: username2)

  still_adding_users = true
  while still_adding_users
    puts "Would you like to add more users or start a game? /n
    Enter 'm' for more players or 's' to start a game..."
    input = gets.chomp
    if input == 's'
      still_adding_users = false
    elsif input == 'm'
      puts "Enter another unique username"
      username = gets.chomp
      #check that input is unique through helpermethod
      #if helper method is unique (i.e, true), create the username
      User.create(name: username)
    else
      puts "Please read carefully and try again :)"
    end
  end

  puts "Which user will be Player 1?"
  username1 = gets.chomp
  puts "Which user will be Player 2?"
  username2 = gets.chomp
  start_game(username1, username2)
end

def start_game(username1, username2)
  username1 = User.find_by_name(username1)
  username2 = User.find_by_name(username2)
  player1 = PlayerOne.create(user: username1)
  player2 = PlayerTwo.create(user: username2)
  board = create_empty_board

  Game.create(player_one: player1, player_two: player2, board: board)
end

def play_game(game)
  puts "Player 1, please choose a color"
  player_one_color = gets.chomp
  #make sure it's a color they can choose
  puts "Player 2, please choose a color"
  player_two_color = gets.chomp
  #make sure it's a color they can choose

  while game.winner_id == nil
    #player_one_goes, if winning condition met, exit loop, else
    player_one_goes(game, player_one_color)
    display_board(game)
    #player_two_goes, if winning condition met, exit loop, else repeat loop
    player_two_goes(game, player_two_color)
    display_board(game)
    game.look_for_winner_in_column

  end

end

def player_one_goes(game, player_one_color)
  puts "Player 1, pick a column to drop your piece in /n
        Please enter a number between 1 and 7"
  input_column = gets.chomp
  #make sure input is between 1 and 7
  #if column is full, ask to enter a different column
  piece = game.create_piece(player_one_color)
  game.place_piece_in_column(piece, input_column.to_i)

end

def player_two_goes(game, player_two_color)
  puts "Player 2, pick a column to drop your piece in /n
        Please enter a number between 1 and 7"
  input_column = gets.chomp
  #make sure input is between 1 and 7
  piece = game.create_piece(player_two_color)
  game.place_piece_in_column(piece, input_column.to_i)
  #if column is full, ask to enter a different column
  #we determine if a column is full if place_piece_in_column returns nil

end

def create_empty_board
  board = [{},{},{},{},{},{},{}]

  7.times do |column|
    coord = 65 #ascii code for capital A
    6.times do |i|
      coordinate = (coord+i).chr + (column+1).to_s #.chr returns character representation of ascii code
      board[column][coordinate] = nil  #creating empty board w/ positions that are empty
    end

  end
  board
end

def display_board(game)
  puts game.board
end
