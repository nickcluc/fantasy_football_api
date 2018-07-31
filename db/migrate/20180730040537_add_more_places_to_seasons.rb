class AddMorePlacesToSeasons < ActiveRecord::Migration[5.2]
  def change
    add_column :seasons, :second_place_id, :integer
    add_column :seasons, :third_place_id, :integer
    add_column :seasons, :last_place_id, :integer
  end
end
