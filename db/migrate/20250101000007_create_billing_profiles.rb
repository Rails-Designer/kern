class CreateBillingProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :billing_profiles do |t|
      t.belongs_to :workspace, null: false, foreign_key: true
      t.string :slug, null: true
      t.string :external_id, null: true # This would be payment provider's (Stripe's) customer_id

      t.timestamps
    end

    add_index :billing_profiles, [:slug, :workspace_id], unique: true
    add_index :billing_profiles, :external_id
  end
end
