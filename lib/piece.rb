class Piece < ActiveRecord::Base
  belongs_to :game

  def initialize(color)
    @color = color
  end

end
