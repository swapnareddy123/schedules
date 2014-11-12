class UsersController < MainController
  
  
  get '/superhero/?:date?' do |date|
    date = (date ? Date.parse(date) : Date.today).to_date

    @title = "Superhero on #{date}"
    schedule = Schedule.find_by_date(date)

    if schedule.nil? && Schedule.holiday?(date)
      "It's Holiday"
    elsif schedule.nil? || (schedule && schedule.user.nil?)
      "No one is scheduled on the date #{date}."
    else
      "Super Hero: #{schedule.user.name.capitalize}"
    end
  end
  
  get '/schedule/:name' do |name|
    @title = "Schedule for Superhero #{name}"
    user = User.find_by_name(name)
    "No User found" unless user
    dates = user.schedules.collect{|s| s.date.strftime('%d-%m-%Y')}.join(',')
    "#{user.name.capitalize}: #{dates}"
  end
  
  get '/schedules/current' do 
    @title = "Superheros & Schedules"
    @users = User.includes(:schedules).all
    haml :users
  end
  
  get '/schedule/undoable/:name/:date' do |name, date|
    date = Date.parse(date)
    user = User.find_by_name(name)
    schedule = user.schedules.find_by_date(date)
    success = schedule.swap_with_next
    
    success ? "Successfully rescheduled to Next day" : "Unable to undo"
  end 
  
  get "/schedule/:for_name/:for_date/swap/:to_name/:to_date" do |for_name, for_date, to_name, to_date|
    for_date = for_date.to_date
    for_user = User.find_by_name(for_name)
    byebug
    schedule = for_user.schedules.find_by_date(for_date)
    
    to_date = to_date.to_date
    to_user = User.find_by_name(to_name)
    to_schedule = to_user.schedules.find_by_date(to_date)
    
    success = schedule.swap_with(to_schedule)
    
    success ? "Successfulyy swapped with #{to_name} - #{to_date}" : "Unable to swap"
    
  end
end