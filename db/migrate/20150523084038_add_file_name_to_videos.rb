class AddFileNameToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :file_name, :string
  end
end
