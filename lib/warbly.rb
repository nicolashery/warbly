require 'bundler/setup' # Necessary for Heroku buildpack
require 'chronic'
require 'java'

require 'log4j-1.2.13.jar'

java_import 'org.apache.log4j.Logger'
java_import 'org.apache.log4j.BasicConfigurator'


class Warbly
  
  def initialize
    @logger = Logger.getLogger('warbly')
    BasicConfigurator.configure()
  end

  def run
    @logger.info "Today is #{Chronic.parse('today')}"
    i = 1
    loop do
      @logger.info "Working.. #{i}"
      i = i + 1
      sleep 5
    end
  end

end
