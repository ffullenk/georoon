# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120922011348) do

  create_table "locations", :force => true do |t|
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps"
    t.string   "city"
    t.boolean  "internet"
    t.boolean  "lavadora"
    t.boolean  "cocina"
    t.boolean  "tvcable"
    t.text     "detalle"
    t.integer  "tpieza_id"
    t.boolean  "banioprivado"
    t.boolean  "amueblada"
    t.boolean  "portero"
    t.boolean  "estacionamiento"
    t.boolean  "balconpatio"
    t.boolean  "gimnasio"
    t.boolean  "ascensor"
    t.boolean  "telefono"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.float    "precio"
  end

  create_table "tpiezas", :force => true do |t|
    t.string   "nombre"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
