require 'rubygems'
require 'log4r'
require './app'

logger = Log4r::Logger.new("app")
logger.outputters << Log4r::Outputter.stderr

logger.outputters << Log4r::FileOutputter.new('app-file', :filename => 'log/app.log')
file.formatter = Log4r::PatternFormatter.new(:pattern => "[%l] %d :: %m"

logger.outputters << file

run App

# .RU stands for 'RackUp' - a utility built in with Rack that allows you to build apps that respect the Rack standards. Type 'rackup' at the Command Line to launch the server.

# log4r = Logging library, for saving logs to a file

# "app" = registering a new logger instance into a repo inside the Logger class.

# relative to config.ru

# put this into the console to update the log file: tail -f log/app.log