class CreatePiecePositions < ActiveRecord::Migration[5.0]
  def change
    create_table :piece_positions do |t|
      t.integer :position_id
      t.string :piece_id
    end
  end
end
