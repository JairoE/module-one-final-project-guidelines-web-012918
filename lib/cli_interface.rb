def greet
  show("connect_4_board_splash-tp.png")
  str =
  "    ██████╗ ██████╗ ███╗   ██╗███╗   ██╗███████╗ ██████╗████████╗     ██████╗  ██╗ ██████╗  ██████╗
  ██╔════╝██╔═══██╗████╗  ██║████╗  ██║██╔════╝██╔════╝╚══██╔══╝    ██╔═████╗███║██╔═████╗██╔═████╗
  ██║     ██║   ██║██╔██╗ ██║██╔██╗ ██║█████╗  ██║        ██║       ██║██╔██║╚██║██║██╔██║██║██╔██║
  ██║     ██║   ██║██║╚██╗██║██║╚██╗██║██╔══╝  ██║        ██║       ████╔╝██║ ██║████╔╝██║████╔╝██║
  ╚██████╗╚██████╔╝██║ ╚████║██║ ╚████║███████╗╚██████╗   ██║       ╚██████╔╝ ██║╚██████╔╝╚██████╔╝
   ╚═════╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═╝        ╚═════╝  ╚═╝ ╚═════╝  ╚═════╝"
  puts str
  pid = fork{ exec 'afplay', "connect_fo.mp3" }
  puts ""

  h, w = `stty size`.split.map{|e| e.to_i}
  puts "Welcome to Connect 0100 !!1!".center(w)
  puts ""
end

def show(image)
  Catpix.print_image(image, options = {
    :limit_x => 0.85,
    :limit_y => 0.85,
    # :resolution => "high",
    :center_x => true
    # :center_y => true
    })
end

def create_users_and_game
  puts "Enter username to create your user profile" # "Enter a user name"
  username = gets.chomp
  check_and_create_if_username_is_unique(username)


  puts "Enter username to create your user profile" # "Enter another user name" (repeat this after first name entered - we can have mor than 2)
  username2 = gets.chomp
  check_and_create_if_username_is_unique(username2)


  still_adding_users = true
  while still_adding_users
    puts "Would you like to add more users or start a game?"
    puts "[M] More Players     [S] Start Game"
    # puts "Enter m for more players or s to start a game..."
    input = gets.chomp.downcase
    if input == 's'
      still_adding_users = false
    elsif input == 'm'
      puts "Enter another unique username"
      username = gets.chomp
      check_and_create_if_username_is_unique(username)
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

# def ask_for_more_users_and_create_game
#   puts "Would you like to create more user profiles?"
#   puts "Enter [yes] or [no]"
#   input = gets.chomp
#   if input == "no"
#     puts "Which username will be Player 1?"
#     username1 = gets.chomp
#     puts "Which username will be Player 2?"
#     username2 = gets.chomp
#     start_game(username1, username2)
#   else
#     still_adding_users = true
#     while still_adding_users
#       if input == 's'
#         still_adding_users = false
#       elsif input == 'm'
#         puts "Enter another unique username"
#         username = gets.chomp
#         check_and_create_if_username_is_unique(username)
#       else
#         puts "Please read carefully and try again :)"
#       end
#     end
#   end
#
# end

def check_and_create_if_username_is_unique(username)
  while User.find_by_name(username)
    puts "Username is taken. Please enter a unique username"
    username = gets.chomp
  end
  User.create(name: username)
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
  color_list = "#{'[Red]'.colorize(:red)}  #{'[Blue]'.colorize(:blue)}  #{'[Green]'.colorize(:green)}  #{'[Yellow]'.colorize(:yellow)}  #{'[Magenta]'.colorize(:magenta)}  #{'[Cyan]'.colorize(:cyan)}"
  color_array = ["red", "blue", "green", "yellow", "magenta", "cyan"]

  puts "#{User.find_by_id(PlayerOne.find_by_id(playeroneid).user_id).name.strip}, please choose a color:"
  puts color_list

  player_one_color = gets.chomp.downcase
  until color_array.include?(player_one_color)
    puts "Please read the list carefully"
    puts color_list
    player_one_color = gets.chomp.downcase
  end
  remaining_colors_list = color_list.split("  ").reject{|color| color.include?("[" + player_one_color.capitalize + "]")}
  remaining_colors_list = remaining_colors_list.join("  ")

  # binding.pry
  remaining_colors_array = color_array.reject{|color| color == player_one_color}
  puts "#{User.find_by_id(PlayerTwo.find_by_id(playertwoid).user_id).name.strip}, please choose a color:"

  puts remaining_colors_list

  player_two_color = gets.chomp.downcase
  until remaining_colors_array.include?(player_two_color)
    puts "Please read the list carefully"
    puts remaining_colors_list
    player_two_color = gets.chomp.downcase
  end

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
  Game.update(game.id, winner_id: game.winner_id, board: game.board)
  game.winner_id
end

def player_one_goes(game, player_one_color, playeroneid)
  puts "#{User.find_by_id(PlayerOne.find_by_id(playeroneid).user_id).name.strip}, pick a column to drop your piece in:"
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
  puts "#{User.find_by_id(PlayerTwo.find_by_id(playertwoid).user_id).name.strip}, pick a column to drop your piece in:"
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

  potential_winner_in_columns = game.look_for_winner_in_columns
  if potential_winner_in_columns
    potential_winner_helper(game, potential_winner_in_columns, players_with_chosen_colors)
  else
    potential_winner_in_rows = game.look_for_winner_in_rows
    if potential_winner_in_rows
      potential_winner_helper(game, potential_winner_in_rows, players_with_chosen_colors)
    end
  end

end

def potential_winner_helper(game, potential_winner, players_with_chosen_colors)
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
  rows << [1,2,3,4,5,6,7]
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
    counter = 5
    while counter >= 0
      t.add_row rows[counter]
      if counter != 0
        t.add_separator
      end
      counter -=1
    end
    t.style = {:border_bottom => false }
  end
  puts " "
  puts table
end

def enter_the_database
  puts "Would you like to access a user_profile?"
  puts "Enter [Yes] or [No]"
  input = gets.chomp.downcase
  input = check_yes_no_input(input)
  if input == "no"
    nil
  else
    user_database_questions
  end
end

def user_database_questions
  puts "Whose user profile would you like to see more information about?"
  puts "Enter username"

  input = gets.chomp
  userid = User.find_by_name(input).id
  playerone_ids = PlayerOne.where("user_id = #{userid}")
  playerone_ids = playerone_ids.map{|p1| p1.id}
  playertwo_ids = PlayerTwo.where("user_id = #{userid}")
  playertwo_ids = playertwo_ids.map{|p2| p2.id}

  games_won_as_p1 = []
  playerone_ids.each do |id|
    game = Game.where("player_one_id = #{id}")[0].winner_id
    if game == userid
      games_won_as_p1 << game
    end
  end

  games_won_as_p2 = []
  playertwo_ids.each do |id|
    game = Game.where("player_two_id = #{id}")[0].winner_id
    if game == userid
      games_won_as_p1 << game
    end
  end


  num_of_games_won = (games_won_as_p1 + games_won_as_p2).size
  puts "#{input} has won #{num_of_games_won} games"
end

def check_yes_no_input(input)
  while input != "no" && input != "yes"
    puts "... funny. try again"
    puts "Enter [Yes] or [No]"
    input = gets.chomp.downcase
  end
  input
end
