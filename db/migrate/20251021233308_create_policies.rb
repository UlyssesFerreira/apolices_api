class CreatePolicies < ActiveRecord::Migration[8.0]
  def change
    create_table :policies do |t|
      t.string :numero
      t.date :data_emissao
      t.date :inicio_vigencia
      t.date :fim_vigencia
      t.decimal :importancia_segurada
      t.decimal :lmg

      t.timestamps
    end
  end
end
