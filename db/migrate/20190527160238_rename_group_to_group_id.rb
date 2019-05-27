class RenameGroupToGroupId < ActiveRecord::Migration[5.2]
  def change
    rename_column :blocks, :group, :group_id
  end
end
