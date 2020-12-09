class CreateAuthentications < ActiveRecord::Migration[5.1]
  def change
    create_table :authentications do |t|
      t.string :token
      t.string :expired_at
      t.timestamps
    end
  end
end
