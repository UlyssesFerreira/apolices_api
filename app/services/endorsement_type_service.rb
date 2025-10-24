class EndorsementTypeService
  class NoChangesError < StandardError; end

  def initialize(policy, new_importancia_segurada, new_fim_vigencia)
    @policy = policy
    @new_importancia_segurada = new_importancia_segurada
    @new_fim_vigencia = new_fim_vigencia
  end

  def set_type
    return "aumento_is_alteracao_vigencia" if importancia_segurada_increased? && vigencia_changed?
    return "reducao_is_alteracao_vigencia" if importancia_segurada_decreased? && vigencia_changed?
    return "aumento_is" if importancia_segurada_increased?
    return "reducao_is" if importancia_segurada_decreased?
    return "alteracao_vigencia" if vigencia_changed?
    raise NoChangesError, "No changes detected"
  end

  private

  def importancia_segurada_increased?
    @new_importancia_segurada > @policy.importancia_segurada
  end

  def importancia_segurada_decreased?
    @new_importancia_segurada < @policy.importancia_segurada
  end

  def vigencia_changed?
    @new_fim_vigencia != @policy.fim_vigencia
  end
end
