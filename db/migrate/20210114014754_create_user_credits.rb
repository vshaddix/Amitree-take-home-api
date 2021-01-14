class CreateUserCredits < ActiveRecord::Migration[6.1]
  def change
    create_table :user_credits do |t|
      t.references :user, null: false, foreign_key: true
      t.bigint :credit
      t.text :reason

      t.timestamps
    end
  end
end
