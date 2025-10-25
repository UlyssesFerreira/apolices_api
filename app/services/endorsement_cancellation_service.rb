class EndorsementCancellationService
  class Result
    attr_reader :success, :endorsement, :errors

    def initialize(success:, endorsement:, errors: nil)
      @success = success
      @endorsement = endorsement
      @errors = errors
    end
  end

  def initialize(policy)
    @policy = policy
  end

  def cancel
    cancellation_endorsement = nil
    ActiveRecord::Base.transaction do
      # id dos endorsements que ja foram cancelados
      cancelled_endorsement_ids = @policy.endorsements.where(tipo: "cancelamento").pluck(:cancelled_endorsement_id)

      # pegar o ultimo endorsement que nao seja de cancelamento e que nao tenha sido cancelado
      endorsement_to_cancel = @policy.endorsements
                                     .where.not(tipo: "cancelamento")
                                     .where.not(id: cancelled_endorsement_ids)
                                     .order(created_at: :desc).first

      # endorsement anterior ao cancelado que sera aplicado a apolice novamente
      endorsement_to_revert = @policy.endorsements
                                     .where("created_at < ?", endorsement_to_cancel.created_at)
                                     .where.not(tipo: "cancelamento")
                                     .where.not(id: cancelled_endorsement_ids)
                                     .order(created_at: :desc).first

      # criar um endorsement de cancelamento
      cancellation_endorsement = @policy.endorsements.new(
        data_emissao: Date.today,
        inicio_vigencia: endorsement_to_cancel.inicio_vigencia,
        fim_vigencia: endorsement_to_cancel.fim_vigencia,
        importancia_segurada: endorsement_to_cancel.importancia_segurada,
        tipo: "cancelamento",
        cancelled_endorsement: endorsement_to_cancel
      )
      cancellation_endorsement.save!

      # aplicar o endorsement de cancelamento na apolice
      @policy.apply_endorsement(endorsement_to_revert)
    end
    Result.new(success: true, endorsement: cancellation_endorsement)
  end
end
