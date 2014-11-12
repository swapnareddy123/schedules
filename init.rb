require 'bundler'

ENV['RACK_ENV'] ||= 'development'
envs = ['default', ENV['RACK_ENV']]
Bundler.require(*envs)

# $: is just a shortcut for $LOAD_PATH, So Adding current directory to Load Path
$:.unshift '.'

APP_ROOT = File.dirname(__FILE__)
Dir['app/**/**.rb'].each do |file|
  require file
end


configure do
  set :root, File.dirname(__FILE__)
end
