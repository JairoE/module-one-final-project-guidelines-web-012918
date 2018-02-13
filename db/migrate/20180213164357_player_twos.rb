class PlayerTwos < ActiveRecord::Migration[5.0]
  def change
    create_table :player_twos do |t|
      t.integer :user_id
    end
  end
end
