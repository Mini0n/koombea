class CreateContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts do |t|
      t.string :name, null: false
      t.date :birth, null: false
      t.string :phone, null: false
      t.string :address, null: false
      t.string :card, null: false
      t.string :card_nums, null: false
      t.string :franchise, null: false
      t.string :email, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
