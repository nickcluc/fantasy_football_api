class CreatePlayerResponses < ActiveRecord::Migration[5.2]
  def change
    create_table :player_responses do |t|
      t.text :response_body
      t.text :response_request

      t.timestamps
    end
  end
end
