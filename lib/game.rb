class Game < ActiveRecord::Base
  belongs_to :player_one
  belongs_to :player_two
  has_many :pieces
  serialize :board, Array

  def create_piece(color)
    Piece.create(color: color)
  end

  def place_piece_in_column(piece, column_number)
    array_of_empty_rows_in_column = self.board[(column_number - 1)].select do |coordinate, value|
        value == nil
      end

    if array_of_empty_rows_in_column.empty?
      nil
    else
      row = array_of_empty_rows_in_column.first #contains first coordinate that is empty, which should be the coordinate lowest in the column.
      self.board[column_number-1][row[0]] = piece
    end
  end

  def look_for_winner_in_column
    #first find 4consecutive colored pieces in a column
    previous_color = nil
    column = 0

    while column < 7
      
      four_consecutive_pieces = 0
      self.board[column].each do |row, current_piece|
        if current_piece != nil && previous_color == nil && four_consecutive_pieces < 4
          previous_color = current_piece.color
          four_consecutive_pieces +=1
        elsif current_piece != nil && previous_color != nil && four_consecutive_pieces < 4
          if previous_color == current_piece.color
            four_consecutive_pieces +=1
          else
            four_consecutive_pieces = 0 #reset incrementer if current piece isn't the same as previous
            previous_color = current_piece.color
          end
        elsif current_piece == nil && four_consecutive_pieces < 4
          previous_color = nil #if code reaches this line, then current_piece is nil
          four_consecutive_pieces = 0
        end
      end
      column +=1
    end

    if four_consecutive_pieces == 4
      previous_color
    else
      nil
    end
  end

end
