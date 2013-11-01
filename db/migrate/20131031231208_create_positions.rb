class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.string :symbol
      t.float :purchase_price
      t.float :shares
      t.date :purchase_date
      t.date :sold_date
      t.float :sold_price
      t.references :user
      t.timestamps
    end
  end
end
