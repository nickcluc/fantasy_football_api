Types::OwnerType = GraphQL::ObjectType.define do
  name 'Owner'
  description 'A Fantasy Football Owner'

  field :id, !types.ID
  field :first_name, !types.String
  field :last_name, !types.String
  field :full_name, types.String
  field :username, !types.String
  field :espn_id, !types.Int
  field :total_points, types.Int
  field :total_points_against, types.Int
  field :career_length, types.Int
  field :career_wins, types.Int
  field :career_losses, types.Int

  field :teams, !types[Types::TeamType]
end
