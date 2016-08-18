class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string 	 :name,     null: false
      t.string 	 :url, 	    null: false
      t.string 	 :status,   null: false, default: 'new'
      t.string   :group,    default: nil
      t.json   	 :setting,  default: {}
      t.json     :result,   default: {}
      t.integer  :progress, default: 0 # 0-100 
      t.boolean  :tasking,  default: false
      t.integer  :interval, default: 1800 #second
      t.integer  :pid,      default: nil
      ###
      t.integer  :user_id,  null: false
      ###
      t.datetime :start_at
      t.timestamps null: false

    end

     add_index :projects, :user_id
     add_index :projects, :group

  end
end
