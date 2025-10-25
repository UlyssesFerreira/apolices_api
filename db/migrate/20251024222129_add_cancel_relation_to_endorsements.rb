class AddCancelRelationToEndorsements < ActiveRecord::Migration[8.0]
  def change
    add_reference :endorsements, :cancelled_endorsement, foreign_key: { to_table: :endorsements }, null: true
  end
end
