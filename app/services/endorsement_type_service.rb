class EndorsementTypeService
  def initialize(policy, endorsement)
    @policy = policy
    @endorsement = endorsement
  end

  def set_type
    return "aumento_is_alteracao_vigencia" if importancia_segurada_increased? && vigencia_changed?
    return "reducao_is_alteracao_vigencia" if importancia_segurada_decreased? && vigencia_changed?
    return "aumento_is" if importancia_segurada_increased?
    return "reducao_is" if importancia_segurada_decreased?
    return "alteracao_vigencia" if vigencia_changed?
  end

  private

  def importancia_segurada_increased?
    @endorsement.importancia_segurada > @policy.importancia_segurada
  end

  def importancia_segurada_decreased?
    @endorsement.importancia_segurada < @policy.importancia_segurada
  end

  def vigencia_changed?
    @endorsement.fim_vigencia != @policy.fim_vigencia
  end
end
