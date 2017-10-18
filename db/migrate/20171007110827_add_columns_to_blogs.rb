class AddColumnsToBlogs < ActiveRecord::Migration[5.1]
  def change
    add_column :blogs, :is_published, :boolean, default: false
    add_reference :blogs, :user, foreign_key: true
  end
end
