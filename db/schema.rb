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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_05_11_234648) do

  create_table "blockchains", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "index"
    t.string "hash_id"
    t.string "previous_hash"
    t.string "transactions_hash"
    t.integer "transaction_count"
    t.integer "nonce"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "timestamp"
    t.bigint "block_id"
    t.index ["block_id"], name: "index_blockchains_on_block_id"
  end

  create_table "blocks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "index"
    t.string "hash_id"
    t.integer "amount_transaction"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "group"
  end

  create_table "transactions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "from"
    t.string "to"
    t.string "what"
    t.string "qty"
    t.bigint "block_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude", limit: 53
    t.float "longitude", limit: 53
    t.string "pais"
    t.string "uf"
    t.string "cidade"
    t.string "bairro"
    t.string "rua"
    t.string "numero"
    t.string "cep"
    t.string "data"
    t.string "horario"
    t.string "endereco"
    t.index ["block_id"], name: "index_transactions_on_block_id"
  end

  add_foreign_key "blockchains", "blocks"
  add_foreign_key "transactions", "blocks"
end
