class CreatePasswordResetKeys < ActiveRecord::Migration[6.0]
  def change
    create_table :password_reset_keys do |t|

      t.string :username
      t.string :reset_key
      t.datetime :expiration

      t.timestamps
    end
  end
end
