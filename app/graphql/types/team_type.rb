Types::TeamType = GraphQL::ObjectType.define do
  name 'Team'
  description 'A Fantasy Football Team'

  field :id, !types.ID
  field :league_year, !types.String
  field :name, !types.String
  field :points_for, !types.Int
  field :points_against, !types.Int
  field :wins, !types.Int
  field :losses, !types.Int

  field :owner, Types::OwnerType do
    resolve -> (obj, args, ctx) { obj.owner }
  end
end
