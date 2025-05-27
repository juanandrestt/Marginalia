class AddOpenLibraryFieldsToBooks < ActiveRecord::Migration[7.1]
  class AddOpenLibraryFieldsToBooks < ActiveRecord::Migration[7.0]
    def change
      add_column :books, :open_library_id, :string
      add_column :books, :description, :text
      add_column :books, :cover_url, :string
      add_column :books, :subjects, :text
      change_column :books, :characters, :text
      remove_column :books, :genre, :string
    end
  end  
end