class AddUserIdToGroups < ActiveRecord::Migration[6.1]
  def change
    add_reference :groups, :user, foreign_key: true
  end
end