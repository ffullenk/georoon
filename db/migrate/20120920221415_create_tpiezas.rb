class CreateTpiezas < ActiveRecord::Migration
  def change
    create_table :tpiezas do |t|
      t.string :nombre

      t.timestamps
    end
  end
end
