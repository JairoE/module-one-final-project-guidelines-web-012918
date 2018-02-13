class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.integer :winner_id
      t.integer :player_one_id
      t.integer :player_two_id
    end
  end
end
