class CreateContactErrors < ActiveRecord::Migration[6.0]
  def change
    create_table :contact_errors do |t|
      t.text :line, null: false
      t.integer :line_number, null: false
      t.text :import_errors, null: false
      t.text :attempt, null: false
      t.references :user, null: false, foreign_key: true
      t.references :contact_file, null: false, foreign_key: true

      t.timestamps
    end
  end
end
