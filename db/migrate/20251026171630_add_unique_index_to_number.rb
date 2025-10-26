class AddUniqueIndexToNumber < ActiveRecord::Migration[8.0]
  def change
    add_index :policies, :numero, unique: true
  end
end
