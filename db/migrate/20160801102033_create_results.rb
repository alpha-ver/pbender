class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.text     :result_text 
      t.text     :result_arr, array: true, default: []
      t.integer  :result_int

      t.boolean :success, default:false
      t.string  :log
      
      t.integer :url_id,   null:false
      t.integer :field_id, null:false

      t.timestamps null: false
    end

    add_index :results, [:url_id, :field_id], unique: true
  end


end
