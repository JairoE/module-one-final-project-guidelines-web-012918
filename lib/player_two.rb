class PlayerTwo < ActiveRecord::Base
  belongs_to :user
  has_many :games
  has_many :pieces, through: :games
end
