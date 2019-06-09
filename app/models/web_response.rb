class WebResponse < ApplicationRecord
  has_many :teams

  def teams
    JSON.parse(response_body)["leaguesettings"]["teams"].values
  end

  def metadata
    JSON.parse(response_body)["metadata"]
  end
end
