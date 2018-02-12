class Piece < ActiveRecord::Base
  has_many :piece_positions
  belongs_to :user

  def initialize(color)
    @color = color
  end

end
