class CreateUserActions < ActiveRecord::Migration
  def change
    create_table :user_actions do |t|
      t.integer :user_id 
      t.string  :description
      t.timestamps
    end
  end
end
