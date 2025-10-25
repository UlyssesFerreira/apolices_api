class AddOriginalFieldsToPolicies < ActiveRecord::Migration[8.0]
  def change
    add_column :policies, :importancia_segurada_original, :decimal
    add_column :policies, :fim_vigencia_original, :date
  end
end
