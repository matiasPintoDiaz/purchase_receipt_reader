class AddStatusToPurchases < ActiveRecord::Migration[8.0]
  def change
    add_column :purchases, :status, :string, default: 'processing'
  end
end
