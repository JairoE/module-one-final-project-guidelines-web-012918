class PiecePosition < ActiveRecord::Base
  belongs_to :piece
  belongs_to :position


end
