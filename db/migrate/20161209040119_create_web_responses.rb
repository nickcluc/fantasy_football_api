class CreateWebResponses < ActiveRecord::Migration[5.0]
  def change
    create_table :web_responses do |t|
      t.integer :external_league_id
      t.string  :league_year
      t.text    :response_body
      t.text    :response_request
      
      t.timestamps
    end
  end
end
