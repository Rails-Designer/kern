class CreateActors < ActiveRecord::Migration[8.1]
  def change
    create_table :actors do |t|
      t.belongs_to :member, null: false, foreign_key: true
      t.belongs_to :role, null: false, foreign_key: true

      t.timestamps
    end
  end
end
