class CreateEndorsements < ActiveRecord::Migration[8.0]
  def change
    create_table :endorsements do |t|
      t.references :policy
      t.date :data_emissao
      t.string :tipo
      t.decimal :importancia_segurada
      t.date :inicio_vigencia
      t.date :fim_vigencia

      t.timestamps
    end
  end
end
