class AddPrecioToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :precio, :float
  end
end
