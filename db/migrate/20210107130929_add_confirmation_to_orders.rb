class AddConfirmationToOrders < ActiveRecord::Migration[6.0]
  def change
    add_column :orders, :confirmation_digest, :string
    add_column :orders, :confirm_sent_at, :datetime
    add_column :orders, :confirmed_at, :datetime
  end
end
