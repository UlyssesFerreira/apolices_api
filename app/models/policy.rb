class Policy < ApplicationRecord
  validates :numero, presence: true, uniqueness: true
  validates :data_emissao, presence: true
  validates :inicio_vigencia, presence: true
  validates :fim_vigencia, presence: true, comparison: { greater_than: :inicio_vigencia }
  validates :importancia_segurada, presence: true
  validates :lmg, presence: true, numericality: { greater_than_or_equal_to: 0 }

  validate :inicio_vigencia_within_allowed_range

  enum :status, {
    "ATIVA" => 0,
    "BAIXADA" => 1
  }

  has_many :endorsements

  def inicio_vigencia_within_allowed_range
    return if data_emissao.blank? || inicio_vigencia.blank?

    difference_in_days = (inicio_vigencia - data_emissao).to_i
    unless difference_in_days >= -30 && difference_in_days <= 30
      errors.add(:inicio_vigencia, "must be within 30 days before or after data_emissao")
    end
  end

  def build_endorsement(params)
    endorsements.new(
      data_emissao: Date.today,
      inicio_vigencia: inicio_vigencia,
      fim_vigencia: params[:fim_vigencia] || fim_vigencia,
      importancia_segurada: params[:importancia_segurada] || importancia_segurada
    )
  end

end
