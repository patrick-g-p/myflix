class AddAccountStatusToUsers < ActiveRecord::Migration
  def change
    add_column :users, :account_status, :string, {:default => 'active'}
  end
end
