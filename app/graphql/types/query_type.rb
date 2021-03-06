Types::QueryType = GraphQL::ObjectType.define do
  name 'Query'

  field :owners, !types[Types::OwnerType] do
    resolve -> (obj, args, ctx) { Owner.all }
  end

  field :teams, !types[Types::TeamType] do
    resolve -> (obj, args, ctx) { Team.all }
  end

  field :owner do
    type Types::OwnerType
    argument :id, !types.ID
    description 'Find an Owner by ID'
    resolve ->(obj, args, ctx) { Owner.find(args['id']) }
  end

  field :team do
    type Types::TeamType
    argument :id, !types.ID
    description 'Find a Team by ID'
    resolve ->(obj, args, ctx) { Team.find(args['id']) }
  end
end
