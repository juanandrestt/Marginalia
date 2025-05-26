class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.integer :publishing_year
      t.string :genre
      t.string :characters
      t.boolean :read
      t.references :review, null: false, foreign_key: true

      t.timestamps
    end
  end
end
