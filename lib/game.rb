class Game < ActiveRecord::Base
  belongs_to :player_one
  belongs_to :player_two
  has_many :pieces
  serialize :board, Array

  def create_piece(color)
    Piece.create(color: color)
  end

  def place_piece_in_column(piece, column_number)
    array_of_empty_rows_in_column = nil

    row_number = nil

    self.board.each_with_index do |row, index|
      if row[column_number - 1].class == String && row_number == nil
        row_number = index
      end
    end

    if row_number
      self.board[row_number][column_number-1] = piece
      pid = fork{ exec 'afplay', "piece_drop.mp3" }
    else
      nil # returning nil creates infinite loop?
    end

  end

  def look_for_winner_in_columns
    #first find 4consecutive colored pieces in a column
    previous_color = nil
    column = 0
    four_consecutive_pieces = 0

    while column < 7 && four_consecutive_pieces < 4
      four_consecutive_pieces = 0
      self.board.each_with_index do |row, index|
        current_piece = board[index][column]
        if current_piece.class != String && previous_color == nil && four_consecutive_pieces < 4
          previous_color = current_piece.color
          four_consecutive_pieces +=1
        elsif current_piece.class != String && previous_color != nil && four_consecutive_pieces < 4
          if previous_color == current_piece.color
            four_consecutive_pieces +=1
          else
            previous_color = current_piece.color
            four_consecutive_pieces = 1 #reset incrementer if current piece isn't the same as previous
          end
        elsif current_piece.class == String && four_consecutive_pieces < 4
          previous_color = nil #if code reaches this line, then current_piece is nil
          four_consecutive_pieces = 0
        end
        # binding.pry
      end
      column +=1
    end

    if four_consecutive_pieces == 4
      previous_color
    else
      nil
    end
  end

  def look_for_winner_in_rows
    previous_color = nil
    four_consecutive_pieces = 0

    self.board.each do |row|
      row.each do |current_piece|
        if current_piece.class != String && previous_color == nil && four_consecutive_pieces < 4
          previous_color = current_piece.color
          four_consecutive_pieces +=1
        elsif current_piece.class != String && previous_color != nil && four_consecutive_pieces < 4
          if previous_color == current_piece.color
            four_consecutive_pieces +=1
          else
            previous_color = current_piece.color
            four_consecutive_pieces = 1 #reset incrementer if current_piece isn't the same as previous
          end
        elsif current_piece.class == String && four_consecutive_pieces < 4
          previous_color = nil #if code reaches this line, then current_piece is nil
          four_consecutive_pieces = 0
        end
      end
    end

    if four_consecutive_pieces == 4
      previous_color
    else
      nil
    end
  end


end
