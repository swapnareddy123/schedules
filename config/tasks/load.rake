namespace :users do
  
  STARTING   = ["Sherry", "Boris", "Vicente", "Matte", "Jack", "Sherry",

 "Matte", "Kevin", "Kevin", "Vicente", "Zoe", "Kevin",

 "Matte", "Zoe", "Jay", "Boris", "Eadon", "Sherry",

 "Franky", "Sherry", "Matte", "Franky", "Franky", "Kevin",

 "Boris", "Franky", "Vicente", "Luis", "Eadon", "Boris",

 "Kevin", "Matte", "Jay", "James", "Kevin", "Sherry",

 "Sherry", "Jack", "Sherry", "Jack"].collect(&:downcase)
 
  
 def next_date(date)
   date = date + 1.day
   if Schedule.holiday?(date)
     date = next_date(date)
   end
   date
 end
 
 desc "Add users & Initial schedules"
  task(:load) do
    User.delete_all
    Schedule.delete_all
    puts "Creating Users.."
    STARTING.uniq.each{|name| User.create(name: name.downcase)}
    
    date   = Date.today - 1.day
    puts "Adding Schedules.."
    STARTING.each do |name|
      
      user = User.find_by_name(name)
      # puts "Adding schedule for user: #{user.name}"
      date = Schedule.next_date(date)
      user.schedules.create(date: date)
    end
  end
end
