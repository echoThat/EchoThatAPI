class RemoveContactForms < ActiveRecord::Migration
  def change
      drop_table :contact_forms
  end
end
