require 'bundler/setup' 

APP_ENV = ENV.fetch('APP_ENV', 'development')

Bundler.require(:default, APP_ENV)

ActiveRecord::Base.schema_format = :sql
ActiveRecord::Base.logger = Logger.new($stdout)
ActiveRecord::Base.configurations = YAML.load(ERB.new(File.read('db/config.yml')).result)
ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[APP_ENV])

Dir["./model/**.rb"].each { |f| require f }
