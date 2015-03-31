class AddUserTextAndContentToEchos < ActiveRecord::Migration
  def change
    add_column :echos, :user_text, :string
    add_column :echos, :quoted_content, :text
  end
end
