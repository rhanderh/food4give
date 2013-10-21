class CreateConfessions < ActiveRecord::Migration
  def change
    create_table :confessions do |t|
      t.string :item
      t.string :user_id

      t.timestamps
    end
  end
end
