class UserReferral < ApplicationRecord
  belongs_to :referral, class_name: 'User'
  belongs_to :inviter, class_name: 'User'
end
