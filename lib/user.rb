class User < ActiveRecord::Base
  has_many :player_ones
  has_many :player_twos
  has_many :games, through: :player_ones
  has_many :games, through: :player_twos

end
