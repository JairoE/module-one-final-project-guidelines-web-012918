class Game < ActiveRecord::Base
  has_many :users
  has_many :pieces, through: :users
  has_many :positions
  
end
