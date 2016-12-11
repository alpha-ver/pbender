class AddProjectTemplate < ActiveRecord::Migration
  def change
    add_column :projects, :template, :boolean, default: false 
  end
end
