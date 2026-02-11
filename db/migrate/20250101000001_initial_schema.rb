class CreateInitialSchema < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email_address, null: false
      t.string :password_digest, null: false
      t.integer :current_workspace_id, null: true

      t.timestamps
    end

    add_index :users, :email_address, unique: true

    create_table :sessions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :ip_address, null: false
      t.string :user_agent, null: false

      t.timestamps
    end

    create_table :workspaces do |t|
      t.string :slug, null: false
      t.text :name, null: false

      t.timestamps
    end

    add_index :workspaces, :slug, unique: true

    create_table :members do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :workspace, null: false, foreign_key: true
      t.string :slug, null: false
      t.datetime :deleted_at, null: true

      t.timestamps
    end

    add_index :members, [:slug, :workspace_id], unique: true
    add_index :members, :deleted_at, using: :brin

    create_table :roles do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :roles, :name, unique: true

    create_table :actors do |t|
      t.belongs_to :member, null: false, foreign_key: true
      t.belongs_to :role, null: false, foreign_key: true

      t.timestamps
    end

    create_table :billing_profiles do |t|
      t.belongs_to :workspace, null: false, foreign_key: true
      t.string :slug, null: true
      t.string :external_id, null: true # This would be payment provider's (Stripe's) customer_id

      t.timestamps
    end

    add_index :billing_profiles, [:slug, :workspace_id], unique: true
    add_index :billing_profiles, :external_id

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
