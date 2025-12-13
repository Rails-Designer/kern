class CreateWorkspaces < ActiveRecord::Migration[7.0]
  def change
    create_table :workspaces do |t|
      t.string :slug, null: false
      t.text :name, null: false

      t.timestamps
    end

    add_index :workspaces, :slug, unique: true
  end
end
