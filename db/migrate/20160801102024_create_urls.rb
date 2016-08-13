class CreateUrls < ActiveRecord::Migration
  def change
    create_table :urls do |t|
      t.string  :url,     null:false
      t.boolean :skip,    default:false
      t.boolean :parse,   default:false
      t.boolean :duble,   default:false
      t.string  :log
      t.string  :sha

      t.integer :duble_id
      t.integer :project_id, null:false

      t.timestamps null:false
    end
    add_index :urls, :duble_id
    add_index :urls, [:project_id, :url], unique: true
  end
end
