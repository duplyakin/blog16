class AddLevelColumnToComments < ActiveRecord::Migration
  def change
    add_column :comments, :level, :integer
  end
end
