Types::QueryType = GraphQL::ObjectType.define do
  name 'Query'
  # Add root-level fields here.
  # They will be entry points for queries on your schema.
  field :owners, !types[Types::OwnerType] do
    resolve -> (obj, args, ctx) { Owner.all }
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
