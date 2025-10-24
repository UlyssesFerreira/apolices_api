class Endorsement < ApplicationRecord
  after_create :sync_policy_lmg, if: :importancia_segurada_changed?
  belongs_to :policy

  private

  def sync_policy_lmg
    policy.update(lmg: importancia_segurada)
  end

  def importancia_segurada_changed?
    self.importancia_segurada != policy.importancia_segurada
  end
end
