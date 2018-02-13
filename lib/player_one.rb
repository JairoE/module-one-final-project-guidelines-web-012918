class PlayerOne
  belongs_to :user
  has_many :pieces, through: :game

end
