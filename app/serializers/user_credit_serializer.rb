class UserCreditSerializer < JSONAPI::Serializable::Resource
  type 'user_credit'
  attributes :id, :credit, :reason, :created_at
end
