class CreateBillingProfileSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :billing_profile_subscriptions do |t|
      t.belongs_to :billing_profile, null: false, foreign_key: true
      t.string :slug, null: false
      t.string :subscription_id, null: false
      t.string :subscription_item_id, null: false
      t.string :status, null: false
      t.datetime :current_period_end_at, null: true
      t.datetime :cancel_at, null: true
      t.json :metadata, null: false, default: {}

      t.timestamps
    end

    add_index :billing_profile_subscriptions, [:slug, :billing_profile_id], unique: true
    add_index :billing_profile_subscriptions, :subscription_id
    add_index :billing_profile_subscriptions, :subscription_item_id
  end
end
