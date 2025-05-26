class CreateBooks < ActiveRecord::Migration[7.1]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.integer :publishing_year
      t.string :genre
      t.string :characters

      t.timestamps
    end
  end
end
