class Game < ActiveRecord::Base
  belongs_to :player_one
  belongs_to :player_two
  has_many :pieces
  serialize :board, Array

end
