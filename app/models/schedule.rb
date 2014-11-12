class Schedule < ActiveRecord::Base
  belongs_to :user
  
  holidays    = ['11-11-2014', '27-11-2014', '28-11-2014', '25-12-2014', '1-1-2015', '19-1-2015', '16-02-2015',
    '31-03-2015','25-05-2015','04-07-2015','07-09-2015','11-11-2015','26-11-2015','27-11-2015','25-12-2015',
  ]
 
  CA_HOLIDAYS = holidays.collect{|h| Date.parse(h)}
  
  validates :date, uniqueness: true
  
  def self.holiday?(date)
    date = Date.parse(date) if date.is_a?(String)
    date.saturday? || date.sunday? || CA_HOLIDAYS.include?(date)
  end
  
  def as_string
    date.strftime('%d-%m-%Y')
  end
  
  def self.next_date(date)
    date = date + 1.day
    if Schedule.holiday?(date)
      date = next_date(date)
    end
    date
  end  
  
  def swap_with(schedule)
    begin
      ActiveRecord::Base.transaction do
        to_user_id = schedule.user_id
        schedule.user_id = user_id
        schedule.save!
        self.user_id = to_user_id
        self.save!
      end
    rescue
      false
    end
    true
  end
  
  
  def swap_with_next
    schedule = Schedule.find_by_date(Schedule.next_date(date).to_date)
    swap_with(schedule)
  end
  
  
end