class EndorsementCancellationService
  class NoEndorsementToCancelError < StandardError; end

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
    endorsement_to_cancel = find_last_valid_endorsement
    raise NoEndorsementToCancelError, "No valid endorsement was found to cancel" if endorsement_to_cancel.nil?
    
    cancellation_endorsement = nil
    ActiveRecord::Base.transaction do
      cancellation_endorsement = build_cancellation_endorsement(endorsement_to_cancel)
      cancellation_endorsement.save!
      @policy.apply_endorsement(cancellation_endorsement)
    end

    Result.new(success: true, endorsement: cancellation_endorsement)
  rescue ActiveRecord::RecordInvalid => e
    Result.new(success: false, endorsement: cancellation_endorsement, errors: { endorsement: cancellation_endorsement.errors.full_messages, policy: @policy.errors.full_messages })
  rescue NoEndorsementToCancelError => e
    Result.new(success: false, endorsement: cancellation_endorsement, errors: [ e.message ])
  end

  private

  def cancelled_endorsement_ids
    @policy.endorsements.where(tipo: "cancelamento").pluck(:cancelled_endorsement_id)
  end

  def find_last_valid_endorsement
    @policy.endorsements
           .where.not(tipo: "cancelamento")
           .where.not(id: cancelled_endorsement_ids)
           .order(created_at: :desc).first
  end

  def find_endorsement_to_restore(endorsement_to_cancel)
    @policy.endorsements
           .where("created_at < ?", endorsement_to_cancel.created_at)
           .where.not(tipo: "cancelamento")
           .where.not(id: cancelled_endorsement_ids)
           .order(created_at: :desc).first
  end

  def build_cancellation_endorsement(endorsement_to_cancel)
    endorsement_to_restore = find_endorsement_to_restore(endorsement_to_cancel)
    if endorsement_to_restore.nil?
      update_policy_to_baixada
      @policy.endorsements.new(
        data_emissao: Date.today,
        inicio_vigencia: @policy.inicio_vigencia,
        fim_vigencia: @policy.fim_vigencia_original,
        importancia_segurada: @policy.importancia_segurada_original,
        tipo: "cancelamento",
        cancelled_endorsement: endorsement_to_cancel
      )
    else
      @policy.endorsements.new(
        data_emissao: Date.today,
        inicio_vigencia: endorsement_to_restore.inicio_vigencia,
        fim_vigencia: endorsement_to_restore.fim_vigencia,
        importancia_segurada: endorsement_to_restore.importancia_segurada,
        tipo: "cancelamento",
        cancelled_endorsement: endorsement_to_cancel
      )
    end
  end

  def update_policy_to_baixada
    @policy.baixada!
  end
end
