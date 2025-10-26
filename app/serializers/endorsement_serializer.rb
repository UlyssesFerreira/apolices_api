class EndorsementSerializer < ActiveModel::Serializer
  attributes :id,
             :policy_id,
             :data_emissao,
             :tipo,
             :importancia_segurada,
             :inicio_vigencia,
             :fim_vigencia,
             :cancelled_endorsement_id,
             :created_at

  def importancia_segurada
    object.importancia_segurada.to_f
  end
end
