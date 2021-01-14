class User < ApplicationRecord
  has_secure_password

  has_many :user_credit

  # i've read this email validator does not cover all cases. I just wanted something simple and fast
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, :uniqueness => true
  validates :name, :presence => true
  validates :password, :presence => true
  validate :password_length, :password_symbols

  def password_length
    if !password.blank? and password.length < 6
      errors.add(:password, "must be at least 6 symbols")
    end
  end

  def password_symbols
    if password !~ /[!@#$%^&*()_+{}\[\]:;'"\/\\?><.,]/
      errors.add(:password, "must include as least one special symbol")
    end
  end

end
