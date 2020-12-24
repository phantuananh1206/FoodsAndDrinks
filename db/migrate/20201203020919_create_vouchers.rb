class CreateVouchers < ActiveRecord::Migration[6.0]
  def change
    create_table :vouchers do |t|
      t.string :name
      t.float :discount
      t.float :condition

      t.timestamps
    end
  end
end
