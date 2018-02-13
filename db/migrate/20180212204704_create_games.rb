class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.integer :winner_id
      t.integer :user1_id
      t.integer :user2_id
    end
  end
end
