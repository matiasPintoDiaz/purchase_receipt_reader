class CreatePurchases < ActiveRecord::Migration[8.0]
  def change
    create_table :purchases do |t|
      t.string :store_name
      t.string :store_rut
      t.integer :purchase_number
      t.date :purchase_date
      t.decimal :total_amount
      t.jsonb :items
      t.timestamps
    end
  end
end

# SE DEJA ASÍ "PURCHASES" PARA EN UN FUTURO, QUIZÁS, CREAR UNA NUEVA TABLA "RECEIPT" (?).
# SE USA JSONB PORQUE ES MÁS RÁPIDO PARA ESTE EJEMPLO, SI QUISIÉRAMOS HACER ESTUDIO DE PRODUCTOS, CONVIENE TABLA RELACIONAL.
