class RemoveSupportIssues < ActiveRecord::Migration
  def change
    drop_table :support_issues
  end
end
