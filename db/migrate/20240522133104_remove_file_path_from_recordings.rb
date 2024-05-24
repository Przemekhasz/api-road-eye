class RemoveFilePathFromRecordings < ActiveRecord::Migration[6.0]
  def change
    remove_column :recordings, :file_path, :string
  end
end
