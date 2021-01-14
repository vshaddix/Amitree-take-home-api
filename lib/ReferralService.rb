class ReferralService
  # We want to credit each newly created user with referral link with 10$
  # To do that, we need to also store a record indicating this user registered with a referral code.
  # So we can later on credit the inviter and keep a nice track of logs of what happened.
  def credit_newly_registered_user(referral, inviter)
    credit_given = UserReferral.find_by(referral_id: referral.id)

    if credit_given != nil
      # todo throw error
    end

    user_referral = UserReferral.new(
                      referral: referral,
                      inviter: inviter,
                      reward_to_inviter_given: false,
                      created_at: Time.now,
                      updated_at: Time.now)

    if user_referral.save
      inviter_credit = UserCredit.new(
                         reason: "The registration process successfully finished!",
                         user_id: referral.id,
                         credit: 10,
                         created_at: Time.now,
                         updated_at: Time.now)
      inviter_credit.save
    end
  end

  # After each newly registered user using the referral code we would like to credit the inviter as well.
  # There is a precondition: Every 5 referrals grand 10$ to our inviter.
  def credit_inviter(user)
    user_referrals = UserReferral.where(inviter_id: user.id).where(reward_to_inviter_given: false)

    if user_referrals.count() === 5
      names = ""
      ActiveRecord::Base.transaction do

        # This could be one sql query with UPDATE user_referral table based on inviter_id.
        # Just wanted to try out the each loop
        user_referrals.each do |user_referral|
          user_referral.reward_to_inviter_given = true
          user_referral.updated_at = Time.now

          user_referral.save

          names += ", " if names === ""
          names += user_referral.referral.name
        end

        inviter_credit = UserCredit.new(
                           reason: names + " have successfully finished the registration process!",
                           user_id: user.id,
                           credit: 10,
                           created_at: Time.now,
                           updated_at: Time.now)
        inviter_credit.save
      end
    end
  end
end