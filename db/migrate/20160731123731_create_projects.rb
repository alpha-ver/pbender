class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string 	 :name,     null: false
      t.string 	 :url, 	    null: false
 	   #t.string   :step,     null: false
      t.string 	 :status,   null: false, default: 'new'
      t.json   	 :setting,  default: {}
      t.json     :result,   default: {}
      t.integer  :progress, default: 0 # 0-100 
      t.boolean  :start,    default: false
      t.integer  :interval, default: 1800 #second
      ###
      t.integer  :user_id,  null: false
      ###
      t.datetime :start_at
      t.timestamps null: false

    end

     add_index :projects, :user_id
  end
end
