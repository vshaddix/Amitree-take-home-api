class UserReferral < ApplicationRecord
  belongs_to :referral
  belongs_to :inviter
end
