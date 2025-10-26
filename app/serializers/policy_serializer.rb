class PolicySerializer < ActiveModel::Serializer
  attributes :id,
             :numero,
             :status,
             :data_emissao,
             :inicio_vigencia,
             :fim_vigencia,
             :importancia_segurada,
             :lmg,
             :importancia_segurada_original,
             :fim_vigencia_original,
             :created_at,
             :updated_at

  has_many :endorsements

  def importancia_segurada
    object.importancia_segurada.to_f
  end

  def lmg
    object.lmg.to_f
  end

  def importancia_segurada_original
    object.importancia_segurada_original.to_f
  end
end
