class Endorsement < ApplicationRecord
  belongs_to :policy
  belongs_to :cancelled_endorsement, class_name: "Endorsement", optional: true
  has_one :cancellation_endorsement, class_name: "Endorsement", foreign_key: "cancelled_endorsement_id"
end
