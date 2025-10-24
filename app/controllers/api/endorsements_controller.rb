class Api::EndorsementsController < ApplicationController
  before_action :set_policy

  def index
    endorsements = @policy.endorsements
    render json: endorsements
  end

  def create
    endorsement_service = EndorsementService.new(@policy, endorsement_params)
    result = endorsement_service.create

    if result.success
      render json: result.endorsement, status: :created
    else
      render json: { errors: result.errors }, status: :unprocessable_entity
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
