class Position < ActiveRecord::Base
  belongs_to :game
  has_many :piece_positions

  def initialize(coordinate)
    @coordinate = coordinate
  end

  def add_piece_to_position(piece)
    PiecePosition.new(piece, self)
  end

end
