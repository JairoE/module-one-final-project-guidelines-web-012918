class Position < ActiveRecord::Base
  belongs_to :game
  has_many :piece_positions
  
end
