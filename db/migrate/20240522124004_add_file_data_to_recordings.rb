class AddFileDataToRecordings < ActiveRecord::Migration[7.1]
  def change
    add_column :recordings, :file_data, :text
  end
end
