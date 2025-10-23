class Api::EndorsementsController < ApplicationController
  before_action :set_policy

  def index
    endorsements = @policy.endorsements
    render json: endorsements
  end

  def create
    endorsement = @policy.build_endorsement(endorsement_params)

    endorsement_type = EndorsementTypeService.new(@policy, endorsement).set_type

    endorsement.tipo = endorsement_type
    @policy.importancia_segurada = endorsement.importancia_segurada
    @policy.fim_vigencia = endorsement.fim_vigencia
    @policy.lmg = @policy.importancia_segurada

    if endorsement.save && @policy.save
      render json: endorsement, status: :created
    else
      render json: { policy_errors: @policy.errors.full_messages, endorsement_errors: endorsement.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    endorsement = @policy.endorsements.find_by(id: params[:id])
    if endorsement
      render json: endorsement
    else
      render json: { error: 'Endorsement not found' }, status: :not_found
    end
  end

  private

  def endorsement_params
    params.require(:endorsement).permit(
      :importancia_segurada,
      :fim_vigencia
    )
  end

  def set_policy
    @policy = Policy.find_by(id: params[:policy_id])
  end
end
