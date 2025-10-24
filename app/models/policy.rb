class Policy < ApplicationRecord
  validates :numero, presence: true, uniqueness: true
  validates :data_emissao, presence: true
  validates :inicio_vigencia, presence: true
  validates :fim_vigencia, presence: true, comparison: { greater_than: :inicio_vigencia }
  validates :importancia_segurada, presence: true, numericality: { greater_than_or_equal_to: 0 }
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

  def apply_endorsement(endorsement)
    self.importancia_segurada = endorsement.importancia_segurada
    self.fim_vigencia = endorsement.fim_vigencia
    save!
  end

end
