class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string :address
      t.float :latitude
      t.float :longitude
      t.boolean :gmaps
      t.string :city
      t.boolean :internet
      t.boolean :lavadora
      t.boolean :cocina
      t.boolean :tvcable
      t.text :detalle
      t.integer :tpieza_id
      t.boolean :banioprivado
      t.boolean :amueblada
      t.boolean :portero
      t.boolean :estacionamiento
      t.boolean :balconpatio
      t.boolean :gimnasio
      t.boolean :ascensor
      t.boolean :telefono

      t.timestamps
    end
  end
end
