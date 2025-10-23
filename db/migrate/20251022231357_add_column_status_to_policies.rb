class AddColumnStatusToPolicies < ActiveRecord::Migration[8.0]
  def change
    add_column :policies, :status, :integer, default: 0
  end
end
