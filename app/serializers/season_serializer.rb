class SeasonSerializer
  include FastJsonapi::ObjectSerializer
  attributes :league_year,
    :first_week_date

  belongs_to :champion
  belongs_to :second_place
  belongs_to :third_place
  belongs_to :last_place
end
