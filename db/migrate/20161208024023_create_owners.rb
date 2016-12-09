class CreateOwners < ActiveRecord::Migration[5.0]
  def change
    create_table :owners do |t|
      t.string :first_name
      t.string :last_name
      t.string :username
      t.integer :espn_id
      t.boolean :league_manager
      t.boolean :league_creator
      
      t.timestamps
    end
  end
end
