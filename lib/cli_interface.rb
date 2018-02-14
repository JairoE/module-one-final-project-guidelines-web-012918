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

  game = Game.create(player_one: player1, player_two: player2, board: board)
end

def play_game(game)
  puts "Player 1, please choose a color"
  player_one_color = gets.chomp
  #make sure it's a color they can choose
  puts "Player 2, please choose a color"
  player_two_color = gets.chomp
  #make sure it's a color they can choose, and hasn't been chosen by player1
  playeroneid = game.player_one_id
  playertwoid = game.player_two_id
  players_with_chosen_colors = {("p1"+playeroneid.to_s) => player_one_color, ("p2"+playertwoid.to_s) => player_two_color}

  while game.winner_id == nil
    #player_one_goes, if winning condition met, exit loop, else
    display_board(game)
    player_one_goes(game, player_one_color)
    display_board(game)
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
    #player_two_goes, if winning condition met, exit loop, else repeat loop
    player_two_goes(game, player_two_color)
    display_board(game)
    # potential_winner = game.look_for_winner_in_columns
    # if potential_winner
    #   game.winner_id = potential_winner
    # end


  end

  game.winner_id
end

def player_one_goes(game, player_one_color)
  puts "Player 1, pick a column to drop your piece in /n
        Please enter a number between 1 and 7"
  input_column = gets.chomp
  #make sure input is between 1 and 7
  while input_column.to_i < 1 || input_column.to_i > 7
    puts "Please enter a number between 1 and 7"
    input_column = gets.chomp
  end
  #if column is full, ask to enter a different column
  piece = game.create_piece(player_one_color)
  column = game.place_piece_in_column(piece, input_column.to_i)
  #if column is full, ask to enter a different column
  #we determine if a column is full if place_piece_in_column returns nil
  while column == nil
    puts "Please enter a different column number. The current column is full"
    column = game.place_piece_in_column(piece, input_column.to_i)
  end

end

def player_two_goes(game, player_two_color)
  puts "Player 2, pick a column to drop your piece in /n
        Please enter a number between 1 and 7"
  input_column = gets.chomp
  #make sure input is between 1 and 7
  piece = game.create_piece(player_two_color)
  column = game.place_piece_in_column(piece, input_column.to_i)
  #if column is full, ask to enter a different column
  #we determine if a column is full if place_piece_in_column returns nil
  while column == nil
    puts "Please enter a different column number. The current column is full"
    column = game.place_piece_in_column(piece, input_column.to_i)
  end

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

# def look_for_winner_in_game(game, players_and_colors)
#   winners_color = game.look_for_winner_in_column
#   if winner
#     players_and_colors.each do |player_nd_color|
#       if player_nd_color.values[0] == winner
#
#     end
#   else
#     nil
#   end
# end

def display_board(game)
  rows = []
  game.board.each do |column|
    row = []
    column.each do |coordinate, piece|
      if piece == nil
        row << coordinate
      else
        row << piece.color
      end 

    end
    rows << row
  end

  # rows << ["a1","a2","a3","a4","a5","a6","a7"]
  # rows << ["b1","b2","b3","b4","b5","b6","b7"]
  # rows << ["c1","c2","c3","c4","c5","c6","c7"]
  # rows << ["d1","d2","d3","d4","d5","d6","d7"]
  # rows << ["e1","e2","e3","e4","e5","e6","e7"]
  # rows << ["f1","f2","f3","f4","f5","f6","f7"]

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
