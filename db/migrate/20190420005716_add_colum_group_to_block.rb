class AddColumGroupToBlock < ActiveRecord::Migration[5.2]
  def change
    add_column :blocks, :group, :string
  end
end
