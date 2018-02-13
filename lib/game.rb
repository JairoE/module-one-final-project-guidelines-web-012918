class Game < ActiveRecord::Base
  belongs_to :player_one
  belongs_to :player_two
  has_many :pieces

  def initialize()
    @board = [{},{},{},{},{},{}]
    @winner = nil
    coord = 65 #ascii code for capital A

    6.times do |row|
      7.times do |i|
        coordinate = coord.chr + (i+1).to_s #.chr returns character representation of ascii code
        @board[row][coordinate] = nil  #creating empty board w/ positions that are empty
      end
      coord +=1
    end

  end


end
