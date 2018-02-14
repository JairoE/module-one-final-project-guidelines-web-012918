def greet
  puts "Welcome to Connect 0100"
end

def create_users_and_game
  puts "Enter user 1 name" # "Enter a user name"
  username = gets.chomp
  User.create(name: username)
  puts "Enter user 2 name" # "Enter another user name" (repeat this after first name entered - we can have mor than 2)
  username2 = gets.chomp
  User.create(name: username2)

  still_adding_users = true
  while still_adding_users
    puts "Would you like to add more users or start a game?"
    puts "[M] More Players     [S] Start Game"
    # puts "Enter m for more players or s to start a game..."
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

  game = Game.create(player_one: player1, player_two: player2, board: board)
end

def play_game(game)
  playeroneid = game.player_one_id
  playertwoid = game.player_two_id
  puts "#{User.find_by_id(PlayerOne.find_by_id(playeroneid)).name}, please choose a color"
  # puts "#{User.find_by_id(game.player_one_id).name}, please choose a color"
  player_one_color = gets.chomp
  #make sure it's a color they can choose
  puts "#{User.find_by_id(PlayerTwo.find_by_id(playertwoid)).name}, please choose a color"
  # puts "#{User.find_by_id(game.player_two_id).name}, please choose a color"
  player_two_color = gets.chomp
  #make sure it's a color they can choose, and hasn't been chosen by player1
  players_with_chosen_colors = {("p1"+playeroneid.to_s) => player_one_color, ("p2"+playertwoid.to_s) => player_two_color}

  while game.winner_id == nil
    display_board(game)
    potential_winner?(game, players_with_chosen_colors)
    if game.winner_id == nil
      player_one_goes(game, player_one_color, playeroneid) # After player_one turn, if win condition not met, player_two goes, repeat loop. Else win condition met, exit loop.
    end

    display_board(game)
    potential_winner?(game, players_with_chosen_colors)
    if game.winner_id == nil
      player_two_goes(game, player_two_color, playertwoid) # After player_two turn, if win condition not met, repeat loop, player_one goes. Else win condition met, exit loop.
    end

  end

  game.winner_id
end

def player_one_goes(game, player_one_color, playeroneid)
  puts "#{User.find_by_id(playeroneid).name}, pick a column to drop your piece in:"
  puts "(Enter a number between 1 and 7)"
  input_column = gets.chomp
  #make sure input is between 1 and 7
  while input_column.to_i < 1 || input_column.to_i > 7
    puts "(Enter a number between 1 and 7)"
    input_column = gets.chomp
  end
  #if column is full, ask to enter a different column
  piece = game.create_piece(player_one_color)
  column = game.place_piece_in_column(piece, input_column.to_i)
  #if column is full, ask to enter a different column
  #we determine if a column is full if place_piece_in_column returns nil
  while column == nil
    puts "Please enter a different column number. The current column is full!"
    input_column = gets.chomp
    column = game.place_piece_in_column(piece, input_column.to_i)
  end

end

def player_two_goes(game, player_two_color, playertwoid)
  puts "#{User.find_by_id(playertwoid).name}, pick a column to drop your piece in:"
  puts "(Enter a number between 1 and 7)"
  input_column = gets.chomp
  #make sure input is between 1 and 7
  piece = game.create_piece(player_two_color)
  column = game.place_piece_in_column(piece, input_column.to_i)
  #if column is full, ask to enter a different column
  #we determine if a column is full if place_piece_in_column returns nil
  while column == nil
    puts "Please enter a different column number. The current column is full"
    input_column = gets.chomp
    column = game.place_piece_in_column(piece, input_column.to_i)
  end

end

def potential_winner?(game, players_with_chosen_colors)

  potential_winner = game.look_for_winner_in_columns
  if potential_winner
    playerid = players_with_chosen_colors.select do |key, value|
        value == potential_winner
      end #returns hash of p1 or p2 with their associated id in string format as key, value is color
    playerid = playerid.first[0] #first retrieves the first keyvalue pair in hash as an array
    playerobject = playerid[0..1]
    playerid = playerid[2..-1].to_i #gets the player's id

    if playerobject == "p1"
      game.winner_id = PlayerOne.find_by_id(playerid).user_id #set winner_id = USER_id (not player_id)
    else
      game.winner_id = PlayerTwo.find_by_id(playerid).user_id #set winner_id = USER_id (not player_id)
    end

  end

end

def create_empty_board
  board = [[],[],[],[],[],[]]
  coord = 65 #ascii code for capital A

  6.times do |row|
    7.times do |i|
      coordinate = (coord).chr + (i+1).to_s #.chr returns character representation of ascii code
      board[row][i] = coordinate  #creating empty board w/ positions that are empty
    end
    coord +=1
  end
  board
end

def display_board(game)

  rows = []

  game.board.each do |row|
    display_row = []

    row.each do |piece|
      if piece.class == String
        display_row << "   ".colorize(:white).colorize(:background => :white)
      else
        piece.color
        display_row << "   ".colorize(piece.color.to_sym).colorize(:background => piece.color.to_sym)
      end

    end
    rows << display_row
  end

  table = Terminal::Table.new do |t|
    t << rows.last
    t << :separator
    counter = 4
    while counter >= 0
      t.add_row rows[counter]
      t.add_separator
      counter -=1
    end
  end
  puts table
end
