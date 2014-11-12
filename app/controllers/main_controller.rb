class MainController < Sinatra::Base
  set :views, Proc.new { File.join(::APP_ROOT, 'app', 'views')}
end