class CreateUserReferrals < ActiveRecord::Migration[6.1]
  def change
    create_table :user_referrals do |t|
      t.references :referral, null: false, foreign_key: { to_table: :users }
      t.references :inviter, null: false, foreign_key: { to_table: :users }
      t.boolean :reward_to_inviter_given

      t.timestamps
    end
  end
end
