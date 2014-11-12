class User < ActiveRecord::Base
  has_many  :schedules
  
  def schedule_string
    schedules.collect(&:as_string).join(', ')
  end
end