class Piece < ActiveRecord::Base
  has_many :piece_positions
  belongs_to :user 

end
