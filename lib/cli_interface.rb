def greet
  "Welcome to Connect 0100"
end

def create_users_and_game
  puts "Enter player 1 name"
  username = gets.chomp
  User.create(name: username)
  puts "Enter player 2 name"
  username2 = gets.chomp
  User.create(name: username2)

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
      #if helper method is unique (i.e, true), create the username
      User.create(name: username)
    else
      "Please re-read carefully :)"
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
  player1 = PlayerOne.create(user: username1)
  player2 = PlayerTwo.create(user: username2)
  board = create_empty_board

  Game.create(player_one: player1, player_two: player2, board: board)
end

def play_game(game)

end

def create_empty_board
  board = [{},{},{},{},{},{}]
  coord = 65 #ascii code for capital A

  6.times do |row|
    7.times do |i|
      coordinate = coord.chr + (i+1).to_s #.chr returns character representation of ascii code
      board[row][coordinate] = nil  #creating empty board w/ positions that are empty
    end
    coord +=1
  end
  board
end
