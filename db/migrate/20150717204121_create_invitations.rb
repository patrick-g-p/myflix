class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :inviter_id
      t.string :recipients_name, :recipients_email, :invitation_token
      t.timestamps
    end
  end
end
