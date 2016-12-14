class OwnerSerializer < ActiveModel::Serializer
  attributes :first_name, :last_name, :username, :espn_id, :league_manager, :league_creator

  has_many :teams
end
