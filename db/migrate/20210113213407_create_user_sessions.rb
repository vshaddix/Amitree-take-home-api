class CreateUserSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :user_sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :expires_on
      t.text :data
      t.string :hash_representation

      t.timestamps
    end
  end
end
