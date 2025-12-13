class CreateMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :members do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.belongs_to :workspace, null: false, foreign_key: true
      t.string :slug, null: false
      t.datetime :deleted_at, null: true

      t.timestamps
    end

    add_index :members, [:slug, :workspace_id], unique: true
    add_index :members, :deleted_at, using: :brin
  end
end
