class EndorsementService

  class Result
    attr_reader :success, :endorsement, :errors

    def initialize(success:, endorsement:, errors: nil)
      @success = success
      @endorsement = endorsement
      @errors = errors
    end
  end

  def initialize(policy, params)
    @policy = policy
    @params = params
  end

  def create
    endorsement = nil

    ActiveRecord::Base.transaction do
      endorsement = build_endorsement
      endorsement.save!
      @policy.apply_endorsement(endorsement)
    end
    Result.new(success: true, endorsement: endorsement)
  rescue ActiveRecord::RecordInvalid => e
    Result.new(success: false, endorsement: endorsement, errors: { endorsement: endorsement.errors.full_messages, policy: @policy.errors.full_messages })
  rescue EndorsementTypeService::NoChangesError => e
    Result.new(success: false, endorsement: endorsement, errors: [ e.message ])
  end

  private

  def build_endorsement
    @policy.endorsements.new(
      data_emissao: Date.today,
      inicio_vigencia: @policy.inicio_vigencia,
      fim_vigencia: @params[:fim_vigencia] || @policy.fim_vigencia,
      importancia_segurada: @params[:importancia_segurada] || @policy.importancia_segurada,
      tipo: set_type
    )
  end

  def set_type
    EndorsementTypeService.new(
      @policy,
      @params[:importancia_segurada]&.to_d || @policy.importancia_segurada,
      @params[:fim_vigencia]&.to_date || @policy.fim_vigencia
    ).set_type
  end

end
