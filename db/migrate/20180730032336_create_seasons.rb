class CreateSeasons < ActiveRecord::Migration[5.2]
  def change
    create_table :seasons do |t|
      t.integer :league_year, null: false
      t.date :first_week_date, null: false
      t.integer :champion_id

      t.timestamps
    end
  end
end
