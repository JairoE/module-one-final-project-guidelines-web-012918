class User < ActiveRecord::Base

  belongs_to :game
  has_many :pieces
  has_many :piece_positions, through: :pieces
end
