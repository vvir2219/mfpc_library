class CreateBorrows < ActiveRecord::Migration[5.1]
  def change
    create_table :borrows do |t|
      t.references :book, foreign_key: true
      t.references :member, foreign_key: true
      t.date :expiration_date
      t.date :returned_at

      t.timestamps
    end
  end
end
