class CreatePlugins < ActiveRecord::Migration
  def change
    create_table :plugins do |t|
      t.string  :name
      t.json    :setting
      t.string  :class_name
      t.integer :user_id

      t.timestamps null: false
    end

  end
end
