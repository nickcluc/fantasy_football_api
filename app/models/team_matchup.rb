class TeamMatchup < ApplicationRecord
  belongs_to :team

  after_save :update_total

  protected

  def update_total
    team.total_score = team.sum
    team.save!
  end
end
