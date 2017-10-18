class AddArchiveStatusToBlogs < ActiveRecord::Migration[5.1]
  def change
    add_column :blogs, :is_archived, :boolean, default: false
  end
end
