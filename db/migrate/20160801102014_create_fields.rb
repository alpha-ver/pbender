class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.string  :name
      
      t.string  :otype,     default:'text'
      t.boolean :enabled,   default:false
      t.boolean :ok,        default:false
      t.boolean :unique,    default:false
      t.boolean :required,  default:false 

      t.json    :setting

      t.integer :project_id, null:false
      t.timestamps null: false
    end

    add_index :fields, [:project_id, :name], unique: true
  end
end
