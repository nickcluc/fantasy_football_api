Types::OwnerType = GraphQL::ObjectType.define do
  name 'Owner'
  description 'A Fantasy Football Owner'

  field :id, !types.ID
  field :first_name, !types.String
  field :last_name, !types.String
  field :username, !types.String
  field :espn_id, !types.Int
  field :teams, !types[Types::TeamType]
end
