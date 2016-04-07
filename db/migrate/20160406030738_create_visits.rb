class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.integer :user_id
      t.boolean :active
      t.datetime :arrival
      t.datetime :departure

      t.timestamps
    end
  end
end
