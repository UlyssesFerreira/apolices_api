class Api::PoliciesController < ApplicationController
  before_action :set_policy, only: [ :show ]

  def index
    policies = Policy.all
    render json: policies, include: :endorsements
  end

  def create
    policy = Policy.new(policy_params)
    if policy.save
      render json: policy, status: :created
    else
      render json: { errors: policy.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    if @policy
      render json: @policy, include: :endorsements
    else
      render json: { error: "Policy not found" }, status: :not_found
    end
  end

  private

  def policy_params
    params.require(:policy).permit(
      :numero,
      :data_emissao,
      :inicio_vigencia,
      :fim_vigencia,
      :importancia_segurada,
      :lmg
    )
  end

  def set_policy
    @policy = Policy.find_by(id: params[:id])
  end
end
