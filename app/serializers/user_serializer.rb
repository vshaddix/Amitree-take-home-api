class UserSerializer < JSONAPI::Serializable::Resource
  type 'user'
  has_many :user_credit

  attributes :id, :name, :email, :referral_code
end
