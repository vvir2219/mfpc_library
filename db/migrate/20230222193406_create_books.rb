class CreateBooks < ActiveRecord::Migration[5.1]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.boolean :available, default: true

      t.timestamps
    end
  end
end
