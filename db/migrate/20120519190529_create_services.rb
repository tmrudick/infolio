class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :name
      t.string :token
      t.integer :user_id

      t.timestamps
    end
  end
end
