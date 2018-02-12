class Game < ActiveRecord::Base
  has_many :users
  has_many :pieces, through: :users
  has_many :positions
  has_many :piece_positions, through: :positions

  def initialize()
    @board = [[],[],[],[],[],[]]
    @winner = nil 
    coord = 65 #ascii code for capital A

    6.times do |row|
      7.times do |i|
        coordinate = coord.chr + (i+1).to_s
        @board[row] << Position.new(coordinate)
        @board[row].add_piece_to_position(nil)
      end
      coord +=1
    end

  end


end
