class PlayerOne < ActiveRecord::Base
  belongs_to :user
  has_many :pieces, through: :game

  def enter_column(input)
    input
  end
end
