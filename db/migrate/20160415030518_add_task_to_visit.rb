class AddTaskToVisit < ActiveRecord::Migration
  def change
    add_column :visits, :task, :text
  end
end
