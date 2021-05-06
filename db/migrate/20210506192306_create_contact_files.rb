class CreateContactFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :contact_files do |t|
      t.string :name, null: false
      t.string :status, null: false
      t.integer :lines, null: false
      t.text :columns, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
