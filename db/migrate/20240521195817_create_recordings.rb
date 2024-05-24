class CreateRecordings < ActiveRecord::Migration[7.1]
  def change
    create_table :recordings do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :file_path
      t.string :file_format
      t.integer :duration

      t.timestamps
    end
  end
end
