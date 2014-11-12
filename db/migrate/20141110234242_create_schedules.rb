class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.datetime :date
      t.belongs_to :user
      t.timestamps
    end
    
  end
end
