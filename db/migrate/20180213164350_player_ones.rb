class PlayerOnes < ActiveRecord::Migration[5.0]
  def change
    create_table :player_ones do |t|
      t.integer :user_id
    end
  end
end
