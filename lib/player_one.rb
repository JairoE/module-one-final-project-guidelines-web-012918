class PlayerOne < ActiveRecord::Base
  belongs_to :user
  has_many :pieces, through: :games

end
